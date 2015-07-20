##########
# Build Python jsonlang package and install it
##########

rm *.o
rm ../libjsonlang.o ../lexer.o ../parser.o ../static_analysis.o ../vm.o

set -e
python setup.py build

sudo python setup.py install
set +e

# Clean up a little
rm *.o
