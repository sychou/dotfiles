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

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt append_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space

# fzf
if command_exists fzf; then
    source <(fzf --zsh)
fi

# starship prompt
if command_exists starship; then
    eval "$(starship init zsh)"
fi

