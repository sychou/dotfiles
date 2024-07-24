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
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# fzf
if command_exists fzf; then
    source <(fzf --zsh)
fi

# starship prompt
if command_exists starship; then
    eval "$(starship init zsh)"
fi

# mise
if command_exists mise; then
    eval "$(mise activate zsh)"
fi
