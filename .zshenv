# Sourced for EVERY zsh invocation, including non-interactive shells,
# scripts, cron, LaunchAgents, and coding agents. This is the only zsh
# startup file that reaches them -- .zprofile is login-only and .zshrc
# is interactive-only.
#
# Keep this file fast and silent. Stray stdout here breaks scp and rsync.
#
# TEMPLATE: the values below are placeholders. Swap in the real secrets
# on each machine. Tracked by yadm with skip-worktree set, so local
# edits stay local and are never staged.

export OPENAI_API_KEY="REPLACE_ME"
export OLLAMA_API_KEY="REPLACE_ME"

# Encrypts the gog OAuth token store at
# ~/Library/Application Support/gogcli/keyring.
# Must match the value used when `gog auth add` last ran, or the tokens
# cannot be decrypted and every account must be re-authorized.
export GOG_KEYRING_PASSWORD="REPLACE_ME"
