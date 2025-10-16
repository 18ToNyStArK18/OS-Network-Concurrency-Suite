#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "elf.h"
#include "riscv.h"
#include "defs.h"
#include "spinlock.h"
#include "proc.h"
#include "fs.h"

/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S
// Add this entire new function to the end of kernel/vm.c
int handle_pgfault(pagetable_t pagetable, uint64 va)
{
  struct proc *p = myproc();
  char *mem;
  pte_t *pte;

  if(va >= MAXVA)
    return -1;

  va = PGROUNDDOWN(va);
  pte = walk(pagetable, va, 0);

  // --- 1. HANDLE SWAP-IN ---
  // If the page is on disk, we must bring it back into memory.
  if(pte != 0 && (*pte & PTE_SWAPPED)) {
    int swap_slot = (*pte >> 10); // Extract swap slot from PTE
    
    printf("[pid %d] Need to get the data from the swap space\n",p->pid);
    // Allocate a page to read the data into.
    mem = kalloc();
    if(mem == 0) {
      // Out of memory. For simplicity, we fail. A more advanced kernel
      // might trigger an eviction here before swapping in.
      panic("1\n");
      return -1;
    }

    // Read the page from the swap file.
    ilock(p->swap_file);
    if(readi(p->swap_file, 0, (uint64)mem, swap_slot * PGSIZE, PGSIZE) != PGSIZE) {
      iunlock(p->swap_file);
      kfree(mem);
      return -1;
    }
    iunlock(p->swap_file);

    // Map the new page into the page table with the original permissions.
    if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_FLAGS(*pte) | PTE_V) != 0) {
      kfree(mem);
      return -1;
    }
    
    // Clear the SWAPPED flag and mark the swap slot as free.
    *pte &= ~PTE_SWAPPED;
    p->swap_slots[swap_slot] = 0;
    
    return 0; // Swap-in successful
  }

  // --- 2. HANDLE NORMAL FAULT / EVICTION ---
  
  // Try to allocate a new physical page.
  mem = kalloc();

  if(mem == 0) {
    // --- Out of memory: Trigger Page Replacement ---
    panic("[pid ] MEMFULL\n");

    int victim_index = find_fifo_victim();
    if(victim_index < 0) return -1;

    uint64 victim_va = p->resident_pages[victim_index];
    int victim_seq = p->fifo_seq[victim_index];
    printf("[pid %d] VICTIM va=0x%lx seq=%d algo=FIFO\n", p->pid, victim_va, victim_seq);

    pte_t *victim_pte = walk(pagetable, victim_va, 0);
    if(victim_pte == 0) return -1;
    uint64 pa_to_free = PTE2PA(*victim_pte);
    if(*victim_pte & PTE_D) { // Is the page dirty?
      printf("[pid %d] EVICT va=0x%lx state=dirty\n", p->pid, victim_va);
      
      int swap_slot = -1;
      for(int i = 0; i < MAX_SWAP_PAGES; i++){ if(p->swap_slots[i] == 0) { swap_slot = i; break; } }

      if(swap_slot == -1) {
        printf("[pid %d] SWAPFULL\n", p->pid);
        printf("[pid %d] KILL swap-exhausted\n", p->pid);
        return -1;
      }

      printf("[pid %d] SWAPOUT va=0x%lx slot=%d\n", p->pid, victim_va, swap_slot);
      ilock(p->swap_file);
      // Use the saved physical address 'pa_to_free' to write to the file.
      if(writei(p->swap_file, 0, pa_to_free, swap_slot * PGSIZE, PGSIZE) != PGSIZE) {
        iunlock(p->swap_file);
        return -1;
      }
      iunlock(p->swap_file);
      
      // Update PTE: store slot, set SWAPPED flag, clear VALID flag.
      *victim_pte = (swap_slot << 10) | (PTE_FLAGS(*victim_pte) & ~PTE_V) | PTE_SWAPPED;
      p->swap_slots[swap_slot] = 1;

    } else { // Page is clean.
      printf("[pid %d] EVICT va=0x%lx state=clean\n", p->pid, victim_va);
      printf("[pid %d] DISCARD va=0x%lx\n", p->pid, victim_va);
      *victim_pte &= ~PTE_V; // Just mark as not valid, leaving other flags intact.
    }
    
   // uvmunmap(pagetable, victim_va, 1, 1); // Free the physical page.
    kfree((void*)pa_to_free);
    // Remove victim from resident set.
    for (int i = victim_index; i < p->resident_page_count - 1; i++) {
        p->resident_pages[i] = p->resident_pages[i+1];
        p->fifo_seq[i] = p->fifo_seq[i+1];
    }
    p->resident_page_count--;
    
    mem = kalloc(); // Try again. Should succeed now.
    if(mem == 0){
        panic("Nigga what\n");
        return -1;
    }
  }

  // --- 3. At this point, we have a free page in 'mem'. Load it. ---
  int is_exec_segment = (va < p->heap_start);
  int is_heap = (va >= p->heap_start && va < p->sz);
  // Note: A robust stack check should also ensure va < p->sz
  int is_stack = (va >= p->trapframe->sp - PGSIZE && va < p->sz); 

  // Now, use a clean if-else if chain to act.
  if (is_exec_segment) {
      // We've determined it's a text/data segment. Now, find the specific header.
      struct proghdr ph;
      int found = 0;
      for(int i = 0; i < p->num_phdrs; i++) {
          // Use the saved program headers, don't re-read the file!
          ph = p->phdrs[i]; 
          if(va >= ph.vaddr && va < ph.vaddr + ph.memsz) {
              found = 1;
              break;
          }
      }
      if(!found) { kfree(mem); return -1; } // Should not happen if heap_start is correct

      // You already have 'mem' from the eviction logic. DO NOT call kalloc() again.
      // if(mem == 0) { return -1; } // This check is redundant.

      memset(mem, 0, PGSIZE);

      uint file_offset = ph.off + (va - ph.vaddr);
      // Correctly calculate how much to read from the file.
      uint to_read = (ph.vaddr + ph.filesz > va) ? ph.filesz - (va - ph.vaddr) : 0;
      if(to_read > PGSIZE) to_read = PGSIZE;

      ilock(p->exec_ip);
      if(readi(p->exec_ip, 0, (uint64)mem, file_offset, to_read) != to_read) {
          iunlock(p->exec_ip);
          kfree(mem); 
          return -1;
      }
      iunlock(p->exec_ip);

      if(mappages(pagetable, va, PGSIZE, (uint64)mem, flags2perm(ph.flags) | PTE_U) != 0) {
          kfree(mem); 
          return -1;
      }
  }
  else if (is_heap || is_stack) {
      // You already have 'mem'. DO NOT call kalloc() again.
      // if(mem == 0) { return -1; }

      memset(mem, 0, PGSIZE);
      if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_U|PTE_R) != 0) {
          kfree(mem); 
          return -1;
      }
  }
  else {
      // Invalid address. We allocated a page we don't need, so free it.
      kfree(mem);
      return -1;
  }
  return 0;
}

