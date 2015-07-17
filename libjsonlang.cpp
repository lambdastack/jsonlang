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

#include <cstdlib>
#include <cstring>

#include <exception>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

extern "C" {
    #include "libjsonlang.h"
}

#include "parser.h"
#include "static_analysis.h"
#include "vm.h"

static void memory_panic(void)
{
    fputs("FATAL ERROR: A memory allocation error occurred.\n", stderr);
    abort();
}

static char *from_string(JsonlangVm* vm, const std::string &v)
{
    char *r = jsonlang_realloc(vm, nullptr, v.length() + 1);
    std::strcpy(r, v.c_str());
    return r;
}

/** Resolve the absolute path and use C++ file io to load the file.
 */
static char *default_import_callback(void *ctx, const char *base, const char *file, int *success)
{
    auto *vm = static_cast<JsonlangVm*>(ctx);

    if (std::strlen(file) == 0) {
        *success = 0;
        return from_string(vm, "The empty string is not a valid filename");
    }

    if (file[std::strlen(file) - 1] == '/') {
        *success = 0;
        return from_string(vm, "Attempted to import a directory");
    }

    std::string abs_path;
    // It is possible that file is an absolute path
    if (file[0] == '/')
        abs_path = file;
    else
        abs_path = std::string(base) + file;

    std::ifstream f;
    f.open(abs_path.c_str());
    if (!f.good()) {
        *success = 0;
        return from_string(vm, std::strerror(errno));
    }
    try {
        std::string input;
        input.assign(std::istreambuf_iterator<char>(f), std::istreambuf_iterator<char>());
        *success = 1;
        return from_string(vm, input);
    } catch (const std::ios_base::failure &io_err) {
        *success = 0;
        return from_string(vm, io_err.what());
    }
}


struct JsonlangVm {
    double gcGrowthTrigger;
    unsigned maxStack;
    unsigned gcMinObjects;
    bool debugAst;
    unsigned maxTrace;
    std::map<std::string, std::string> extVars;
    JsonlangImportCallback *importCallback;
    void *importCallbackContext;
    bool stringOutput;
    JsonlangVm(void)
      : gcGrowthTrigger(2.0), maxStack(500), gcMinObjects(1000), debugAst(false), maxTrace(20),
        importCallback(default_import_callback), importCallbackContext(this), stringOutput(false)
    { }
};

#define TRY try {
#define CATCH(func) \
    } catch (const std::bad_alloc &) {\
        memory_panic(); \
    } catch (const std::exception &e) {\
        std::cerr << "Something went wrong during " func ", please report this: " \
                  << e.what() << std::endl; \
        abort(); \
    }

const char *jsonlang_version(void)
{
    return LIB_JSONLANG_VERSION;
}

JsonlangVm *jsonlang_make(void)
{
    TRY
    return new JsonlangVm();
    CATCH("jsonlang_make")
    return nullptr;
}

void jsonlang_destroy(JsonlangVm *vm)
{
    TRY
    delete vm;
    CATCH("jsonlang_destroy")
}

void jsonlang_max_stack(JsonlangVm *vm, unsigned v)
{
    vm->maxStack = v;
}

void jsonlang_gc_min_objects(JsonlangVm *vm, unsigned v)
{
    vm->gcMinObjects = v;
}

void jsonlang_gc_growth_trigger(JsonlangVm *vm, double v)
{
    vm->gcGrowthTrigger = v;
}

void jsonlang_string_output(struct JsonlangVm *vm, int v)
{
    vm->stringOutput = bool(v);
}

void jsonlang_import_callback(struct JsonlangVm *vm, JsonlangImportCallback *cb, void *ctx)
{
    vm->importCallback = cb;
    vm->importCallbackContext = ctx;
}

void jsonlang_ext_var(JsonlangVm *vm, const char *key, const char *val)
{
    vm->extVars[key] = val;
}

void jsonlang_debug_ast(JsonlangVm *vm, int v)
{
    vm->debugAst = v;
}

void jsonlang_max_trace(JsonlangVm *vm, unsigned v)
{
    vm->maxTrace = v;
}

