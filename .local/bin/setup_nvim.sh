!#/bin/bash

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

print_red() {
    echo -e "${COLORS[RED]}${1}${COLORS[OFF]}\n"
    sleep 2
}

print_yellow () {
    echo -e "${COLORS[YELLOW]}${1}${COLORS[OFF]}\n";
}

print_green() {
    echo -e "${COLORS[GREEN]}${1}${COLORS[OFF]}\n";
}

print_cyan() {
    echo -e "${COLORS[CYAN]}${1}${COLORS[OFF]}\n";
}

print_cyan "checking if nvm is a function"
if [[ $(declare -f nvm 2>/dev/null) || -f /bin/nvm ]]; then
		print_green "nvm installed as a function! Running nvm install node"
		nvm install node
else
print_red "NVM not installed! refer to github.com/lukechilds/zsh-nvm for how to fix 'unable to install ts_ls/bashls'"
fi

print_cyan "Checking if Neovim is installed"
if [[ ! -f /usr/bin/nvim ]]; then
    print_cyan "nvim not found on /usr/bin/..."
    
    sudo curl -o /usr/bin/nvim -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage &&
    sudo chmod a+x /usr/bin/nvim
    print_green "done!"
fi

print_cyan "Cloning my configs..."
git clone https://github.com/pedromarquetti/neovim_config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
print_green "Cloned! running nvim..."

nvim
