# ~/.zprofile
#
# Zsh login shell configuration.
# Loaded ONCE when you log in or open a new terminal window on macOS.
# Use for: environment variables, PATH, secrets, and other setup that
# only needs to happen once per session.
#
# Not loaded for: shell scripts, non-interactive commands, or new tabs
# in terminals that reuse an existing login session.
#
# See also: ~/.zshrc (loaded for every interactive shell)

echo "Loading .zprofile"

# PATH
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "/opt/homebrew/opt/postgresql@17/bin" ] && PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.bun/bin" ] && PATH="$HOME/.bun/bin:$PATH"
[ -d "/Applications/Obsidian.app/Contents/MacOS" ] && PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
export PATH

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Keys and secrets
if [[ -f "$HOME/.keys" ]]; then
    . "$HOME/.keys"
else
    echo "No .keys were found."
fi
