#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"
#include "fs.h"
#include "stat.h"
struct inode* create(char *path, short type, short major, short minor);
//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
static void
itoa(int n, char *buf)
{
  int i = 0;
  char temp[10];
  if (n == 0) {
    buf[0] = '0';
    buf[1] = '\0';
    return;
  }
  
  do {
    temp[i++] = (n % 10) + '0';
    n /= 10;
  } while (n > 0);
  
  // Reverse the string
  int k = 0;
  for (int j = i - 1; j >= 0; j--) {
    buf[k++] = temp[j];
  }
  buf[k] = '\0';
}


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
  uint64 text_start = -1, text_end = 0;
  uint64 data_start = -1, data_end = 0;


  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
  p->exec_ip = idup(ip);
  char swap_path[32];
  char pid_str[10];
  
  // Copy the base path "/pgswp"
  safestrcpy(swap_path, "/pgswp", sizeof(swap_path));
  
  // Convert PID to string
  itoa(p->pid, pid_str);
  
  // Manually append the PID string to the path
  char *ptr = swap_path + strlen(swap_path);
  char *s1 = pid_str;
  while(*s1) {
    *ptr++ = *s1++;
  }
  *ptr = '\0';
  
  p->swap_file = create(swap_path, T_FILE, 0, 0);
  if(p->swap_file == 0){
    iunlockput(ip);
    end_op();
    return -1;
  }
  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  p->num_phdrs = elf.phnum;
  if(readi(ip, 0, (uint64)p->phdrs, elf.phoff, sizeof(struct proghdr) * p->num_phdrs) != sizeof(struct proghdr) * p->num_phdrs)
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
