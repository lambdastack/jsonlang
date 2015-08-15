#!/usr/env python

# Not using these - only here as an example.
import json
import os


def main():
    # Do something here or call some other set of functions etc to produce json output. It's also possible to
    # use something like Jinja2 with jsonlang style template and return it for additional processing.

    c = '{"sample1": "This is a sample value.", "sample2": "Sample2"}'
    return c

if __name__ == "__main__":
    print main()
