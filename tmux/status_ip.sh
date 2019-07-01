#!/bin/bash
# get the default outgoing IP and display it for tmux status bar

# no matter which locale, display it with C
export LC_ALL=C

# get the ip of the default gateway
outgoing_ip="$(ip route get 8.8.8.8 | head -n1 | sed -r 's/.*src ([^ ]+).*/\1/g')"

# default when no IP
test "x$outgoing_ip" == "x" && outgoing_ip="no_ip"

# print it centered and nicely
printf '%6s%-7s\n' $(echo $outgoing_ip | cut -c 1-$((${#outgoing_ip}/2))) $(echo $outgoing_ip | cut -c $((${#outgoing_ip}/2+1))-${#outgoing_ip})
