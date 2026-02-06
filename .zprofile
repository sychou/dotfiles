# .zprofile
# Loaded for login shells
# Best for environment variables
echo "Loading .zprofile"

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi


eval "$(/opt/homebrew/bin/brew shellenv)"