static char *jsonlang_evaluate_snippet_aux(JsonlangVm *vm, const char *filename,
                                          const char *snippet, int *error, bool multi)
{
    try {
        Allocator alloc;
        AST *expr = jsonlang_parse(&alloc, filename, snippet);
        std::string json_str;
        std::map<std::string, std::string> files;
        if (vm->debugAst) {
            json_str = jsonlang_unparse_jsonlang(expr);
        } else {
            jsonlang_static_analysis(expr);
            if (multi) {
                files = jsonlang_vm_execute_multi(&alloc, expr, vm->extVars, vm->maxStack,
                                                 vm->gcMinObjects, vm->gcGrowthTrigger,
                                                 vm->importCallback, vm->importCallbackContext,
                                                 vm->stringOutput);
            } else {
                json_str = jsonlang_vm_execute(&alloc, expr, vm->extVars, vm->maxStack,
                                              vm->gcMinObjects, vm->gcGrowthTrigger,
                                              vm->importCallback, vm->importCallbackContext,
                                              vm->stringOutput);
            }
        }
        if (multi) {
            size_t sz = 1; // final sentinel
            for (const auto &pair : files) {
                sz += pair.first.length() + 1; // include sentinel
                sz += pair.second.length() + 2; // Add a '\n' as well as sentinel
            }
            char *buf = (char*)::malloc(sz);
            if (buf == nullptr) memory_panic();
            std::ptrdiff_t i = 0;
            for (const auto &pair : files) {
                memcpy(&buf[i], pair.first.c_str(), pair.first.length() + 1);
                i += pair.first.length() + 1;
                memcpy(&buf[i], pair.second.c_str(), pair.second.length());
                i += pair.second.length();
                buf[i] = '\n';
                i++;
                buf[i] = '\0';
                i++;
            }
            buf[i] = '\0'; // final sentinel
            *error = false;
            return buf;
        } else {
            json_str += "\n";
            *error = false;
            return from_string(vm, json_str);
        }

    } catch (StaticError &e) {
        std::stringstream ss;
        ss << "STATIC ERROR: " << e << std::endl;
        *error = true;
        return from_string(vm, ss.str());

    } catch (RuntimeError &e) {
        std::stringstream ss;
        ss << "RUNTIME ERROR: " << e.msg << std::endl;
        const long max_above = vm->maxTrace / 2;
        const long max_below = vm->maxTrace - max_above;
        const long sz = e.stackTrace.size();
        for (long i = 0 ; i < sz ; ++i) {
            const auto &f = e.stackTrace[i];
            if (vm->maxTrace > 0 && i >= max_above && i < sz - max_below) {
                if (i == max_above)
                    ss << "\t..." << std::endl;
            } else {
                ss << "\t" << f.location << "\t" << f.name << std::endl;
            }
        }
        *error = true;
        return from_string(vm, ss.str());
    }

}

static char *jsonlang_evaluate_file_aux(JsonlangVm *vm, const char *filename, int *error, bool multi)
{
    std::ifstream f;
    f.open(filename);
    if (!f.good()) {
        std::stringstream ss;
        ss << "Opening input file: " << filename << ": " << strerror(errno);
        *error = true;
        return from_string(vm, ss.str());
    }
    std::string input;
    input.assign(std::istreambuf_iterator<char>(f),
                 std::istreambuf_iterator<char>());

    return jsonlang_evaluate_snippet_aux(vm, filename, input.c_str(), error, multi);
}

char *jsonlang_evaluate_file(JsonlangVm *vm, const char *filename, int *error)
{
    TRY
    return jsonlang_evaluate_file_aux(vm, filename, error, false);
    CATCH("jsonlang_evaluate_file")
    return nullptr;  // Never happens.
}

char *jsonlang_evaluate_file_multi(JsonlangVm *vm, const char *filename, int *error)
{
    TRY
    return jsonlang_evaluate_file_aux(vm, filename, error, true);
    CATCH("jsonlang_evaluate_file_multi")
    return nullptr;  // Never happens.
}

char *jsonlang_evaluate_snippet(JsonlangVm *vm, const char *filename, const char *snippet, int *error)
{
    TRY
    return jsonlang_evaluate_snippet_aux(vm, filename, snippet, error, false);
    CATCH("jsonlang_evaluate_snippet")
    return nullptr;  // Never happens.
}

char *jsonlang_evaluate_snippet_multi(JsonlangVm *vm, const char *filename,
                                     const char *snippet, int *error)
{
    TRY
    return jsonlang_evaluate_snippet_aux(vm, filename, snippet, error, true);
    CATCH("jsonlang_evaluate_snippet_multi")
    return nullptr;  // Never happens.
}

char *jsonlang_realloc(JsonlangVm *vm, char *str, size_t sz)
{
    (void) vm;
    if (str == nullptr) {
        if (sz == 0) return nullptr;
        auto *r = static_cast<char*>(::malloc(sz));
        if (r == nullptr) memory_panic();
        return r;
    } else {
        if (sz == 0) {
            ::free(str);
            return nullptr;
        } else {
            auto *r = static_cast<char*>(::realloc(str, sz));
            if (r == nullptr) memory_panic();
            return r;
        }
    }
}
