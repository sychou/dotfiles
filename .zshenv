# ~/.zshenv
#
# Zsh environment configuration.
# Loaded for EVERY zsh invocation — login, interactive, scripts, and
# non-interactive remote commands (e.g. `ssh host command`).
# Use for: the minimal environment that must always be present.
#
# Note: on macOS, /etc/zprofile runs path_helper AFTER this file and
# reshuffles PATH ordering in login shells, so this file guarantees
# PATH *presence*, not precedence. Interactive PATH ordering belongs
# in ~/.zprofile.
#
# Why this exists: mosh/ssh remote commands source only this file, and
# they need to find Homebrew binaries like mosh-server.
#
# See also: ~/.zprofile (login), ~/.zshrc (interactive)

export PATH="/opt/homebrew/bin:$PATH"
