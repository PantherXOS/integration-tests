#!/bin/sh

sleep 2s

if [ "$#" -eq 0 ]; then
    bats .
else
    bats "$1"
fi
