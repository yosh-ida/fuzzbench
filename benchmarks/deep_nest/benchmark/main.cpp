#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
  int a = 4 / size;
  printf("%d", a);
  return 0;
}