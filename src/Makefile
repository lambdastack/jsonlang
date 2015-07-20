# JSONLang Makefile

###################################################################################################
# User-servicable parts:
###################################################################################################

# C/C++ compiler -- clang also works
CXX ?= g++
CC ?= gcc

# Emscripten -- For JSONLang in the browser
EMCXX ?= em++
EMCC ?= emcc

CP ?= cp
OD ?= od

CXXFLAGS ?= -g -O3 -Wall -Wextra -pedantic -std=c++0x -fPIC
CFLAGS ?= -g -O3 -Wall -Wextra -pedantic -std=c99 -fPIC
EMCXXFLAGS = $(CXXFLAGS) --memory-init-file 0 -s DISABLE_EXCEPTION_CATCHING=0
EMCFLAGS = $(CFLAGS) --memory-init-file 0 -s DISABLE_EXCEPTION_CATCHING=0
LDFLAGS ?=

SHARED_LDFLAGS ?= -shared

###################################################################################################
# End of user-servicable parts
###################################################################################################

LIB_SRC = lexer.cpp parser.cpp static_analysis.cpp vm.cpp libjsonlang.cpp
LIB_OBJ = $(LIB_SRC:.cpp=.o)

ALL = ../bin/jsonlang libjsonlang.so libjsonlang_test_snippet libjsonlang_test_file libjsonlang.js ../docs/libjsonlang.js $(LIB_OBJ)
ALL_HEADERS = libjsonlang.h vm.h static_analysis.h parser.h lexer.h ast.h static_error.h state.h std.jsonlang.h

default: jsonlang

all: $(ALL)

TEST_SNIPPET = "std.assertEqual(({ x: 1, y: self.x } { x: 2 }).y, 2)"
test: jsonlang libjsonlang.so libjsonlang_test_snippet libjsonlang_test_file
	./jsonlang -e $(TEST_SNIPPET)
	LD_LIBRARY_PATH=. ./libjsonlang_test_snippet $(TEST_SNIPPET)
	LD_LIBRARY_PATH=. ./libjsonlang_test_file "test_suite/object.jsonlang"
	cd ../examples ; ./check.sh
	cd ../examples/terraform ; ./check.sh
	cd ../test_suite ; ./run_tests.sh

depend:
	makedepend -f- $(LIB_SRC) jsonlang.cpp libjsonlang_test_snippet.c libjsonlang_test_file.c > Makefile.depend

parser.cpp: std.jsonlang.h

# Object files
%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@
	cp $@ python/

# Commandline executable.
jsonlang: jsonlang.cpp $(LIB_OBJ)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $< $(LIB_SRC:.cpp=.o) -o $@
	mv jsonlang ../bin

# C binding.
libjsonlang.so: $(LIB_OBJ)
	$(CXX) $(LDFLAGS) $(LIB_OBJ) $(SHARED_LDFLAGS) -o $@

# Javascript build of C binding
libjsonlang.js: $(LIB_SRC) $(ALL_HEADERS)
	$(EMCXX) -s 'EXPORTED_FUNCTIONS=["_jsonlang_make", "_jsonlang_evaluate_snippet", "_jsonlang_realloc", "_jsonlang_destroy"]' $(EMCXXFLAGS) $(LDFLAGS) $(LIB_SRC) -o $@

# Copy javascript build to doc directory
doc/libjsonlang.js: libjsonlang.js
	$(CP) $^ $@

# Tests for C binding.
libjsonlang_test_snippet: libjsonlang_test_snippet.c libjsonlang.so libjsonlang.h
	$(CC) $(CFLAGS) $(LDFLAGS) $< -L. -ljsonlang -o $@

libjsonlang_test_file: libjsonlang_test_file.c libjsonlang.so libjsonlang.h
	$(CC) $(CFLAGS) $(LDFLAGS) $< -L. -ljsonlang -o $@

# Encode standard library for embedding in C
%.jsonlang.h: ../lib/%.jsonlang
	(($(OD) -v -Anone -t u1 $< | tr " " "\n" | grep -v "^$$" | tr "\n" "," ) && echo "0") > $@
	echo >> $@

clean:
	rm -vf */*~ *~ .*~ */.*.swp .*.swp $(ALL) *.o *.jsonlang.h

-include Makefile.depend
