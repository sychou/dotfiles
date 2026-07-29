# ~/.zprofile
#
# Zsh login shell configuration.
# Loaded ONCE when you log in or open a new terminal window on macOS.
# Use for: environment variables, PATH, secrets, and other setup that
# only needs to happen once per session.
#
# Not loaded for: shell scripts, non-interactive commands, cron, LaunchAgents,
# coding agents, or new tabs in terminals that reuse an existing login session.
#
# Step 4 of 8 in the zsh startup sequence, and the first one to run AFTER
# macOS reshuffles PATH via path_helper at step 3 — which is why PATH
# ordering has to be re-asserted here. Full table in ~/.config/zsh/path.zsh.
#
# See also: ~/.zshrc (interactive), ~/.zshenv (every shell)

# PATH
#
# Same file ~/.zshenv already sourced, deliberately sourced again. Between
# the two, /etc/zprofile ran path_helper, which rebuilt PATH with the system
# directories first and demoted everything set earlier. This restores the
# intended order. `typeset -U path` (set in ~/.zshenv) makes it a reorder
# rather than a duplication. Full explanation and the startup sequence are
# in the header of the file itself.
[ -r "$HOME/.config/zsh/path.zsh" ] && source "$HOME/.config/zsh/path.zsh"

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Keys and secrets are loaded from ~/.zshenv so they also reach
# non-interactive shells, scripts, cron, and agents.
