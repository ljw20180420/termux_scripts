#!/bin/bash

while true
do
    target_epoch=$(date -d 'tomorrow 00:00' +%s)
    current_epoch=$(date +%s)
    sleep_seconds=$(( target_epoch - current_epoch ))
    sleep $sleep_seconds
    termux-media-player play Renatus.mp3
    while true
    do
        answer=$(termux-dialog radio -v "pause,stop" -t clock | jq -r '.text')
        if [ "$answer" = "stop" ]
        then
            termux-media-player stop
            break
        fi
        termux-media-player pause
        sleep 5
        termux-media-player play
    done
done
