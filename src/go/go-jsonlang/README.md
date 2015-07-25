jsonlang
===========

Simple golang cgo wrapper around Jsonlang VM.

Everything in libjsonlang.h is covered except the multi-file evaluators.

See jsonlang_test.go for how to use it.

Quick example:

        vm := jsonlang.Make()
        vm.ExtVar("color", "purple")

        x, err := vm.EvaluateSnippet(`Test_Demo`, `"dark " + std.extVar("color")`)

        if err != nil {
                panic(err)
        }
        if x != "\"dark purple\"\n" {
                panic("fail: we got " + x)
        }

        vm.Destroy()
