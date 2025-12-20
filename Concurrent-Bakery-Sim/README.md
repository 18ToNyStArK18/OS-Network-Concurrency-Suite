# ThreadForce: Concurrent Bakery Simulation

A multi-threaded simulation of a resource-constrained office bakery. This project demonstrates synchronization using Pthreads, Mutexes, and Condition Variables to prevent race conditions and deadlocks.

## 📂 Project Structure

```text
Concurrent-Bakery-Sim/
├── main.c        # Core simulation logic (Threads for Chefs/Customers)
├── input.txt     # Test input defining arrival times
└── bakery        # Compiled executable
```

## 🧩 Logic & Constraints

The simulation manages the following resources:

- **4 Chefs**: Handling `bake_cake` (2s) and `accept_payment` (2s).
- **4 Ovens**: Required for baking.
- **Waiting Area**: 4 Sofa seats + Standing room (Max capacity 25).

### Synchronization Rules:

- **Strict Ordering**: Enter -> Sit -> Request Cake -> Pay -> Leave.
- **Priority**: Customers on the sofa get priority for baking.
- **Concurrency**: Multiple chefs and customers operate simultaneously without data corruption.

## 🔨 Build & Run

### 1. Compile:
```bash
gcc main.c -o bakery -lpthread
```

### 2. Run with Input:
```bash
./bakery < input.txt
```

### 3. Output Format:
The program outputs timestamped events:
```plaintext
<time> Customer <id> enters
<time> Chef <id> bakes for Customer <id>
<time> Customer <id> pays
...
```
