#!/bin/bash

SCRIPTDIR="${0}"

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
setup_git(){
    if [[ ! -f /usr/bin/git ]]; then
        print_red "git not found! installing"
        sudo apt update && sudo apt upgrade && sudo apt install git
    else
        print_green "git installed!"
    fi 
}

config(){ # alias used to make it easier to work with these files
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

main(){
    print_cyan "Hi, $(whoami), how are you?"
    print_cyan "Let's update everything first..."
    sudo apt update &&
    sudo apt upgrade
    print_red "----------"
    print_red "This script WILL override some dotfiles and .config files, make sure you know what you're doing!!!\n\n\nyou have 20 secs to ^C and exit!!!"
    print_red "----------"
    sleep 20
    print_green "ok, continuing..."
    print_cyan "making sure git is installed..."
    setup_git
    print_green "setup complete... cloning..."
    git clone --bare https://github.com/PedroMarquetti/cfg_files.git $HOME/.cfg
    print_green "done"
    config checkout
    config config status.showUntrackedFiles no
}

main