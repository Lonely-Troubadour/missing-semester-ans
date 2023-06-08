#!/bin/bash
echo "Staring program at $(date)"
echo "Running program $0 with $# arguements with $$ pid"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null