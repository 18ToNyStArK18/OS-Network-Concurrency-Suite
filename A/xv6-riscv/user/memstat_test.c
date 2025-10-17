#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"
#include "../kernel/memstat.h" // Include your new header in user-space

int
main()
{
  struct proc_mem_stat info;

  // Allocate some memory and touch it to make it resident
  sbrk(4096 * 5);
  char *p = (char *)0;
  p[0] = 'A';
  p[4096] = 'B';
  p[8192] = 'C';
  p[4096*3]='D';

  // Call the new system call
  if (memstat(&info) < 0) {
    printf("memstat failed\n");
    exit(1);
  }

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

  exit(0);
}