// Make a direct-map page table for the kernel.
    pagetable_t
kvmmake(void)
{
    pagetable_t kpgtbl;

    kpgtbl = (pagetable_t) kalloc();
    memset(kpgtbl, 0, PGSIZE);

    // uart registers
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

    // virtio mmio disk interface
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

    // PLIC
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);

    // map kernel text executable and read-only.
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

    // map kernel data and the physical RAM we'll make use of.
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

    // allocate and map a kernel stack for each process.
    proc_mapstacks(kpgtbl);

    return kpgtbl;
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
    void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
        panic("kvmmap");
}

// Initialize the kernel_pagetable, shared by all CPUs.
    void
kvminit(void)
{
    kernel_pagetable = kvmmake();
}

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
    void
kvminithart()
{
    // wait for any previous writes to the page table memory to finish.
    sfence_vma();

    w_satp(MAKE_SATP(kernel_pagetable));

    // flush stale entries from the TLB.
    sfence_vma();
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
    pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    if(va >= MAXVA)
        panic("walk");

    for(int level = 2; level > 0; level--) {
        pte_t *pte = &pagetable[PX(level, va)];
        if(*pte & PTE_V) {
            pagetable = (pagetable_t)PTE2PA(*pte);
        } else {
            if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
                return 0;
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
    uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if(va >= MAXVA)
        return 0;

    pte = walk(pagetable, va, 0);
    if(pte == 0)
        return 0;
    if((*pte & PTE_V) == 0)
        return 0;
    if((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
    int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    uint64 a, last;
    pte_t *pte;

    if((va % PGSIZE) != 0)
        panic("mappages: va not aligned");

    if((size % PGSIZE) != 0)
        panic("mappages: size not aligned");

    if(size == 0)
        panic("mappages: size");

    a = va;
    last = va + size - PGSIZE;
    for(;;){
        if((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        if(*pte & PTE_V)
            panic("mappages: remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if(a == last)
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}

// create an empty user page table.
// returns 0 if out of memory.
    pagetable_t
uvmcreate()
{
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    if(pagetable == 0)
        return 0;
    memset(pagetable, 0, PGSIZE);
    return pagetable;
}

// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
    void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    uint64 a;
    pte_t *pte;

    if((va % PGSIZE) != 0)
        panic("uvmunmap: not aligned");

    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
        if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
            continue;   
        if((*pte & PTE_V) == 0)  // has physical page been allocated?
            continue;
        if(do_free){
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        *pte = 0;
    }
}

// Allocate PTEs and physical memory to grow a process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
    uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
    char *mem;
    uint64 a;

    if(newsz < oldsz)
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    for(a = oldsz; a < newsz; a += PGSIZE){
        mem = kalloc();
        if(mem == 0){
            uvmdealloc(pagetable, a, oldsz);
            return 0;
        }
        memset(mem, 0, PGSIZE);
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
            kfree(mem);
            uvmdealloc(pagetable, a, oldsz);
            return 0;
        }
    }
    return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    if(newsz >= oldsz)
        return oldsz;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
    void
freewalk(pagetable_t pagetable)
{
    // there are 2^9 = 512 PTEs in a page table.
    for(int i = 0; i < 512; i++){
        pte_t pte = pagetable[i];
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
            freewalk((pagetable_t)child);
            pagetable[i] = 0;
        } else if(pte & PTE_V){
            panic("freewalk: leaf");
        }
    }
    kfree((void*)pagetable);
}

// Free user memory pages,
// then free page-table pages.
    void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    if(sz > 0)
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    freewalk(pagetable);
}

// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
    int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for(i = 0; i < sz; i += PGSIZE){
        if((pte = walk(old, i, 0)) == 0)
            continue;   // page table entry hasn't been allocated
        if((*pte & PTE_V) == 0){
            pte_t *child_pte = walk(new,i,1);
            if(child_pte == 0)
                goto err;
            *child_pte = *pte;
            continue;
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto err;
        memmove(mem, (char*)pa, PGSIZE);
        if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
            kfree(mem);
            goto err;
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    return -1;
}

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
    void
uvmclear(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    if(pte == 0)
        panic("uvmclear");
    *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
    int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;
    pte_t *pte;

    while(len > 0){
        va0 = PGROUNDDOWN(dstva);
        if(va0 >= MAXVA)
            return -1;

        pa0 = walkaddr(pagetable, va0);
        if(pa0 == 0) {
            if(handle_pgfault(pagetable, va0) != 0) {
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); // Retry getting the address
            if(pa0 == 0) 
                return -1;

        }

        pte = walk(pagetable, va0, 0);
        // forbid copyout over read-only user text pages.
        if((*pte & PTE_W) == 0)
            return -1;

        n = PGSIZE - (dstva - va0);
        if(n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);

        len -= n;
        src += n;
        dstva = va0 + PGSIZE;
    }
    return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
    int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while(len > 0){
        va0 = PGROUNDDOWN(srcva);
        pa0 = walkaddr(pagetable, va0);
        if(pa0 == 0) {
            if(handle_pgfault(pagetable, va0) != 0) {
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); 
            if(pa0 == 0)
                return -1;
        }
        n = PGSIZE - (srcva - va0);
        if(n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);

        len -= n;
        dst += n;
        srcva = va0 + PGSIZE;
    }
    return 0;
}

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
    int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;
    while(got_null == 0 && max > 0){
        va0 = PGROUNDDOWN(srcva);
        pa0 = walkaddr(pagetable, va0);
        if(pa0 == 0){
            if(handle_pgfault(pagetable, va0) != 0) {
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); // Retry
            if(pa0 == 0) return -1;
        }
        n = PGSIZE - (srcva - va0);
        if(n > max)
            n = max;
        char *p = (char *) (pa0 + (srcva - va0));
        while(n > 0){
            if(*p == '\0'){
                *dst = '\0';
                got_null = 1;
                break;
            } else {
                *dst = *p;
            }
            --n;
            --max;
            p++;
            dst++;
        }
        srcva = va0 + PGSIZE;
    }
    if(got_null){
        return 0;
    } else {
        return -1;
    }
}
// allocate and map user memory if process is referencing a page
// that was lazily allocated in sys_sbrk().
// returns 0 if va is invalid or already mapped, or if
// out of physical memory, and physical address if successful.


    int
ismapped(pagetable_t pagetable, uint64 va)
{
    pte_t *pte = walk(pagetable, va, 0);
    if (pte == 0) {
        return 0;
    }
    if (*pte & PTE_V){
        return 1;
    }
    return 0;
}
