#!/bin/bash

find . -type f -iname "*.bin" -exec rm -f {} \;
find . -type f -iname "*.o" -exec rm -f {} \;
find . -type f -iname "*.img" -exec rm -f {} \;
find . -type f -iname "*.log" -exec rm -f {} \;