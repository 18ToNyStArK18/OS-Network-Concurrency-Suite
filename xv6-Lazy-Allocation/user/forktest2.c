#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"
#include "../kernel/param.h"

// Tests that fork correctly copies the parent's memory.
void
forktest2(void)
{
  printf("starting fork test 2\n");

  // Allocate one page of memory.
  char *mem = sbrk(4096);
  if(mem == (char*)-1){
    printf("sbrk failed\n");
    exit(1);
  }

  // Write a pattern to the parent's memory.
  for(int i = 0; i < 4096; i++){
    mem[i] = (char)(i % 256);
  }

  printf("parent finished writing memory\n");

  int pid = fork();
  if(pid < 0){
    printf("fork failed\n");
    exit(1);
  }

  if(pid == 0){
    // --- Child Process ---
    char *mem2 = sbrk(4096);
    if(mem2 == 0){
        printf("MEM NOT Allocated\n");
    }
    mem2[0] = 'A'; 
    printf("child started, checking memory...\n");

    // Check if the child can see the parent's data.
    for(int i = 0; i < 4096; i++){
      if(mem[i] != (char)(i % 256)){
        printf("fork test 2 failed: incorrect data in child at index %d\n", i);
        exit(1); // Exit with a failure code.
      }
    }

    printf("child finished checking, memory is correct.\n");
    exit(0); // Exit with a success code.

  } else {
    // --- Parent Process ---
    int status;
    wait(&status);

    if(status == 0){
      printf("fork test 2 OK\n");
    } else {
      printf("fork test 2 FAILED\n");
    }
  }
}

int
main(void)
{
  forktest2();
  exit(0);
}
