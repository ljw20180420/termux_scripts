#!/bin/bash

set_clock() {
    local time=$1
    local target_epoch current_epoch sleep_seconds one_day
    target_epoch=$(date -d "tomorrow ${time}" +%s)
    current_epoch=$(date +%s)
    sleep_seconds=$(( target_epoch - current_epoch ))
    one_day=$(( 24 * 60 * 60 ))
    while [[ ${sleep_seconds} -gt ${one_day} ]]
    do
        sleep_seconds=$(( sleep_seconds - one_day ))
    done
    echo ${sleep_seconds}
}

alarm_clock() {
    local ring=$1
    local snooze=$2

    termux-media-player play "${ring}"
    while true
    do
        answer=$(termux-dialog radio -v "pause,stop" -t clock | jq -r '.text')
        if [ "$answer" = "stop" ]
        then
            termux-media-player stop
            break
        fi
        termux-media-player pause
        sleep ${snooze}
        termux-media-player play
    done
}

source "${HOME}/.config/my_services/common/parse.sh"
parse_config "${HOME}/.config/my_services/clock/config.ini"
ring=$(envsubst <<<"${ring}")

while true
do
    sleep_seconds=$(set_clock ${time})
    sleep $sleep_seconds
    alarm_clock "${ring}" "${snooze}"
done
