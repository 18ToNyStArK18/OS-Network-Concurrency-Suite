# PagedOut Inc: xv6 Lazy Allocation

This module modifies the **xv6 operating system** to implement demand paging and swap management. It transitions xv6 from eager memory allocation to a lazy, efficient model.

## 📂 Project Structure

```text
xv6-Lazy-Allocation/
├── kernel/
│   ├── vm.c          # Virtual Memory logic (uvmalloc, uvmunmap)
│   ├── trap.c        # Page Fault Handler (usertrap)
│   ├── kalloc.c      # Physical memory allocator
│   ├── proc.c        # Process management & Swap file handling
│   ├── sysfile.c     # System call implementations
│   └── memstat.h     # Structure for memory statistics
│   └── ...
├── user/
│   ├── memstat_test.c # Test program for memory stats
│   ├── evicttest.c    # Test for page eviction logic
│   └── readcount.c    # Utility to count read syscalls
│   └── ...
├── test-xv6.py       # Automated testing script
├── BonusQuestion.md  # Documentation for replacement algorithm
└── Makefile          # Compilation rules
```

## ✨ Features Implemented

### Demand Paging:
- `exec` and `sbrk` no longer allocate physical memory immediately.
- Pages are allocated on-the-fly via Page Faults (scause 13/15).

### Page Replacement (FIFO):
- When RAM is full, the oldest resident page is evicted.
- Victim selection tracks per-process FIFO sequence numbers.

### Swapping:
- Dirty pages are written to disk (per-process swap file `/pgswpXXXX`).
- Clean pages are discarded if backed by a file (text/data).

### System Inspection:
- `memstat()` syscall implemented to expose page states (Resident, Swapped, Unmapped).

## 🔨 How to Run

### 1. Boot xv6 in QEMU:
```bash
make qemu
```

### 2. Run Tests (Inside xv6):
```bash
$ memstat_test
$ evicttest
```

## 📊 Logging Format

The kernel emits strict log formats for grading:

- **PAGEFAULT**: Triggered on invalid access.
- **ALLOC/LOADEXEC/SWAPIN**: When pages are brought into RAM.
- **VICTIM/EVICT/SWAPOUT**: When pages are removed from RAM.
