# .bashrc
# Loaded for interactive shells (i.e. not shell scripts)
# Good for things at the command line such as EDITOR, aliases,
# and command prompt

echo "Loading .bashrc"

# Source .shrc for shared configurations
if [ -f "$HOME/.shrc" ]; then
    . "$HOME/.shrc"
fi

# Edit with vi mode
set -o vi

# CD path (Bash uses colon-separated paths instead of arrays)
CDPATH="$HOME:$HOME/Documents:$HOME/src"
export CDPATH

# bash command history
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# fzf
if command_exists fzf; then
    eval "$(fzf --bash)"
fi

# starship prompt
if command_exists starship; then
    eval "$(starship init bash)"
fi

# mise
if command_exists mise; then
    eval "$(mise activate bash)"
fi
