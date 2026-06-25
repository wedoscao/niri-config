#!/bin/bash

handle() {
    case "$1" in
    "activewindow>>"*)
        window_class=$(echo "$1" | awk -F '>>|,' '{print $2}')

        if [[ "$window_class" == *"xournalpp"* ]]; then
            otd applypreset Xournal++
        else
            otd applypreset Default
        fi
        ;;
    esac
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
