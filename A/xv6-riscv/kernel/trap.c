#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"
struct spinlock tickslock;
uint ticks;

extern char trampoline[], uservec[];

// in kernelvec.S, calls kerneltrap().
void kernelvec();
int flags2perm(int flags);

extern int devintr();

void
trapinit(void)
{
  initlock(&tickslock, "time");
}

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    w_stvec((uint64)kernelvec);
}

//
// handle an interrupt, exception, or system call from user space.
// called from, and returns to, trampoline.S
// return value is user satp for trampoline.S to switch to.
//
    uint64
usertrap(void)
{
    int which_dev = 0;

    if((r_sstatus() & SSTATUS_SPP) != 0)
        panic("usertrap: not from user mode");

    // send interrupts and exceptions to kerneltrap(),
    // since we're now in the kernel.
    w_stvec((uint64)kernelvec);  //DOC: kernelvec

    struct proc *p = myproc();

    // save user program counter.
    p->trapframe->epc = r_sepc();

    if(r_scause() == 8){
        // system call

        if(killed(p))
            kexit(-1);

        // sepc points to the ecall instruction,
        // but we want to return to the next instruction.
        p->trapframe->epc += 4;

        // an interrupt will change sepc, scause, and sstatus,
        // so enable only now that we're done with those registers.
        intr_on();

        syscall();
    } else if((which_dev = devintr()) != 0){
        // ok
    }else if((r_scause() == 12 || r_scause() == 15 || r_scause() == 13)) { // Page fault occurred
        uint64 va = r_stval();
        if(va >= MAXVA)
            kexit(-1);
        pte_t *pte = walk(p->pagetable, va, 0);

        // CASE 1: Minor Fault (Trap-on-Write).
        // The page is already in memory, but we tried to write to it.
        if(r_scause() == 15 && pte != 0 && (*pte & PTE_V) && !(*pte & PTE_W)) {

            // Check if the original segment was meant to be writable.
            int can_write = 0;
            uint64 page_va = PGROUNDDOWN(va);

            // For heap and stack, writes are always allowed.
            if (page_va >= p->heap_start) {
                can_write = 1;
            } 
            // For text/data, check the saved program headers.
            else {
                for(int i = 0; i < p->num_phdrs; i++) {
                    struct proghdr ph = p->phdrs[i];
                    if(page_va >= ph.vaddr && page_va < ph.vaddr + ph.memsz) {
                        if (ph.flags & ELF_PROG_FLAG_WRITE) {
                            can_write = 1;
                        }
                        break;
                    }
                }
            }

            if (can_write) {
                // This is a legitimate write to a data/heap/stack page.
                // Grant write permission to the PTE.
                *pte |= PTE_W;

                // Mark the page as dirty in your software tracking system.
                for(int i = 0; i < p->num_resident; i++) {
                    if(p->resident_pages[i].va == page_va) {
                        p->resident_pages[i].dirty = 1;
                        break;
                    }
                }
            } else {
                // This is an illegal write (segmentation fault). Kill the process.
                const char *access_type = "write";
                printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, va, access_type);
                setkilled(p);
            }
        } 
        // CASE 2: Major Fault.
        // The page is not in memory. We need to allocate and load it.
        else { 
            const char *access_type;
            if (r_scause() == 12) { access_type = "exec"; }
            else if (r_scause() == 13) { access_type = "read"; }
            else { access_type = "write"; }

            // Call the main page fault handler to do the heavy lifting.
            if(handle_pgfault(p->pagetable, va, access_type) < 0) {
                // If the handler fails, the address is invalid.
                printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, va, access_type);
                setkilled(p);
            }
        }
    } else {
        printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
        printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
        setkilled(p);
    }

    if(killed(p))
        kexit(-1);

    // give up the CPU if this is a timer interrupt.
    if(which_dev == 2)
        yield();

    prepare_return();

    // the user page table to switch to, for trampoline.S
    uint64 satp = MAKE_SATP(p->pagetable);

    // return to trampoline.S; satp value in a0.
    return satp;
}

//
// set up trapframe and control registers for a return to user space
//
    void
prepare_return(void)
{
    struct proc *p = myproc();

    // we're about to switch the destination of traps from
    // kerneltrap() to usertrap(). because a trap from kernel
    // code to usertrap would be a disaster, turn off interrupts.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    p->trapframe->kernel_trap = (uint64)usertrap;
    p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
    void 
kerneltrap()
{
    int which_dev = 0;
    uint64 sepc = r_sepc();
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();

    if((sstatus & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");
    if(intr_get() != 0)
        panic("kerneltrap: interrupts enabled");

    if((which_dev = devintr()) == 0){
        // interrupt or trap from an unknown source
        printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
        panic("kerneltrap");
    }

    // give up the CPU if this is a timer interrupt.
    if(which_dev == 2 && myproc() != 0)
        yield();

    // the yield() may have caused some traps to occur,
    // so restore trap registers for use by kernelvec.S's sepc instruction.
    w_sepc(sepc);
    w_sstatus(sstatus);
}

    void
clockintr()
{
    if(cpuid() == 0){
        acquire(&tickslock);
        ticks++;
        wakeup(&ticks);
        release(&tickslock);
    }

    // ask for the next timer interrupt. this also clears
    // the interrupt request. 1000000 is about a tenth
    // of a second.
    w_stimecmp(r_time() + 1000000);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
    int
devintr()
{
    uint64 scause = r_scause();

    if(scause == 0x8000000000000009L){
        // this is a supervisor external interrupt, via PLIC.

        // irq indicates which device interrupted.
        int irq = plic_claim();

        if(irq == UART0_IRQ){
            uartintr();
        } else if(irq == VIRTIO0_IRQ){
            virtio_disk_intr();
        } else if(irq){
            printf("unexpected interrupt irq=%d\n", irq);
        }

        // the PLIC allows each device to raise at most one
        // interrupt at a time; tell the PLIC the device is
        // now allowed to interrupt again.
        if(irq)
            plic_complete(irq);

        return 1;
    } else if(scause == 0x8000000000000005L){
        // timer interrupt.
        clockintr();
        return 2;
    } else {
        return 0;
    }
}

