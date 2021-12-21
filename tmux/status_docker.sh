#!/bin/bash
# display backintime backup status

# no matter which locale, display it with C
export LC_ALL=C

# get status
OUTPUT=$(docker container ls | grep server- | sed 's/.*server-//g' | sed 's/\".*//g')

test "x$OUTPUT" == "x" && OUTPUT="" || colour="#[fg=black]#[bg=green]"

# print it centered and nicely
printf "$colour%10s%-5s#[default]\n" "$(echo "$OUTPUT" | cut -c 1-$((${#OUTPUT}/2)))" "$(echo "$OUTPUT" | cut -c $((${#OUTPUT}/2+1))-${#OUTPUT})"
