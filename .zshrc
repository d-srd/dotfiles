echo "[3m$(fortune -sa)\n"    # display a random short quote at start

# colors
source /home/oda/.config/nvim/plugged/gruvbox/gruvbox_256palette.sh

# {{{ OPTIONS
export COLUMNS      # remember columns for subprocesses

export LESS_TERMCAP_mb=$'\e[0;31m'      # less start blink escape sequence
export LESS_TERMCAP_md=$'\e[0;34m'      # less start bold escape sequence
export LESS_TERMCAP_me=$'\e[0m'         # less end bold, blink, and underline
export LESS_TERMCAP_se=$'\e[0m'         # less stop standout escape sequence
export LESS_TERMCAP_so=$'\e[0;34;36m'   # less start standout escape sequence
export LESS_TERMCAP_ue=$'\e[0m'         # less stop underline escape sequence
export LESS_TERMCAP_us=$'\e[0;35m'      # less start underline escape sequence

export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)))"   # use all vcpus when compiling
# }}}

# {{{ ALIASES

#   {{{ FILE MANAGEMENT
alias cp='cp -iv'               # interactive and verbose cp
alias l='ls -l -a'              # list all files
alias ll='ls -l'                # list files
alias mkdir='mkdir -p'          # do not clobber files when making paths
alias mv='mv -iv'               # interactive and verbose mv
alias rm='rm -iv'               # interactive and verbose rm

function ls {
    command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
}

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
#   }}}

#   {{{ SHELL MANAGEMENT
alias path='echo -e ${PATH//:/\\n}'                 # show executable paths
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'   # show library paths
alias testpowerline='echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"'
#   }}}

#   {{{ WEB SERVICES
cheatsheet() { curl cheat.sh/$1; }                      # get command cheatsheet
qrcode() { echo $@ | curl -F-=\<- qrenco.de; }          # print qrcode
alias porn=' mpv "http://www.pornhub.com/random"'       # ayy lmao
# pron(){ curl -s "$(curl -s "http://www.imagefap.com/random.php?f=5" | grep -o 'http://www.imagefap.com/photo/[0-9]\+/' | shuf -n 1 )" | grep 'mainPhoto' | grep -Po '(?<=src=")[^"]*' | xargs feh; }
alias weather='curl -s wttr.in/~白井市 | head -7'       # print weather
alias weatherforecast='curl -s wttr.in/~白井市 | head -37 | tail -30'
#   }}}

alias ap='sudo create_ap --config ~/.config/create_ap.conf' # spawn wifi spot
alias bm='bmon -p wlp0s29u1u2,wlp0s29u1u1,wlp2s0,ap0 -o "curses:fgchar=S;bgchar=.;nchar=N;uchar=?;details"'
alias kal='khal interactive'                            # show calendar
alias ip='ip -c'                                        # colored ip

alias gc='git commit -am'                               # git commit with message
alias gl='git log --graph --oneline --decorate --all'   # graph git log
alias gs='git status -sb'                               # simplify git status

alias grep='grep --color=auto'                          # colored grep

alias less='less -i'                                    # case insensitive search
alias mutt='neomutt'                                    # neomutt
alias pactree='pactree --color'
alias qutebrowser='qutebrowser --backend webengine'     # webengine in qutebrowser

alias 死んでください='systemctl poweroff'   # great for shitposting
alias tree='tree -C'
alias vi='nvim'; alias vim='nvim'       # use nvim where vi or vim is called
alias vimdiff='nvim -d'                 # use nvim when diffing
# }}}

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode

# search command history with up and down keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# autocompletion
autoload -Uz compinit && compinit
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
HISTSIZE=1000                   # hist file max lines
SAVEHIST=1000                   # max amount of history to keep
setopt HIST_IGNORE_DUPS         # only keep most recent usage of a command
# }}}

# {{{ PROMPT
autoload -Uz promptinit && promptinit
prompt elite
function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
function parse_current_dir {
    ruby -e "puts ('../'+Dir.getwd.split('/').last(2).join('/')).gsub('//', '/')"
}

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown
# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment 246 235 "%(!.%{%F{yellow}%}.)$USER@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment 172 black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        prompt_segment yellow green
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 239 248 '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '

zstyle ':completion:*' menu select
# }}}
