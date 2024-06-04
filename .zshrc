# exporting these fix an error I was having with znap

#export XDG_DATA_HOME=$HOME/.local/share 
#export XDG_CACHE_HOME=$HOME/.cache
#export XDG_CONFIG_HOME=$HOME/.config

# History configurations
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt appendhistory
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
# setopt share_history        # share command history data

export WORDCHARS='*?_.~=&;!#$%^' #ctrl+<-(or backspace/del) will treat these as part of the word

# custom prompt
PROMPT='%F{green}%~ %F{white}%(!.#.$) '
RPROMPT='%F{green}%(?.√.%F{red}error code %?)%f %F{green}%n%F{white}'

# Check if Git dir exists
[[ -d ~/Git ]] || 
    # || ==> right-side code will only exec if left side code == false
    # ^ if [[ ! -d ~/Git ]]...
    echo "Creating Git dir at ~" \ 
    mkdir -p ~/Git

# Download Znap, if it's not there yet.
[[ -f ~/Git/zsh-snap/znap.zsh ]] || 
    # explanation for this syntax: 
    # https://unix.stackexchange.com/questions/24684/confusing-use-of-and-operators
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Git/zsh-snap

source ~/Git/zsh-snap/znap.zsh

# `znap source` automatically downloads and starts your plugins.
znap source zsh-users/zsh-syntax-highlighting
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions

source $HOME/.profile # i keep some other configs here, you can comment this line out if you want

#######################
# copied from old zshrc>
setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

# configure key keybindings
bindkey -e                                      # emacs key bindings
bindkey '^K' kill-whole-line                    # kill whole line
bindkey ' ' magic-space                         # do history expansion on space
bindkey '^[[3;5~' kill-word                     # ctrl + delete -> kill word foward
bindkey '^H' backward-kill-word                 # kill word left of cursor << this key can vary
# bindkey '^?' backward-kill-word               # if the above doesn't work, try this
bindkey '^[[3~' delete-char                     # delete
bindkey '^[[1;5C' forward-word                  # ctrl + ->
bindkey '^[[1;5D' backward-word                 # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history  # page up
bindkey '^[[6~' end-of-buffer-or-history        # page down
bindkey '^[[H' beginning-of-line                # home
bindkey '^[[F' end-of-line                      # end
bindkey '^[[Z' undo                             # shift + tab undo last action
bindkey '^ '   autosuggest-accept	            # accept autosuggest with ctrl+space

# enable completion features
autoload -Uz compinit
# compinit -d ~/.cache/zcompdump
compinit -u
# commented the line below because autocomplete was not working
zstyle ':completion:*:*:*:*:*' menu yes select 
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# autocomplete config
zstyle ':autocomplete:*' min-input 1 # Wait until 1 character have been typed, before showing completions.

# Wait this many seconds for typing to stop, before showing completions.
zstyle ':autocomplete:*' min-delay 0.05  # seconds (float)


ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command-substitution]=none
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[process-substitution]=none
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[named-fd]=none
ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'


# Take advantage of $LS_COLORS for completion as well
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
export LESS_TERMCAP_ue=$'\E[0m'     # reset underline


#############################
# User configuration
#############################

function updater() {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}apt update:${NC} \n" &&
    sudo apt update &&
    printf "${RED}upgrading:${NC} \n" &&
    sudo apt upgrade --allow-downgrades --yes &&
    printf "${RED}upgrading dist:${NC} \n" &&
    sudo apt dist-upgrade --yes --allow-downgrades &&
    printf "${RED}autoremove\n${NC}"
    sudo apt autoremove --yes &&
    printf "${RED}updating flatpak:${NC} \n" &&
    flatpak -y update &&
    printf "${RED}upgrading flatpak:${NC} \n" &&
    flatpak -y upgrade &&
    printf "${RED}remove unused?:${NC} \n" &&
    flatpak uninstall --unused
    printf "${RED}updating znap\n${NC}" &&
    znap pull

}

# fix for an TILIX error i was having
if [[ -f /usr/bin/tilix || -f /bin/tilix ]]; then
    
    if [[ ! -f /etc/profile.d/vte.sh ]]; then
        echo "/etc/profile.d/vte.sh not found!!! tilix will throw an err... "
        echo "running 'sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh'"
        sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
    fi
    if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
    fi
fi

#### custom aliases ayyy ####

# enable color support of ls, less and man, and also add handy aliases
alias l='ls -l --color=auto'
alias la='ls -A --color=auto'
alias ls='ls -lt --color=auto'
alias lss='ls -lah --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep -n -B 2 -A 2  --color=auto '
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias c='clear'

# ### git
alias ginit="git init"
alias gru="git remote update"
alias gpull="git pull"
alias gpush="git push"
alias gstats="git status"
alias gadd="git add"
alias gcommit="git commit"


### misc
# alias vim='vim -c "set number"'   # show
alias nano='nano -l'                # line nums
alias img='eog '                    # img opener
alias rm='rm -ri'                   # recursive  & ask to remove
alias rmf='rm -rf '                 # recursive force -- caution
alias whois='whois -H'              # hides legal stuff
alias myip='python3 /home/phlm/Documents/programming/python/my_ip/my_ip.py'
alias open='gio open 2>/dev/null '  # open with default app
alias py='python3'
alias pip3update="pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U"
alias pingg='ping -c 10'             # ping limiter
alias mkdir='mkdir -p '

# dotfile commands
alias backup_dconf="dconf dump / > $HOME/.backup/backup.dconf"
alias config="/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME" 
alias dconf_restore="dconf load / < $HOME/.backup/backup.dconf"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
