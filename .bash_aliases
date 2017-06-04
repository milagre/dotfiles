#!/bin/bash


if ! is-mac; then
    alias ls='ls -AlF --color=auto'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias l='ls -l'
alias v='vim'
alias tf='tail -f'
# Enables alias expansion while using sudo
alias sudo='sudo '

if command -v ack-grep >/dev/null; then
  alias ack='ack-grep'
fi

if command -v thefuck >/dev/null; then
    eval "$(thefuck --alias)"
fi

function c() { curl -vvv $@; echo; }
