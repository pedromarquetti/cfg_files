#!/bin/bash

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
    [[ -f /usr/bin/git || -f /bin/git ]] ||
        print_red "git not found! installing" 
        sudo apt install git -y
}

install_zsh(){
    if [[ ! -f /bin/zsh ]]; then
        print_red "zsh not found, installing... "
        sudo apt install zsh -y &&
        sleep 1
    fi
}
config(){ # alias used to make it easier to work with these files
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

setup_env(){
    print_cyan "creating a bckp folder"
    mkdir -v -p $HOME/.dot-backup/{.config-bckp,.local/bin}

    print_cyan "moving old zshrc from HOME"
    if [[ -f $HOME/.zshrc ]]; then
        mv $HOME/.zshrc $HOME/.dot-backup 
    fi
    if [[ -d $HOME/.config ]]; then
        print_cyan "copying .config folder" 
        mv -v $HOME/.config $HOME/.dot-backup/.config-bckp 
    fi
    if [[ -d $HOME/.backup ]]; then
        print_red "backup dir. found, moving it "
        mv -v $HOME/.backup $HOME/.dot-backup
    fi
    if [[ -d $HOME/.cfg ]]; then   
        print_red ".cfg dir. found, moving it "
        mv -v $HOME/.cfg $HOME/.dot-backup
    fi

}

function install_code(){
    if [[ ! -f /bin/code ]]; then
        print_red "vscode not found at /bin/code"
        print_cyan "installing"
        sudo apt-get install -y wget gpg &&
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg &&
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ &&
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && 
        rm -f packages.microsoft.gpg &&
        sudo apt update &&
        sudo apt install -y code
    fi
    
}

main(){
    print_cyan "Hi $(whoami), how are you?"
    print_cyan "Let's update everything first..."
    sudo apt update &&
    sudo apt upgrade -y && 
    sudo apt install -y htop &&
    print_cyan "Let's install git first"
    setup_git &&
    print_green "git installed"
    print_cyan "now, checking if zsh is installed... "
    install_zsh && 
    print_green "zsh installed"
    print_cyan "and install vscode now"
    install_code && 
    print_green "vscode installed... yayyyy"
    print_red "----------"
    print_red "This script WILL override some dotfiles and .config files, make sure you know what you're doing!!!\n\n\nyou have 20 secs to ^C and exit!!!"
    print_red "----------"
    sleep 20
    print_green "ok, continuing..."
    setup_env &&
    print_cyan "ok, getting my config files"
    git clone --bare https://github.com/PedroMarquetti/cfg_files.git $HOME/.cfg && 
    print_green "Done"
    config checkout &&
    if [ $? = 0 ]; then
        print_green "Checked out config.";
        else
            print_red "something happened, trying again"
            print_cyan "Backing up pre-existing dot files.";
            config checkout 2>&1 | egrep "^[\s+]" | awk {'print $1'} | xargs -I{} mv -v {}     .dot-backup/{}
    fi;
    config config status.showUntrackedFiles no && 
    chsh -s /bin/zsh &&
    /bin/zsh
}

main
