#!/bin/bash
# check if bluetooth is on
exec 2>> /tmp/debug

# get status of bluetooth
blue_stat="$(hcitool dev | grep -vc Devices)"

test "$blue_stat" -gt 0 \
    && {
        colour="#[fg=brightwhite]#[bg=#0181F9]"
        blue="Bluetooth"

        # print it centered and nicely
        printf "$colour%5s%-6s#[default]\n" "$(echo "$blue" | cut -c 1-$((${#blue}/2)))" "$(echo "$blue" | cut -c $((${#blue}/2+1))-${#blue})"
    } \
    || echo ''
