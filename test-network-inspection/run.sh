#!/bin/sh

rm "./output.json"

if [ "$#" -eq 0 ]; then
    bats .
else
    bats "$1"
fi
