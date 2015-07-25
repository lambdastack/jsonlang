/*
Copyright 2015 Google Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#ifndef LIB_JSONLANG_H
#define LIB_JSONLANG_H

/** \file This file is a library interface for evaluating Jsonlang.  It is written in C++ but exposes
 * a C interface for easier wrapping by other languages.  See \see jsonlang_lib_test.c for an example
 * of using the library.
 */


#define LIB_JSONLANG_VERSION "v0.7.9"


/** Return the version string of the Jsonlang interpreter.  Conforms to semantic versioning
 * http://semver.org/ If this does not match LIB_JSONLANG_VERSION then there is a mismatch between
 * header and compiled library.
 */
const char *jsonlang_version(void);

/** Jsonlang virtual machine context. */
struct JsonlangVm;

/** Create a new Jsonlang virtual machine. */
struct JsonlangVm *jsonlang_make(void);

/** Set the maximum stack depth. */
void jsonlang_max_stack(struct JsonlangVm *vm, unsigned v);

/** Set the number of objects required before a garbage collection cycle is allowed. */
void jsonlang_gc_min_objects(struct JsonlangVm *vm, unsigned v);

/** Run the garbage collector after this amount of growth in the number of objects. */
void jsonlang_gc_growth_trigger(struct JsonlangVm *vm, double v);

/** Expect a string as output and don't JSON encode it. */
void jsonlang_string_output(struct JsonlangVm *vm, int v);

/** Callback used to load imports.
 *
 * The returned char* should be allocated with jsonlang_realloc.  It will be cleaned up by
 * libjsonlang when no-longer needed.
 *
 * \param ctx User pointer, given in jsonlang_import_callback.
 * \param base The directory containing the code that did the import.
 * \param rel The path imported by the code.
 *\ param success Set this byref param to 1 to indicate success and 0 for failure.
 * \returns The content of the imported file, or an error message.
 */
typedef char *JsonlangImportCallback(void *ctx, const char *base, const char *rel, int *success);

/** Allocate, resize, or free a buffer.  This will abort if the memory cannot be allocated.  It will
 * only return NULL if sz was zero.
 *
 * \param buf If NULL, allocate a new buffer.  If an previously allocated buffer, resize it.
 * \param sz The size of the buffer to return.  If zero, frees the buffer.
 * \returns The new buffer.
 */
char *jsonlang_realloc(struct JsonlangVm *vm, char *buf, size_t sz);

/** Override the callback used to locate imports.
 */
void jsonlang_import_callback(struct JsonlangVm *vm, JsonlangImportCallback *cb, void *ctx);

/** Bind a Jsonlang external var to the given value.
 *
 * Argument values are copied so memory should be managed by caller.
 */
void jsonlang_ext_var(struct JsonlangVm *vm, const char *key, const char *val);

/** If set to 1, will emit the Jsonlang input after parsing / desugaring. */
void jsonlang_debug_ast(struct JsonlangVm *vm, int v);

/** Set the number of lines of stack trace to display (0 for all of them). */
void jsonlang_max_trace(struct JsonlangVm *vm, unsigned v);

/** Evaluate a file containing Jsonlang code, return a JSON string.
 *
 * The returned string should be cleaned up with jsonlang_realloc.
 *
 * \param filename Path to a file containing Jsonlang code.
 * \param error Return by reference whether or not there was an error.
 * \returns Either JSON or the error message.
 */
char *jsonlang_evaluate_file(struct JsonlangVm *vm,
                            const char *filename,
                            int *error);

/** Evaluate a string containing Jsonlang code, return a JSON string.
 *
 * The returned string should be cleaned up with jsonlang_realloc.
 *
 * \param filename Path to a file (used in error messages).
 * \param snippet Jsonlang code to execute.
 * \param error Return by reference whether or not there was an error.
 * \returns Either JSON or the error message.
 */
char *jsonlang_evaluate_snippet(struct JsonlangVm *vm,
                               const char *filename,
                               const char *snippet,
                               int *error);

/** Evaluate a file containing Jsonlang code, return a number of JSON files.
 *
 * The returned character buffer contains an even number of strings, the filename and JSON for each
 * JSON file interleaved.  It should be cleaned up with jsonlang_realloc.
 *
 * \param filename Path to a file containing Jsonlang code.
 * \param error Return by reference whether or not there was an error.
 * \returns Either the error, or a sequence of strings separated by \0, terminated with \0\0.
 */
char *jsonlang_evaluate_file_multi(struct JsonlangVm *vm,
                                  const char *filename,
                                  int *error);

/** Evaluate a string containing Jsonlang code, return a number of JSON files.
 *
 * The returned character buffer contains an even number of strings, the filename and JSON for each
 * JSON file interleaved.  It should be cleaned up with jsonlang_realloc.
 *
 * \param filename Path to a file containing Jsonlang code.
 * \param snippet Jsonlang code to execute.
 * \param error Return by reference whether or not there was an error.
 * \returns Either the error, or a sequence of strings separated by \0, terminated with \0\0.
 */
char *jsonlang_evaluate_snippet_multi(struct JsonlangVm *vm,
                                     const char *filename,
                                     const char *snippet,
                                     int *error);

/** Complement of \see jsonlang_vm_make. */
void jsonlang_destroy(struct JsonlangVm *vm);

#endif
