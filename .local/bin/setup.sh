#!/bin/bash

# setting XDG vars
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

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
    if [[ ! -f /bin/code ]]; then
        return 1
    fi
    
}

function install_games(){
    print_cyan "installing steam"
    sudo apt install -y steam &&
    print_cyan "installing lutris"
    sudo apt install -y lutris &&
    print_cyan "installing wine"
    sudo apt install -y wine &&
    print_cyan "installing discord"
    flatpak install --system -y com.discordapp.Discord&&
    print_cyan "installing heroic with flatpak"
    flatpak install --system -y heroic 
    
}

function install_misc(){
    print_cyan "installing gufw"
    sudo apt install -y gufw &&
    print_cyan "installing spotify with flatpak"
    flatpak install --system -y  com.spotify.Client &&
    print_cyan "installing vlc"
    sudo apt install -y vlc &&
    print_cyan "installing qbittorrent"
    sudo apt install -y qbittorrent &&
    print_cyan "installing gimp"
    sudo apt install -y gimp &&
    print_cyan "installing onlyoffice with flatpak"
    flatpak install --system -y onlyoffice &&
    print_cyan "installing telegram with flatpak"
    flatpak install --system -y org.telegram.desktop 
    print_cyan "installing vim"
    sudo apt install -y vim 
    
}

function setup_postgres(){
    sudo apt install -y postgresql postgresql-contrib libpq-dev &&
    sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" &&
    sudo -u postgres psql -c "CREATE DATABASE dev;" &&
    sudo -u postgres psql -c "CREATE ROLE dev PASSWORD 'dev' NOSUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;" &&
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE dev TO dev;" &&
    # changing pg_hba.conf to allow password auth
    sudo sed -i 's/peer/md5/g' /etc/postgresql/14/main/pg_hba.conf &&

    sudo systemctl enable postgresql &&
    sudo systemctl start postgresql
}

function install_gnome_extensions(){
    # check if .local/share/gnome-shell/extensions/ exists
    if [[ ! -d $XDG_DATA_HOME/gnome-shell/extensions ]]; then
        print_red "extensions dir. not found, creating it"
        mkdir -v -p $XDG_DATA_HOME/gnome-shell/extensions
    fi
    # install extensions
    print_cyan "installing Dash2Dock Lite"
    git clone https://github.com/icedman/dash2dock-lite.git $XDG_DATA_HOME/gnome-shell/extensions/dash2dock-lite &&
    cd $XDG_DATA_HOME/gnome-shell/extensions/dash2dock-lite &&
    make &&
    cd ~
    print_green "Dash2Dock Lite installed"
    print_cyan "installing Search Light"
    git clone https://github.com/icedman/search-light $XDG_DATA_HOME/gnome-shell/extensions/search-light &&
    cd $XDG_DATA_HOME/gnome-shell/extensions/search-light &&
    make &&
    cd ~
    print_green "Search Light installed"


}

main(){
    cd ~
    print_cyan "Hi $(whoami), how are you?"
    print_cyan "Let's update everything first..."
    sudo apt update &&
    sudo apt upgrade -y && 
    sudo apt install -y btop &&
    print_cyan "Let's install git first"
    setup_git &&
    print_green "git installed"
    print_cyan "now, checking if zsh is installed... "
    install_zsh && 
    print_green "zsh installed"
    print_cyan "and install vscode now"
    install_code && 
    print_green "vscode installed... yayyyy"
    print_cyan "setting up gnome extensions"
    install_gnome_extensions &&
    print_green "extensions installed!"
    print_cyan "installing some game launchers"
    install_games &&
    print_green "launchers installed"
    print_cyan "installing misc. stuff"
    install_misc &&
    print_green "misc. stuff installed"
    print_cyan "setting up postgres"    
    setup_postgres &&
    print_green "postgres setup done!"
    print_red "----------"
    print_red "This script WILL override some dotfiles and .config files, make sure you know what you're doing!!!\n\n\nyou have 20 secs to ^C and exit!!!"
    print_red "----------"
    sleep 20
    print_green "ok, continuing..."
    setup_env &&
    print_cyan "ok, getting my config files"
    git clone --bare https://github.com/pedromarquetti/cfg_files.git $HOME/.cfg && 
    print_green "Done"
    config checkout &&
    if [ $? = 0 ]; then
        print_green "Checked out config.";
        else
            print_red "something happened, trying again"
            print_cyan "Backing up pre-existing dot files.";
            config checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I{} mv -v {}     .dot-backup/{}
    fi;
    config config status.showUntrackedFiles no && 
    print_yellow "change shell with chsh -s /bin/zsh, then login again!"
    /bin/zsh
}

main
