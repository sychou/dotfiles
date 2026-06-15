# ~/.zshrc
#
# Zsh interactive shell configuration.
# Loaded every time you open a new terminal tab, window, or run `zsh`.
# Use for: aliases, functions, prompt, key bindings, completions, and
# anything you want available at the command line.
#
# Not loaded for: shell scripts (they use their own shebang).
#
# See also: ~/.zprofile (loaded once per login session)

echo "Loading .zshrc"

# --- Helper ---

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- System info ---

if command_exists nerdfetch; then
    nerdfetch
else
    echo "Kernel Information: $(uname -smr)"
    echo "Shell: $($SHELL --version)"
    echo -ne "Uptime: "; uptime
    echo -ne "Server time is: "; date
fi

# --- Zsh options ---

bindkey -v
setopt auto_cd
cdpath=($HOME $HOME/Documents $HOME/repos)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# --- Aliases ---

alias systail='tail -f /var/log/system.log'
alias profileme="history | awk '{print \$2}' | \
    awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | \
    tail -n 20 | sort -nr"
alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'

# --- Editor ---

if command_exists nvim; then
    alias vi='nvim'
    export EDITOR=nvim
    export VISUAL=nvim
fi

# --- eza ---

if command_exists eza; then
    alias ls='eza --hyperlink -s extension'
    alias la='ls -a'
    alias ll='ls -l --no-quotes'
    alias lla='ll -a --git'
    alias llc='lla -s created'
else
    echo "eza not installed - https://eza.rocks"
    alias ls='ls --color=auto -F --hyperlink'
    alias ll='ls -FGlh'
    alias la='ls -Fa'
    alias lla='ls -FGlha'
fi

# --- bat ---

if ! command_exists bat; then
    echo "bat not installed - https://github.com/sharkdp/bat"
fi

# --- gdu ---

if command_exists gdu-go; then
    alias gdu='gdu-go'
fi

# --- grep ---

export GREP_OPTIONS='--color=auto'

# --- fzf ---

if [ -d "/opt/homebrew/opt/fzf/bin" ]; then
    PATH="/opt/homebrew/opt/fzf/bin:$PATH"
    export PATH
elif [ -d "$HOME/.fzf/bin" ]; then
    PATH="$HOME/.fzf/bin:$PATH"
    export PATH
else
    echo "fzf not found"
fi

if command_exists fzf; then
    source <(fzf --zsh)
    alias fzp="fzf --preview 'fzf-preview.sh {}'"
    alias fzrm="fzf --preview 'fzf-preview.sh {}' --print0 -m | xargs -0 rm"
    fzmv() {
        destination="$1"
        if [ -z "$destination" ]; then
            echo "Usage: fzmv <destination>"
            return 1
        fi

        fzf --preview 'fzf-preview.sh {}' --print0 -m | while IFS= read -r -d '' file; do
            mv -- "$file" "$destination"
        done
    }
    fzgadd() {
        git add $(git status -s | fzf -m | awk '{print $2}')
    }
fi

# --- mosh ---

if command_exists mosh; then
    alias mm="mosh --server=/opt/homebrew/bin/mosh-server mm"
    alias mms="mosh --server=/opt/homebrew/bin/mosh-server sheldon@mm-sheldon-26"
fi

# --- Python venv helper ---

venv() {
    activate_venv() {
        echo "Activating virtual environment: $1"
        source "$1/bin/activate"
        echo "Virtual environment activated. Use 'deactivate' to exit."
        which python
        python --version
    }

    if [ -d ".venv" ]; then
        activate_venv ".venv"
    elif [ -d "venv" ]; then
        activate_venv "venv"
    else
        echo "Error: No Python virtual environment found."
        echo "Please create a virtual environment named '.venv' or 'venv' in the current directory."
        return 1
    fi
}

# --- Completions ---

autoload -Uz compinit
compinit

# --- OpenClaw ---

[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# --- Starship prompt ---

if command_exists starship; then
    eval "$(starship init zsh)"
fi

# --- mise ---

if command_exists mise; then
    eval "$(mise activate zsh)"
fi

# OpenClaw Completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"
