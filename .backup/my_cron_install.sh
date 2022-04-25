#!/bin/bash

CRON="@reboot   (date && echo '\nupdate\n' && flatpak -y update && echo '\nupgrade\n\n' && flatpak -y upgrade && echo '\n') >> /home/$(whoami)/.local/logs/flatpak/autoupdate.log"
declare -rA COLORS=(
    [RED]=$'\033[0;31m'
    [GREEN]=$'\033[0;32m'
    [BLUE]=$'\033[0;34m'
    [PURPLE]=$'\033[0;35m'
    [CYAN]=$'\033[0;36m'
    [WHITE]=$'\033[0;37m'
    [YELLOW]=$'\033[0;33m'
    [BOLD]=$'\033[1m'
    [OFF]=$'\033[0m'
)

print_red () {
    echo -e "${COLORS[RED]}${1}${COLORS[OFF]}\n"
}

print_yellow () {
    echo -e "${COLORS[YELLOW]}${1}${COLORS[OFF]}\n"
    sleep 1
}

print_green () {
    echo -e "${COLORS[GREEN]}${1}${COLORS[OFF]}\n"
    sleep 1
}

print_cyan () {
    echo -e "${COLORS[CYAN]}${1}${COLORS[OFF]}\n"
}

function main(){
    print_cyan "Hi, this script will install crontabs that i use to update my machine"
    sleep 1
    print_red "This is the crontab for non root user, and will NOT check if command already exists"
    sleep 5
    (crontab -l 2>/dev/null; echo $CRON) | crontab -
}
main