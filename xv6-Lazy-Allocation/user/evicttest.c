#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"
#include "../kernel/param.h"
#include "../kernel/memstat.h"

// A program that allocates more memory than available to test page replacement.
// A program that allocates more memory than available to test page replacement.
int
main(int argc, char *argv[])
{
  printf("evicttest starting\n");

  // Allocate a very large amount of memory to exceed physical memory
  // This will be more than enough to trigger eviction with 128MB RAM.
  int size = 23750 * 4096; 
  char *mem = sbrk(size);
  if (mem == (char*)-1) {
    printf("sbrk failed\n");
    exit(1);
  }

  // Touch pages in a simple, predictable order
  // This will fill up memory and then trigger evictions
  printf("touching pages...\n");
  for (int i = 0; i < size; i += 4096) {
    // Print a dot for every 1MB touched to show progress
    if (i % (1024 * 1024) == 0) {
        write(1, ".", 1);
    }
    mem[i] = (char)(i / 4096);
  }
  printf("\n"); // Newline after progress dots

  // Re-touch pages to check if they are correctly loaded after eviction
  printf("re-touching pages to check correctness...\n");
  for (int i = 0; i < 20*4096; i += 4096) {
    if (i % (1024 * 1024) == 0) {
        write(1, ".", 1);
    }
    if (mem[i] != (char)(i / 4096)) {
      printf("error: incorrect data at address %p\n", &mem[i]);
      exit(1);
    }
  }
  printf("\n"); // Newline after progress dots
  struct proc_mem_stat info;
  memstat(&info);
  printf("--- Process Memory Stats ---\n");
  printf("PID: %d\n", info.pid);
  printf("Total Pages: %d\n", info.num_pages_total);
  printf("Resident Pages: %d\n", info.num_resident_pages);
  printf("Swapped Pages: %d\n", info.num_swapped_pages);
  printf("Next FIFO Seq: %d\n\n", info.next_fifo_seq);
  
  printf("--- Page Details (up to %d) ---\n", MAX_PAGES_INFO);
  printf("VA         | STATE    | DIRTY | SEQ   | SLOT\n");
  printf("--------------------------------------------\n");
  
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
    char *state_str = "UNMAPPED";
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
    
    printf("0x%x | %s | %d     | %d    | %d\n",
           info.pages[i].va,
           state_str,
           info.pages[i].is_dirty,
           info.pages[i].seq,
           info.pages[i].swap_slot);
  }
  printf("evicttest finished successfully\n");
  exit(0);
}
