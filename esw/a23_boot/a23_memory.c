
#include <stdlib.h>
#include <sys/types.h>
#include "a23_memory.h"

extern char *__heap_start;
//extern char *__heap_end;

typedef struct free_block {
    size_t size;
    struct free_block* next;
} free_block;

static free_block free_block_list_head = { 0, 0 };
// static const size_t overhead = sizeof(size_t);
static const size_t align_to = 16;

static void *heap = 0;

void *sbrk(size_t incr) {
  char *prev_heap;

  if (heap == 0) {
    heap = (unsigned char *)__heap_start;
  }
  prev_heap = heap;
  heap += incr;

  return prev_heap;
}

void* malloc(size_t size) {
    size = (size + sizeof(size_t) + (align_to - 1)) & ~ (align_to - 1);
    free_block* block = free_block_list_head.next;
    free_block** head = &(free_block_list_head.next);
    while (block != 0) {
        if (block->size >= size) {
            *head = block->next;
            return ((char*)block) + sizeof(size_t);
        }
        head = &(block->next);
        block = block->next;
    }

    block = (free_block*)sbrk(size);
    block->size = size;

    return ((char*)block) + sizeof(size_t);
}

void free(void* ptr) {
    free_block* block = (free_block*)(((char*)ptr) - sizeof(size_t));
    block->next = free_block_list_head.next;
    free_block_list_head.next = block;
}

