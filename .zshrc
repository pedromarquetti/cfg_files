# exporting these fix an error I was having with znap
export XDG_DATA_HOME=$HOME/.local/share 
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config

export HISTSIZE=500000
export SAVEHIST=1000  # Save most-recent 1000 lines
export HISTFILE=$HOME/.zsh_history
export WORDCHARS='*?_-.~=&;!#$%^' #ctrl+<- will treat these as part of the word
setopt SHARE_HISTORY # HISTFILE will be updated on each command sent 

# Check if Git dir exists
[[ -d ~/Git ]] || 
    # || ==> right-side code will only exec if left side code == false
    echo "Creating Git dir at ~" \ 
    mkdir -p ~/Git

# Download Znap, if it's not there yet.
[[ -f ~/Git/zsh-snap/znap.zsh ]] || 
    # explanation for this syntax: 
    # https://unix.stackexchange.com/questions/24684/confusing-use-of-and-operators
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Git/zsh-snap

source ~/Git/zsh-snap/znap.zsh
# set -vx 

# `znap source` automatically downloads and starts your plugins.
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

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

# # enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# ## autocomplete config
zstyle ':autocomplete:*' min-input 1 # Wait until 1 character have been typed, before showing completions.

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PROMPT='%F{green}%~ %F{white}%(!.#.$) '
    RPROMPT='%F{green}%(?.√.%F{red}error code %?)%f %F{green}%n%F{white}'
    #enable syntax-highlighting
    if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  ||  -f $HOME/Git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        # . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
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
    fi
else
    PROMPT='%F{green}%~ %F{white}%(!.#.\$) '
fi
# unset color_prompt force_color_prompt

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'     # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# enable auto-suggestions based on the history
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh || -f $HOME/Git/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

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

}
#fix for an TILIX error i was having
if [[ ! -f /etc/profile.d/vte.sh ]]; then
	echo "/etc/profile.d/vte.sh not found!!! tilix will throw an err... "
	echo "running 'sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh'"
	sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
fi
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

#### custom aliases ayyy ####

alias l='ls -l'
alias la='ls -A'
alias ls='ls -lt --color=auto'
alias lss='ls -lah --color=auto'
alias c='clear'
alias cdd='cd ~'

# ### git
alias ginit="git init"
alias gru="git remote update"
alias gpull="git pull"
alias gpush="git push"
alias gstats="git status"
alias gadd="git add"
alias gcommit="git commit"

### docs
alias doc='libreoffice --writer' #open doc file
alias calc='libreoffice --calc'  #open calc (sheets)

### misc
alias vim='vim -c "set number"' #show
alias nano='nano -l'            #line nums
alias img='eog '                #img opener
alias rm='rm -ri'               #recursive  & ask to remove
alias rmf='rm -rf '             # recursive force -- caution
alias whois='whois -H'          #hides legal stuff
alias myip='python3 /home/phlm/Documents/programming/python/my_ip/my_ip.py'
alias open='gio open 2>/dev/null '
alias py='python3'
alias vpnstat='curl https://www.cloudflare.com/cdn-cgi/trace/'
alias firefox="firefox 2>/dev/null"
alias pip3update="pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U"
alias config="/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME" 
alias ping='ping -c 6 ' #ping limiter
alias backup_dconf="dconf dump / > $HOME/.config/backup.dconf"
alias dconf_restore="dconf load / < $HOME/.config/backup.dconf"
alias backup_flatpak="flatpak list --columns=application --app | awk '{print "flatpak install  --user \""$0"\" "}' > $HOME/.backup/flatpak_backup.sh"
alias backup_code_extensions="code --list-extensions | xargs -L 1 echo code --install-extension > $HOME/.config/Code/Backups/code_extensions.lst"
alias mkdir='mkdir -p '
alias zoom_text="dconf write /org/gnome/desktop/interface/text-scaling-factor " # changes text scaling factor with a command
