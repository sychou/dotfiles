# ~/.zshenv
#
# Zsh environment configuration.
# Loaded for EVERY zsh invocation — login, interactive, scripts, and
# non-interactive remote commands (e.g. `ssh host command`), plus cron,
# LaunchAgents, and coding agents. This is the only zsh startup file
# that reaches them: ~/.zprofile is login-only, ~/.zshrc interactive-only.
#
# Note: on macOS, /etc/zprofile runs path_helper AFTER this file and
# reshuffles PATH ordering in login shells, so this file guarantees
# PATH *presence*, not precedence. Interactive PATH ordering belongs
# in ~/.zprofile.
#
# Why this exists: mosh/ssh remote commands source only this file, and
# they need to find Homebrew binaries like mosh-server.
#
# Keep this file fast and silent — stray stdout breaks scp and rsync.
#
# See also: ~/.zprofile (login), ~/.zshrc (interactive)

export PATH="/opt/homebrew/bin:$PATH"

# Secrets.
#
# TEMPLATE: the values below are placeholders. Swap in the real secrets
# on each machine. Tracked by yadm with skip-worktree set, so local
# edits stay local and are never staged. To change the tracked template:
#   yadm update-index --no-skip-worktree ~/.zshenv
#   <edit, commit>
#   yadm update-index --skip-worktree ~/.zshenv

export OPENAI_API_KEY="REPLACE_ME"
export OLLAMA_API_KEY="REPLACE_ME"

# Encrypts the gog OAuth token store at
# ~/Library/Application Support/gogcli/keyring.
# Must match the value used when `gog auth add` last ran, or the tokens
# cannot be decrypted and every account must be re-authorized.
export GOG_KEYRING_PASSWORD="REPLACE_ME"
