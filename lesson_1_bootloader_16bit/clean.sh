#!/bin/bash

find . -type f -iname "*.bin" -exec rm -f {} \;
find . -type f -iname "*.o" -exec rm -f {} \;

