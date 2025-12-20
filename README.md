# SysNet Internals: The LAZY Corp Trilogy

**SysNet Internals** is a comprehensive systems programming suite developed for the "Experimental Systems Division" of LAZY Corp. It addresses three critical areas of operating systems: Kernel Memory Management, Network Traffic Analysis, and Concurrency Control.

## 📂 Project Structure

```
OS-Network-Concurrency-Suite/
│
├── README.md                           # This file
│
├── xv6-Lazy-Allocation/                # Part A: PagedOut Inc.
│   ├── README.md                       # Detailed documentation for Part A
│   ├── Makefile                        # Build configuration for xv6
│   ├── test-xv6.py                     # Automated testing script
│   ├── BonusQuestion.md                # Page replacement algorithm docs
│   │
│   ├── kernel/                         # Modified xv6 kernel source
│   │   ├── vm.c                        # Virtual memory management
│   │   ├── trap.c                      # Page fault handler
│   │   ├── kalloc.c                    # Physical memory allocator
│   │   ├── proc.c                      # Process management & swap
│   │   ├── sysfile.c                   # System call implementations
│   │   ├── memstat.h                   # Memory statistics structure
│   │   ├── defs.h                      # Kernel function declarations
│   │   ├── riscv.h                     # RISC-V specific definitions
│   │   └── ...                         # Other kernel files
│   │
│   ├── user/                           # User-space programs
│   │   ├── memstat_test.c              # Memory statistics test
│   │   ├── evicttest.c                 # Page eviction test
│   │   ├── readcount.c                 # Syscall counter utility
│   │   └── ...                         # Other user programs
│   │
│   └── mkfs/                           # File system utilities
│       └── mkfs.c                      # File system creator
│
├── Terminal-Packet-Sniffer/            # Part B: C-Shark Division
│   ├── README.md                       # Detailed documentation for Part B
│   ├── Makefile                        # Build configuration
│   ├── main.c                          # Entry point and UI logic
│   ├── func.c                          # Packet parsing (L2-L7)
│   ├── func.h                          # Header definitions
│   └── cshark                          # Compiled executable (generated)
│
└── Concurrent-Bakery-Sim/              # Part C: ThreadForce Ops
    ├── README.md                       # Detailed documentation for Part C
    ├── main.c                          # Multi-threaded simulation
    ├── input.txt                       # Sample test input
    ├── Makefile                        # Build configuration
    └── bakery                          # Compiled executable (generated)
```

## 🚀 Project Modules

### A. PagedOut Inc. (xv6 Memory Management)

Implementation of **Demand Paging** and **Swapping** in the xv6 operating system kernel.

**Key Features:**
- Lazy memory allocation
- Page fault handling (demand paging)
- FIFO page replacement algorithm
- Per-process swap files
- `memstat()` system call for memory auditing

**Technologies:** C, RISC-V Assembly, xv6 Kernel, QEMU

---

### B. C-Shark Division (Network Packet Sniffer)

A terminal-based network packet analyzer utilizing raw sockets and libpcap.

**Key Features:**
- Live packet capture on network interfaces
- Layer-by-layer protocol decoding (Ethernet, IPv4/6, TCP/UDP, HTTP)
- Payload hex dumps with ASCII representation
- Protocol filtering modes
- Interactive terminal UI

**Technologies:** C, libpcap, Raw Sockets, Linux Networking

---

### C. ThreadForce Ops (Concurrency Control)

A multi-threaded solution to the "Office Bakery" synchronization problem.

**Key Features:**
- Multi-threaded simulation using POSIX threads
- Resource management (Ovens, Chefs, Customers)
- Synchronization with Mutexes and Condition Variables
- Deadlock-free design
- Priority-based customer service

**Technologies:** C, Pthreads, Mutexes, Condition Variables

---

## 🛠️ System Requirements

### Environment
- **Operating System:** Linux (Ubuntu 20.04+ or Debian-based recommended)

### Compilers & Tools
- `gcc` (version 9.0 or higher)
- `riscv64-unknown-elf-gcc` (for xv6 cross-compilation)
- `make` (build automation)
- `qemu-system-riscv64` (version 5.0+)
- `python3` (for automated testing)

### Libraries
- `libpcap-dev` (packet capture library)
- `pthread` (POSIX threads - usually included with gcc)

### Installation (Ubuntu/Debian)

```bash
# Update package list
sudo apt update

# Install build essentials
sudo apt install build-essential git

# Install QEMU for RISC-V
sudo apt install qemu-system-misc

# Install RISC-V toolchain
sudo apt install gcc-riscv64-unknown-elf

# Install libpcap for network sniffing
sudo apt install libpcap-dev

# Install Python 3 (if not already installed)
sudo apt install python3
```

---

## 🚀 Quick Start

### Part A: xv6 Lazy Allocation

```bash
cd xv6-Lazy-Allocation
make qemu

# Inside xv6 shell:
$ memstat_test
$ evicttest
```

### Part B: Terminal Packet Sniffer

```bash
cd Terminal-Packet-Sniffer
make
sudo ./cshark
```

### Part C: Concurrent Bakery Simulation

```bash
cd Concurrent-Bakery-Sim
gcc main.c -o bakery -lpthread
./bakery < input.txt
```

---

## 📊 Testing

Each module includes comprehensive testing:

- **Part A:** Automated Python test suite (`test-xv6.py`)
- **Part B:** Live network testing with real traffic
- **Part C:** Input-driven simulation with timing analysis

---

## 📖 Documentation

Detailed documentation for each module is available in their respective README files:

- [Part A: xv6 Lazy Allocation](./xv6-Lazy-Allocation/README.md)
- [Part B: Terminal Packet Sniffer](./Terminal-Packet-Sniffer/README.md)
- [Part C: Concurrent Bakery Simulation](./Concurrent-Bakery-Sim/README.md)

---
