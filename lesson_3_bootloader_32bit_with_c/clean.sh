#!/bin/bash

find . -type f -iname "*.bin" -exec rm -f {} \;
find . -type f -iname "*.o" -exec rm -f {} \;
find . -type f -iname "*.ld" -exec rm -f {} \;
find . -type f -iname "*.elf" -exec rm -f {} \;
find . -type f -iname "os-image" -exec rm -f {} \;
