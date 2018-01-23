#!/bin/bash
# get the default outgoing IP and display it for tmux status bar

# no matter which locale, display it with C
export LC_ALL=C

# get the ip of the default gateway
uname | grep -q Darwin \
    && outgoing_ip="$(netstat -rn | grep default | awk '{print $NF}' | head -n1 | xargs ifconfig | grep inet | grep -ve 127.0.0.1 -e fe80: | sed -E 's/^.*inet6? (.*) netmask.*$/\1/')" \
    || outgoing_ip="$(netstat -rn | grep "^0.0.0.0" | awk '{print $NF}' | xargs -n1 ifconfig | grep inet | head -n1 | grep -Eo "inet ([0-9]{1,3}.){3}[0-9]{1,3}" | awk '{print $NF}')"

# print it centered and nicely
printf '%6s%-7s\n' $(echo $outgoing_ip | cut -c 1-$((${#outgoing_ip}/2))) $(echo $outgoing_ip | cut -c $((${#outgoing_ip}/2+1))-${#outgoing_ip})
