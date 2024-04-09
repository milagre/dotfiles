# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source ~/.functions
source ~/.aliases

# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=ignoredups
HISTTIMEFORMAT='%F %T '
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=3000
HISTFILESIZE=$HISTSIZE
# Configure BASH to append (rather than overwrite the history):
shopt -s histappend
# Attempt to save all lines of a multiple-line command in the same entry
shopt -s cmdhist

export PROMPT_COMMAND="history -a"
#export PROMPT_COMMAND="echo -ne \"\033]0;$1 ($HOSTNAME)\007\"; history -a;"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# General auto-complete
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export EDITOR=vim
export GOPATH=~/go

# coreutils
if [ -d /usr/local/opt/coreutils/ ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

export PATH=$PATH:/usr/local/opt/go/libexec/bin:/usr/local/go/bin:$GOPATH/bin

[ -f ~/.bash_local ] && . ~/.bash_local

# Gruvbox doesn't work well in Terminal.  Use basic prompt instead.
export STARSHIP_CONFIG=~/.config/starship-bash.toml
eval "$(starship init bash)"
