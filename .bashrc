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

# starship prompt
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init bash)"
fi
