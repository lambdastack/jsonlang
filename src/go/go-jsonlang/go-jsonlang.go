// go-jsonlang is a simple Go wrapper for the Jsonlang VM.

package jsonlang

/*
#include <memory.h>
#include <string.h>
#include <stdio.h>
#include <libjsonlang.h>
#include "bridge.h"
#cgo LDFLAGS: -ljsonlang
*/
import "C"

import (
	"errors"
	"unsafe"
)

// ImportCallback... Import callback
type ImportCallback func(base, rel string) (result string, err error)

type VM struct {
	jl             *C.struct_JsonlangVm
	importCallback ImportCallback
}

//export go_call_import
func go_call_import(vmPtr unsafe.Pointer, base, rel *C.char, okPtr *C.int) *C.char {
	vm := (*VM)(vmPtr)
	result, err := vm.importCallback(C.GoString(base), C.GoString(rel))
	if err != nil {
		*okPtr = C.int(0)
		return C.CString(err.Error())
	}
	*okPtr = C.int(1)
	return C.CString(result)
}

// Create a new Jsonlang virtual machine.
func Make() *VM {
	vm := &VM{jl: C.jsonlang_make()}
	return vm
}

// Complement of Make().
func (vm *VM) Destroy() {
	C.jsonlang_destroy(vm.jl)
	vm.jl = nil
}

// Evaluate a file containing Jsonlang code, return a JSON string.
func (vm *VM) EvaluateFile(filename string) (string, error) {
	var e C.int
	z := C.GoString(C.jsonlang_evaluate_file(vm.jl, C.CString(filename), &e))
	if e != 0 {
		return "", errors.New(z)
	}
	return z, nil
}

// Evaluate a string containing Jsonlang code, return a JSON string.
func (vm *VM) EvaluateSnippet(filename, snippet string) (string, error) {
	var e C.int
	z := C.GoString(C.jsonlang_evaluate_snippet(vm.jl, C.CString(filename), C.CString(snippet), &e))
	if e != 0 {
		return "", errors.New(z)
	}
	return z, nil
}

// Override the callback used to locate imports.
func (vm *VM) ImportCallback(f ImportCallback) {
	vm.importCallback = f
	C.jsonlang_import_callback(vm.jl, C.JsonlangImportCallbackPtr(C.CallImport_cgo), unsafe.Pointer(vm))
}

// Bind a Jsonlang external var to the given value.
func (vm *VM) ExtVar(key, val string) {
	C.jsonlang_ext_var(vm.jl, C.CString(key), C.CString(val))
}

// If set to 1, will emit the Jsonnet input after parsing / desugaring.
func (vm *VM) DebugAst(v int) {
	C.jsonlang_debug_ast(vm.jl, C.int(v))
}

// Set the maximum stack depth.
func (vm *VM) MaxStack(v uint) {
	C.jsonlang_max_stack(vm.jl, C.uint(v))
}

// Set the number of lines of stack trace to display (0 for all of them).
func (vm *VM) MaxTrace(v uint) {
	C.jsonlang_max_trace(vm.jl, C.uint(v))
}

// Set the number of objects required before a garbage collection cycle is allowed.
func (vm *VM) GcMinObjects(v uint) {
	C.jsonlang_gc_min_objects(vm.jl, C.uint(v))
}

// Run the garbage collector after this amount of growth in the number of objects.
func (vm *VM) GcGrowthTrigger(v float64) {
	C.jsonlang_gc_growth_trigger(vm.jl, C.double(v))
}
