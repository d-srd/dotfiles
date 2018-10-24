echo "$(fortune -soa | cowthink -s | lolcat)\n"    # display a random offensive short quote at start
# remove zsh builtin 'r' which repeats the last command
disable r

source $HOME/dotfiles/.bash_profile

# rbenv :D
eval "$(rbenv init -)"

# zsh completions
fpath=(/usr/local/share/zsh-completions $fpath)
source $HOME/dotfiles/.git-flow-completion.zsh

# {{{ OPTIONS
export COLUMNS      # remember columns for subprocesses

export LESS_TERMCAP_mb=$'\e[0;31m'      # less start blink escape sequence
export LESS_TERMCAP_md=$'\e[0;34m'      # less start bold escape sequence
export LESS_TERMCAP_me=$'\e[0m'         # less end bold, blink, and underline
export LESS_TERMCAP_se=$'\e[0m'         # less stop standout escape sequence
export LESS_TERMCAP_so=$'\e[0;34;36m'   # less start standout escape sequence
export LESS_TERMCAP_ue=$'\e[0m'         # less stop underline escape sequence
export LESS_TERMCAP_us=$'\e[0;35m'      # less start underline escape sequence

export CLICOLOR=1                       # colors in ls
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx  # no idea how this works, but it does

# fucking cocoapods
export COCOAPODS_DISABLE_STATS=true
export HAXE_STD_PATH="/usr/local/lib/haxe/std"


# {{{ ALIASES

#   {{{ FILE MANAGEMENT
alias cp='cp -iv'               # interactive and verbose cp
alias l='/usr/local/bin/gls -la --color -h --group-directories-first'              
alias ll='ls -l'                # list files
alias mkdir='mkdir -p'          # do not clobber files when making paths
alias mv='mv -iv'               # interactive and verbose mv
alias lizard='python3 /usr/local/lib/python3.7/site-packages/lizard.py'

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

function add-ssh() {
    curpath=$(pwd)
	cd ~/.ssh
	ssh-add
    cd $curpath
}

function menza() {
    python3 ~/Developer/scripts/menza.py | awk '/JELOVNIK/,EOF' | ghead -n -1 | elinks --dump
}
#   }}}

#   {{{ SHELL MANAGEMENT
alias path='echo -e ${PATH//:/\\n}'                 # show executable paths
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'   # show library paths
alias testpowerline='echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"'

#   }}}

#   {{{ WEB SERVICES
cheatsheet() { curl cheat.sh/$1; }                      # get command cheatsheet
qrcode() { echo $@ | curl -F-=\<- qrenco.de; }          # print qrcode

function wttr() {           # current weather 
    curl -s wttr.in/$1 | awk 'n>=2 { print a[n%2] } { a[n%2]=$0; n=n+1 }'
}

function activeSimulator() {
    xcrun simctl list | egrep '(Booted)'
}

function swiftRename() {
    find . -type f -name "*.swift" -exec gsed -i "s/$1/$2/g" {} \;
}

function localIP() {
    ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' 
}

# hashtag funny
function pasta() {
    say -v Fred "What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little "clever" comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo."
}

function wtf() {
    if [ -z "$1" ]; then
        say -v Good\ News "What the fuck!!"
    else
        say -v Good\ News "What the fuck $(echo $1)"
    fi
}

alias gc='git commit -am'                               # git commit with message
alias gl='git log --graph --oneline --decorate --all'   # graph git log
alias gs='git status -sb'                               # simplify git status

alias grep='grep --color=auto'                          # colored grep

alias less='less -i'                                    # case insensitive search

alias tree='tree -C'
alias vi='nvim'; alias vim='nvim'       # use nvim where vi or vim is called
alias vimdiff='nvim -d'                 # use nvim when diffing
# }}}

# {{{ ZSH OPTIONS
# bindkey -v  # VIM mode

# search command history with up and down keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# autocompletion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' format $'\n%F{green}%d%f'
zstyle ':completion:*' group-name ''
setopt COMPLETE_ALIASES         # autocomplete aliases

HISTFILE=~/.local/histfile      # location of command history file
HISTSIZE=8192                   # hist file max lines
SAVEHIST=8192                   # max amount of history to keep
setopt HIST_IGNORE_DUPS         # only keep most recent usage of a command
# }}}

# {{{ PROMPT
autoload -Uz promptinit && promptinit
prompt pure

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=3
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/Users/dino/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
