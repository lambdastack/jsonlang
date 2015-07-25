## bin - executables

This folder needs to be in your $PATH. The jsonlang executable that represents your OS will need to be copied
to this directory. For example, if you're using Mac OSX then copy the jsonlang from /osx/jsonlang to this directory. If you're using ubuntu then copy the /linux/ubuntu/jsonlang to this directory.

If your OS is not included in the bin directory chain then you will need to compile the source code to generate a jsonlang built for your platform. This means you will need development tools for your platform installed prior to running make in the /src directory (off of the root of this project). The make call will copy the jsonlang into this directory once a successful compile has occurred.
