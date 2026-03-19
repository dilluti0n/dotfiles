#!/bin/bash

get_pid() {
    pgrep -x swayidle
}

case "$1" in
    toggle)
        PID=$(get_pid)
        [ -z "$PID" ] && exit 1
        STATE=$(awk '/^State:/ {print $2}' /proc/$PID/status)
        if [ "$STATE" = "T" ]; then
            kill -SIGCONT "$PID"
        else
            kill -SIGSTOP "$PID"
        fi
        pkill -SIGRTMIN+8 waybar
        ;;
    status)
        PID=$(get_pid)
        if [ -z "$PID" ]; then
            echo '{"text": "dead", "class": "dead"}'
            exit 0
        fi
        STATE=$(awk '/^State:/ {print $2}' /proc/$PID/status)
        if [ "$STATE" = "T" ]; then
            echo '{"text": "STOP", "class": "stopped"}'
        else
            echo '{"text": "RUN", "class": "running"}'
        fi
        ;;
esac
