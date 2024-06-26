# .zshrc
# Loaded for interactive shells (i.e. not shell scripts)
# Good for things at the command line such as EDITOR, aliases,
# and command prompt

echo "Loading .zshrc"

# Source .shrc for shared configurations
if [ -f "$HOME/.shrc" ]; then
    . "$HOME/.shrc"
fi

# Edit with vi mode
bindkey -v

# CD path
setopt auto_cd
cdpath=($HOME $HOME/Documents $HOME/src)

# fzf
if command_exists fzf; then
    source <(fzf --zsh)
fi

# starship prompt
if command_exists starship; then
    eval "$(starship init zsh)"
fi

