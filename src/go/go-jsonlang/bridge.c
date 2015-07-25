#include <memory.h>
#include <stdio.h>
#include <string.h>
#include <libjsonlang.h>
#include "bridge.h"

char* CallImport_cgo(void *ctx, const char *base, const char *rel, int *success) {
  struct JsonlangVm* vm = ctx;
  char* result = go_call_import(vm, (char*)base, (char*)rel, success);
  char* buf = jsonlang_realloc(vm, NULL, strlen(result)+1);
  strcpy(buf, result);
  return buf;
}
