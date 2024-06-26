# ~/.bash_profile

echo "Loading .bash_profile"

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi
