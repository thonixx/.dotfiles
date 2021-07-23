#!/bin/bash
# display backintime backup status

# no matter which locale, display it with C
export LC_ALL=C

# get status of mounted backup disk
grep -q c8f12cbb-f6d5-4551-baa4-b9f3ec72ddf6 /proc/mounts \
    && {
    # get status of running backup
    ps faux | grep -q "[r]sync.*backintime" \
        && {
            colour="#[fg=black]#[bg=red]"
            status=" backing up "
        } \
        || {
            colour=""
            status=""
        }
    } \
    || {
        colour="#[fg=black]#[bg=red]"
        status=" bkp disk? "
    }


# print it centered and nicely
printf "$colour%5s%-5s#[default]\n" "$(echo "$status" | cut -c 1-$((${#status}/2)))" "$(echo "$status" | cut -c $((${#status}/2+1))-${#status})"
