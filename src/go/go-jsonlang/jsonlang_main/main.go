/*
Command line tool to try evaluating Jsonlang.

Demos:
  echo "{ a: 1, b: 2 }"  | go run jsonlang_main/main.go /dev/stdin
  go run jsonlang_main/main.go test1.j
  go run jsonlang_main/main.go test2.j
  echo 'std.extVar("a") + "bar"' | go run jsonlang_main/main.go /dev/stdin a=foo
*/
package main

//import "github.com/iqstack/jsonlang/src/go/go-jsonlang"

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"path/filepath"
	"strings"
)

var debug_ast = flag.Int(
	"debug_ast", 0,
	"If set to 1, will emit the Jsonlang input after parsing / desugaring.")

func importFunc(base, rel string) (result string, err error) {
	filename := filepath.Join(base, rel)
	contents, err := ioutil.ReadFile(filename)
	if err != nil {
		return "", err
	}
	return string(contents), nil
}

func main() {
	flag.Parse()
	vm := jsonlang.Make()
	vm.ImportCallback(importFunc)

	if debug_ast != nil {
		vm.DebugAst(*debug_ast)
	}

	args := flag.Args()
	if len(args) < 1 {
		log.Fatal("Usage:  jsonlang_main filename key1=val1 key2=val2...")
	}

	for i := 1; i < len(args); i++ {
		kv := strings.SplitN(args[i], "=", 2)
		if len(kv) != 2 {
			log.Fatalf("Error in jsonlang_main: Expected arg to be 'key=value': %s", args[i])
		}
		vm.ExtVar(kv[0], kv[1])
	}

	z, err := vm.EvaluateFile(args[0])
	if err != nil {
		log.Fatalf("Error in jsonlang_main: %s", err)
	}
	fmt.Print(z)

	vm.Destroy()
}
