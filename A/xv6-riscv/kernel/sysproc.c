#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"
#include "memstat.h"
// In kernel/sysproc.c (add at the end of the file)


uint64
sys_memstat(void)
{
  uint64 info_ptr;
  struct proc *p = myproc();
  struct proc_mem_stat k_info; // Kernel-space copy of the struct

  argaddr(0, &info_ptr);

  // 1. Fill in the basic process-wide statistics.
  k_info.pid = p->pid;
  k_info.num_resident_pages = p->num_resident;
  k_info.num_swapped_pages = p->num_swappped_pages;
  k_info.next_fifo_seq = p->next_fifo_seq;
  k_info.num_pages_total = p->sz / PGSIZE;

  // 2. Iterate through the process's virtual pages to get per-page stats.
  int page_count = 0;
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    k_info.pages[page_count].va = va;
    k_info.pages[page_count].state = UNMAPPED;
    k_info.pages[page_count].is_dirty = 0;
    k_info.pages[page_count].seq = -1;
    k_info.pages[page_count].swap_slot = -1;

    // Is the page resident?
    int is_res = 0;
    for (int i = 0; i < p->num_resident; i++) {
      if (p->resident_pages[i].va == va) {
        k_info.pages[page_count].state = RESIDENT;
        k_info.pages[page_count].is_dirty = p->resident_pages[i].dirty;
        k_info.pages[page_count].seq = p->resident_pages[i].seq;
        is_res = 1;
        break;
      }
    }
    if (is_res) continue;

    // Is the page swapped?
    for (int i = 0; i < p->num_swappped_pages; i++) {
      if (p->swapped_pages[i].va == va) {
        k_info.pages[page_count].state = SWAPPED;
        k_info.pages[page_count].swap_slot = p->swapped_pages[i].slot;
        break;
      }
    }
  }

  // 3. Copy the completed structure to the user-provided pointer.
  if (copyout(p->pagetable, info_ptr, (char *)&k_info, sizeof(k_info)) < 0)
    return -1;

  return 0;
}
uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;

  if (n > 0) {
    if(addr + n < addr || addr + n > TRAPFRAME) // Check for overflow or exceeding max address
      return -1;
    myproc()->sz += n;
  } else if (n < 0) {
    // For negative n, we deallocate memory as before.
    myproc()->sz = uvmdealloc(myproc()->pagetable, myproc()->sz, myproc()->sz + n);
  }
   
  /* 
  addr = myproc()->sz;
  if(growproc(n) < 0) {
    return -1;
  }
  */
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
