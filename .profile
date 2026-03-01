# ~/.profile
#
# Notes on this file:
# 
# - Be sure to maintain compatibility with sh (dash on Debian & Ubuntu)
# - Executes for login and interactive shells
# - Source this file from .bash_profile and .zprofile
# - Aliases and other interactive commands should be in rc files
# - Keys and sensitive data should be stored in the encrypted .keys file

echo "Loading .profile"

# PATH
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "/opt/homebrew/opt/postgresql@17/bin" ] && PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
[ -d "/Applications/Obsidian.app/Contents/MacOS" ] && PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
export PATH

# HOMEBREW SETUP
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    # Intel Mac backward compatible
    eval "$(/usr/local/bin/brew shellenv)"
fi

# KEYS
if [[ -f "$HOME/.keys" ]]; then
    . "$HOME/.keys"
else
    echo "No .keys were found."
fi

