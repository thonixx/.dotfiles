#!/bin/bash
# display backintime backup status

# check if backup fs uuid is set
if [ "x${BACKUP_FS_UUID}" == 'x' ]
then
    exit 0
fi

# no matter which locale, display it with C
export LC_ALL=C

# get status of mounted backup disk
grep -q "${BACKUP_FS_UUID}" /proc/mounts \
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
