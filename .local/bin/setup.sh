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

install_ohmy(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_cyan "installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    print_red "if any errors occured, try running manually"
    sleep 2
}

install_zsh(){
    if [[ ! -f /bin/zsh ]]; then
        print_red "zsh not installed!"
        print_cyan "installing zsh first..."
        sudo apt install zsh &&
        print_cyan "installing oh my zsh and plugins"
        install_ohmy
    else
        print_green "zsh installed!"
        if [[ ! -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
            print_red "oh my zsh not installed... installing now"
            install_ohmy
        else 
            print_green "oh my zsh installed"
        fi
    fi
}
config(){ # alias used to make it easier to work with these files
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

setup_env(){
    print_cyan "creating a bckp folder"
    mkdir -p .dot-backup
    print_cyan "moving old zshrc from HOME"
    mv $HOME/.zshrc $HOME/.dot-backup
    print_cyan "copying .config folder"
    cp $HOME/.config $HOME/.dot-backup/.config-bckp
    print_red "if any errors occured here, cloning the repo will probably fail, try doing it manually"
    sleep 5
}

install_code(){
    if [[ ! -f /bin/code ]]; then
        print_red "vscode not found at /bin/code"
        print_cyan "installing"
        sudo apt install code
        print_green "done? done... ok"
    fi
}

main(){
    print_cyan "Hi $(whoami), how are you?"
    print_cyan "Let's update everything first..."
    sudo apt update &&
    sudo apt upgrade
    print_cyan "and install vscode now"
    install_code
    print_green "vscode installed"
    print_red "----------"
    print_red "This script WILL override some dotfiles and .config files, make sure you know what you're doing!!!\n\n\nyou have 20 secs to ^C and exit!!!"
    print_red "----------"
    sleep 20
    print_green "ok, continuing..."
    print_cyan "Making sure git is installed..."
    setup_git
    print_green "Git setup complete... continuing..."
    print_cyan "Checking zsh and installing .oh-my-zsh"
    install_zsh
    print_cyan "zsh and oh my are now installed... setting up my configs"
    setup_env
    print_cyan "ok, getting my config files"
    git clone --bare https://github.com/PedroMarquetti/cfg_files.git $HOME/.cfg
    print_green "Done"
    config checkout
    config config status.showUntrackedFiles no
}

main