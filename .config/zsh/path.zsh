# ~/.config/zsh/path.zsh
#
# The single definition of PATH. Sourced TWICE, on purpose, by ~/.zshenv
# (so automation sees these directories at all) and by ~/.zprofile (so they
# survive macOS path_helper, which reorders PATH at step 3 of zsh startup).
# The second pass is a reorder, not a duplication, because ~/.zshenv sets
# `typeset -U path PATH` first.
#
# Full explanation — the startup sequence, why twice, and what is deliberately
# kept out of this file — lives in the "zsh" section of ~/README.md.
#
# Entries are PREPENDED, so this list reads LOWEST priority first: add at the
# bottom for high priority, at the top for low.

[ -d "$HOME/.local/bin" ]          && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ]                 && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.cargo/bin" ]          && PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.fzf/bin" ]            && PATH="$HOME/.fzf/bin:$PATH"
[ -d "/opt/homebrew/opt/fzf/bin" ] && PATH="/opt/homebrew/opt/fzf/bin:$PATH"
[ -d "/opt/homebrew/sbin" ]        && PATH="/opt/homebrew/sbin:$PATH"
[ -d "/opt/homebrew/bin" ]         && PATH="/opt/homebrew/bin:$PATH"

export PATH
