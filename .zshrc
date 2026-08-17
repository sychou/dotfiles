# ~/.zshrc
#
# Zsh interactive shell configuration.
# Loaded every time you open a new terminal tab, window, or run `zsh`.
# Use for: aliases, functions, prompt, key bindings, completions, and
# anything you want available at the command line.
#
# Not loaded for: shell scripts (they use their own shebang).
#
# Step 6 of 8 in the zsh startup sequence — the full table of which file
# loads when, and for which kind of shell, is in ~/.config/zsh/path.zsh.
#
# Do not set PATH here. It belongs in ~/.config/zsh/path.zsh.
#
# See also: ~/.zprofile (login), ~/.zshenv (every shell)

# --- Helper ---

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- System info ---
# Only when stdout is a real terminal, so `zsh -ic '...'` and command
# substitution don't capture this banner as part of their output.

if [[ -t 1 ]]; then
    if command_exists nerdfetch; then
        nerdfetch
    else
        echo "Kernel Information: $(uname -smr)"
        echo "Shell: $($SHELL --version)"
        echo -ne "Uptime: "; uptime
        echo -ne "Server time is: "; date
    fi
fi

# --- Zsh options ---

bindkey -v
setopt auto_cd
cdpath=($HOME $HOME/Documents $HOME/Desktop $HOME/repos)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE

# --- Aliases ---

alias systail='tail -f /var/log/system.log'
alias profileme="history 1 | awk '{print \$2}' | \
    awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | \
    tail -n 20 | sort -nr"
# brewup is now a full system-update script in ~/bin/brewup (brew, ollama
# service restart, yadm, skills repos, claude, uv, mise)

# --- Debian/Ubuntu binary names ---

# apt ships these under different names to avoid conflicts with older
# packages. Alias them back so muscle memory and scripts work either way.

if [[ $OSTYPE == linux* ]]; then
    command_exists batcat    && alias bat='batcat'
    command_exists fdfind    && alias fd='fdfind'
    command_exists trash-put && alias trash='trash-put'
fi

# --- Editor ---

# EDITOR/VISUAL are exported from ~/.zshenv so non-interactive shells get
# them too; only the interactive alias belongs here.

if command_exists nvim; then
    alias vi='nvim'
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
    alias ls='ls --color=auto -F'
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

alias grep='grep --color=auto'

# --- Completions ---
# Full compinit (with security audit) at most once a day; -C otherwise.

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# --- fzf ---
# PATH entries for fzf live in ~/.zprofile; only interactive setup here.

if command_exists fzf; then
    source <(fzf --zsh)
    alias fzp="fzf --preview 'fzf-preview.sh {}'"
    alias fzrm="fzf --preview 'fzf-preview.sh {}' --print0 -m | xargs -0 trash"
    fzmv() {
        local destination="$1"
        if [ -z "$destination" ]; then
            echo "Usage: fzmv <destination>"
            return 1
        fi

        fzf --preview 'fzf-preview.sh {}' --print0 -m | while IFS= read -r -d '' file; do
            mv -- "$file" "$destination"
        done
    }
fi

# --- yazi ---
# `yy` wraps yazi so quitting with `q` leaves the shell in whatever directory
# you ended up in. Plain `yazi` still behaves normally.

if command_exists yazi; then
    yy() {
        local tmp cwd
        tmp="$(mktemp -t yazi-cwd.XXXXXX)"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi

# --- mosh ---
# Always point at Homebrew's mosh-server on the REMOTE host. macOS ships no
# mosh-server, and the non-interactive login shell mosh starts there often
# lacks /opt/homebrew/bin on PATH, so the bare `mosh host` fails.
#
# Note this hardcodes the Apple Silicon Homebrew prefix — override with an
# explicit --server= when connecting to Linux (e.g. bradbury) or an Intel Mac.

if command_exists mosh; then
    alias mosh="mosh --server=/opt/homebrew/bin/mosh-server"
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

# --- Starship prompt ---

if command_exists starship; then
    eval "$(starship init zsh)"
fi

# --- mise ---

if command_exists mise; then
    eval "$(mise activate zsh)"
fi
