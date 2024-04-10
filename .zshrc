<<<<<<< HEAD
autoload -Uz compinit
compinit
=======
export CLICOLOR=1
export EDITOR=vim
>>>>>>> c42a98c (.....add the dang rc file)

source ~/.functions
source ~/.aliases

<<<<<<< HEAD
eval "$(starship init zsh)"

# Go
export PATH="$HOME/go/bin:$PATH"

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "/Users/jjohnson/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
=======
# Prefer GNU coreutils over non-portable mac versions
if [ -d /usr/local/opt/coreutils/ ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
autoload -Uz compinit && compinit

[ "$TERM_PROGRAM" = "Apple_Terminal" ] || eval "$(starship init zsh)"
>>>>>>> c42a98c (.....add the dang rc file)
