#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"
#include "stat.h"
#include "file.h"
//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
struct inode* create(char *path, short type, short major, short minor);
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
uint64 a;

  if(va_end < va_start)
    return va_start;

  va_start = PGROUNDUP(va_start);
  for(a = va_start; a < va_end; a += PGSIZE){
    pte_t *pte = walk(pagetable, a, 1);
    if(pte == 0){
      // In case of failure, we don't have a simple way to deallocate just this segment,
      // so we let kexec handle the full cleanup.
      return 0;
    }
    // Mark as User-accessible with given permissions, but NOT valid (PTE_V=0).
    *pte = PTE_U | xperm;
  }
  return va_end;
}
// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    int perm = 0;
    if(flags & 0x1)
      perm = PTE_X;
    if(flags & 0x2)
      perm |= PTE_W;
    if(flags & ELF_PROG_FLAG_READ)
      perm |= PTE_R;
    return perm;
}
void
itoa(int n, char *buf, int min_width)
{
  int i = 0;
  if (n == 0) {
    buf[i++] = '0';
  } else {
    // Generate digits in reverse order.
    while(n > 0){
      buf[i++] = (n % 10) + '0';
      n /= 10;
    }
  }

  // Add padding if needed.
  while(i < min_width){
    buf[i++] = '0';
  }

  buf[i] = '\0';

  // Reverse the entire string to get the correct order.
  for(int j = 0; j < i/2; j++){
    char temp = buf[j];
    buf[j] = buf[i-j-1];
    buf[i-j-1] = temp;
  }
}


char*
strcat(char *dest, const char *src)
{
    char *d = dest;
    // Move pointer to the end of the destination string.
    while (*d) {
        d++;
    }
    // Copy characters from source to the end of destination.
    while ((*d++ = *src++)) {
        ;
    }
    return dest;
}

//
// the implementation of the exec() system call
//
// In kernel/exec.c, replace the existing kexec function

int
kexec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
  char pid_str[16];
  char swap_path[32];
  safestrcpy(swap_path,"/pgswp",sizeof(swap_path));
  safestrcpy(p->swap_path,swap_path,sizeof(swap_path));
  itoa(p->pid,pid_str,5);
  strcat(swap_path,pid_str);
  uint64 text_start = -1, text_end = 0;
  uint64 data_start = -1, data_end = 0;

  begin_op();
  // 'create' returns an inode pointer (the on-disk representation).
 ip = create(swap_path, T_FILE, 0, 0);
  if(ip == 0){
    end_op();
    goto bad;
  }

  // Allocate a 'file' structure (the in-memory handle).
  if((p->swap_file = filealloc()) == 0){
    iunlockput(ip); // Clean up the created inode if filealloc fails.
    end_op();
    goto bad;
  }

  // Configure the file handle.
  p->swap_file->type = FD_INODE;
  p->swap_file->ip = ip; // Link the handle to the on-disk inode.
  p->swap_file->readable = 1;
  p->swap_file->writable = 1;

  iunlock(ip ); // Unlock the inode; create() returns it locked.
  end_op();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
   // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;

  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pagetable = proc_pagetable(p)) == 0)
    goto bad;


  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
          goto bad;
      if(ph.type != ELF_PROG_LOAD)
          continue;
      if(ph.memsz < ph.filesz)
          goto bad;
      if(ph.vaddr + ph.memsz < ph.vaddr)
          goto bad;
      if(ph.vaddr % PGSIZE != 0)
          goto bad;
      if (ph.flags & ELF_PROG_FLAG_EXEC) { // Text segment
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
          if (ph.vaddr + ph.memsz > text_end) text_end = ph.vaddr + ph.memsz;
      } else { // Data segment
          if (data_start == -1 || ph.vaddr < data_start) data_start = ph.vaddr;
          if (ph.vaddr + ph.memsz > data_end) data_end = ph.vaddr + ph.memsz;
      } 
      if((ulazymalloc(pagetable, ph.vaddr, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
          goto bad;
      if(ph.vaddr + ph.memsz > sz)
          sz = ph.vaddr + ph.memsz;
  }
  p->exec_ip = idup(ip);
  p->num_phdrs = elf.phnum;
  
  if(readi(ip, 0, (uint64)p->phdrs, elf.phoff, sizeof(struct proghdr) * p->num_phdrs) != sizeof(struct proghdr) * p->num_phdrs)
    goto bad;
  iunlockput(ip);
  end_op();
  ip = 0;

  p = myproc();
  uint64 oldsz = p->sz;
  p->heap_start = sz;


  // Allocate stack.
  sz = PGROUNDUP(sz);
  uint64 sz1;
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
      goto bad;
  sz = sz1;
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
  sp = sz;
  stackbase = sp - USERSTACK*PGSIZE;
  p->text_start = text_start;
  p->text_end = text_end;
  p->data_start = data_start;
  p->data_end = data_end;
  p->stack_top = sp;
  printf("[pid %d] INIT-LAZYMAP text=[0x%lx,0x%lx) data=[0x%lx,0x%lx) heap_start=0x%lx stack_top=0x%lx\n",
          p->pid, text_start, text_end, data_start, data_end, p->heap_start, sz);

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
      if(argc >= MAXARG)
          goto bad;
      sp -= strlen(argv[argc]) + 1;
      sp -= sp % 16; // riscv sp must be 16-byte aligned
      if(sp < stackbase)
          goto bad;
      if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
          goto bad;
      ustack[argc] = sp;
      printf("sp = 0x%lx and sb = 0x%lx\n",sp,stackbase);
  }
  ustack[argc] = 0;


  // push a copy of ustack[]
  sp -= (argc+1) * sizeof(uint64);
  sp -= sp % 16;
  if(sp < stackbase)
      goto bad;
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
      goto bad;

  // arguments to user main(argc, argv)
  // argc is returned via the system call return
  // value, which goes in a0.
  p->trapframe->a1 = sp;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
      if(*s == '/')
          last = s+1;
  safestrcpy(p->name, last, sizeof(p->name));

  // Commit to the user image.
  oldpagetable = p->pagetable;
  p->num_resident = 0; 
  p->next_fifo_seq = 0;
  p->pagetable = pagetable;
  p->sz = sz;
  p->trapframe->epc = elf.entry;
  p->trapframe->sp = sp;
  proc_freepagetable(oldpagetable, oldsz);
  return argc;

bad:
  if(pagetable)
      proc_freepagetable(pagetable, sz);
  if(ip){
      iunlockput(ip);
      end_op();
  }
  return -1;
}

// Load an ELF program segment into pagetable at virtual address va.
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
/*static int
  loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
  {
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
  pa = walkaddr(pagetable, va + i);
  if(pa == 0)
  panic("loadseg: address should exist");
  if(sz - i < PGSIZE)
  n = sz - i;
  else
  n = PGSIZE;
  if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
  return -1;
  }

  return 0;
  }*/
