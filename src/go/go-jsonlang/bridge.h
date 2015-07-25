#ifndef LIBJSONLANG_BRIDGE_H
#define LIBJSONLANG_BRIDGE_H
#include <libjsonlang.h>

typedef JsonlangImportCallback* JsonlangImportCallbackPtr;

struct JsonlangVm* go_get_guts(void* ctx);

char* CallImport_cgo(void *ctx, const char *base, const char *rel, int *success);

char* go_call_import(void* vm, char *base, char *rel, int *success);

#endif
