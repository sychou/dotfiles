# Dotfiles

These dotfiles are managed by [yadm](https://yadm.io/). This README is an
inventory: which files are tracked, and what the bootstrap installs on which
kind of machine. It does not describe how to set a machine up.

## Tracked Files

The authoritative list is whatever yadm has, so read it from yadm rather than
from here:

```sh
yadm list -a
```

Some entries carry a `##` suffix, such as `platform##os.Darwin` or
`plist##hostname.<host>`. That is yadm's alternate-file mechanism: it checks out
the variant matching the current OS or hostname and ignores the rest, which is
how one repo holds per-platform and per-machine versions of the same file.

### Shell

- `.zshenv`, runs for every zsh; PATH, `EDITOR`, and the machine-local secrets file
- `.zprofile`, login shells; Homebrew `shellenv` and the PATH reorder after `path_helper`
- `.zshrc`, interactive shells; prompt, aliases, functions, vi-mode bindings, completions, history, mise
- `.config/zsh/path.zsh`, the single definition of `PATH`, sourced by both of the above
- `.inputrc`, readline: vi editing mode, case-insensitive completion

### Git and GitHub

- `.gitconfig`, with per-platform includes
- `.config/git/platform##os.Darwin` and `##os.Linux`, the platform halves (signing program, credential helper)
- `.config/git/ignore`, the global ignore list
- `.config/gh/config.yml`, GitHub CLI defaults
- `.ssh/config`, host blocks and the agent socket
- `.ssh/allowed_signers`, public keys that verify signed commits

### Editors

- `.vimrc` and `.vim/colors/nord.vim`, keeps vim usable where neovim is absent
- `.config/nvim/init.lua`, `lua/plugins/which-key.lua`, `.luarc.json`, a standalone lazy.nvim config: catppuccin, lualine, gitsigns, telescope, treesitter, rainbow_csv, which-key, plus gruvbox, nord, and tokyonight themes switched with `:Theme <name>`
- `.config/zed/settings.json` and `keymap.json`

### Terminal and TUIs

- `.config/ghostty/config`, FiraCode Nerd Font, `ctrl+space` quick terminal, shift+enter newline
- `.tmux.conf`, prefix `ctrl-a`, status bar on top, no plugin manager
- `.config/lf/lfrc` and `previewer.sh`, file manager with `g<key>` directory jumps
- `.config/yazi/keymap.toml`, the same jump family for yazi, plus `M<key>` moves
- `.visidatarc`, `.sqliterc`, `.nethackrc`

### Tools

- `.config/mise/config.toml`, runtime versions and the npm-backed tools
- `.config/qmd/index.yml`, the note-search collections
- `.config/gumshoe/config.toml`, sources for the gumshoe vault
- `.claude/CLAUDE.md`, Claude Code's user instructions; imports a shared body from a separate repo

### yadm

- `.config/yadm/bootstrap`, the installer, macOS and Ubuntu
- `.config/yadm/host-extras##hostname.<host>`, one-off setup for a single machine, sourced by the bootstrap if present

### Per-machine services

- `.config/launchd/<label>.plist##hostname.<host>`, LaunchDaemons the bootstrap copies into `/Library/LaunchDaemons`
- `Library/LaunchAgents/<label>.plist##hostname.<host>`, LaunchAgents yadm materialises at the load path

### Scripts in `bin/`

- `brewup`, whole-system updater: Homebrew, ollama, yadm, the skills repo, mise, uv
- `copy`, stdin to the clipboard on macOS, Wayland, or X11
- `fzf-preview.sh`, file and image preview for fzf
- `gumshoe`, pulls newsletters and YouTube transcripts into the gumshoe vault
- `health-check`, machine health probe that pings Healthchecks.io
- `install-launch-daemon.sh`, installs a tracked LaunchDaemon plist
- `jaunt`, rotates Tailscale exit nodes per namespace with cooldowns
- `msgvault-nightly`, one ordered pass over every msgvault sync, then a backup
- `report-mqtt`, publishes a job result to the MQTT broker

## What the Bootstrap Installs

Every machine gets the same tracked configs and the same core CLI toolchain.
Beyond that the bootstrap asks what the machine is: a **workstation** someone
sits at gets GUI apps and fonts, a **server** runs services unattended, and an
**exit node** forwards traffic for the tailnet. The bootstrap never uninstalls.

### CLI tools, every machine

On macOS these come from Homebrew; on Ubuntu the same tools come from several
places, listed under [Ubuntu package sources](#ubuntu-package-sources).

Not installed on Ubuntu: `lazygit`, `supabase` and `vercel` (Mac-only by
choice), plus `ffmpeg`, `lf`, `mlx`, `mole` and `poppler` (Mac-only in practice; `mlx`
is Apple-silicon and `mole` is a macOS cleanup app).

- bat, better cat
- eza, better ls
- fd, better find
- ffmpeg, audio/video transcoding
- fzf, fuzzy finder
- gdu, disk usage
- gh, GitHub CLI
- gogcli, Google Workspace CLI (`gog`)
- git, version control
- htop, better top
- jless, JSON viewer
- jq, JSON processor
- lazygit, git TUI
- lf, terminal file manager
- lua, scripting language
- mise, runtime version manager
- mlx, Apple ML framework
- mole, Mac cleanup and optimisation
- mosh, better ssh
- mosquitto, MQTT broker and clients
- msgvault, email, meeting and calendar archive client
- neovim, improved vim
- nerdfetch, improved neofetch
- ntfy, push notifications from the shell
- ollama, local LLM runner
- opencode, terminal coding agent
- openssl
- poppler, PDF utilities (pdftotext, etc.)
- ripgrep, better grep
- starship, better prompt
- supabase, Supabase CLI (local stack runs in Docker Desktop)
- tmux, terminal multiplexer
- trash, safe rm (sends to macOS Trash)
- tree, directory listing
- tree-sitter-cli, parser generator/CLI
- uv, Python package manager
- vercel, Vercel CLI
- yadm, dotfile manager
- yazi, terminal file manager (TUI)
- yq, YAML processor

### Runtimes, via mise

Set globally by the bootstrap: python 3.14, node, bun, go, pnpm.

### Python tools, via uv

- tldr, better man pages
- csvkit, CSV toolkit (in2csv, csvlook, csvgrep, etc.)
- mlx-lm, macOS only

### Node tools, via mise

Declared in `.config/mise/config.toml` and installed by mise's npm backend, so
they survive node upgrades:

- qmd, local markdown search engine

### Installed by script

- Claude Code, via Anthropic's installer, landing in `~/.local/bin/claude`

### Fonts, macOS workstations

- FiraCode Nerd Font
- JetBrains Mono
- JetBrains Mono Nerd Font

### GUI apps, macOS

Every Mac, headless ones included:

1Password, 1Password CLI, Docker Desktop, Ghostty, Google Chrome, Tailscale,
Visual Studio Code

Workstations only:

Boop, ChatGPT, Claude, CleanShot, Discord, Granola, HandBrake, Microsoft
Teams, Obsidian, Signal, Slack, Spotify, Telegram, VLC, Webex, WhatsApp, Wispr
Flow, Zoom

Apps tied to a particular piece of hardware, and CLIs tied to a particular
project, are installed by hand where they are needed rather than listed here.

### Mac App Store only

Not available via Homebrew, so the bootstrap lists them as a manual step:

NextDNS, Paprika Recipe Manager 3, Pixelmator Pro, Obsidian Web Clipper (Safari
extension)

### GUI apps, Ubuntu

Workstations get `ubuntu-desktop-minimal` and `vlc` from apt. 1Password,
Chrome, Obsidian, VS Code, and Ghostty install from vendor `.deb`s as a manual
step.

## Ubuntu package sources

The same toolchain, but apt only has part of it. `ubuntu_apt` runs first because
it brings `curl`, `jq`, `gnupg` and `unzip`, which the rest depend on.

| Source | Tools |
| ------ | ----- |
| **apt** | git, htop, jq, mosh, ripgrep, tmux, tree, fzf, yadm, openssl |
| **apt, renamed** | `bat`→`batcat`, `fd-find`→`fdfind`, `trash-cli`→`trash-put`, `lua5.4` |
| **PPA** | neovim (`ppa:neovim-ppa/stable`; apt's is stale) |
| **Vendor apt repo** | gh, eza, ntfy — these auto-update afterwards |
| **Install script** | mise, uv, starship, opencode, ollama |
| **GitHub release** | tree-sitter, yq, gdu, jless, yazi, gog |
| **uv / npm** | tldr, csvkit, qmd — unchanged from macOS |
| **Shell script** | nerdfetch |

Three of those need aliases, which `.zshrc` applies behind a Linux guard:

```zsh
alias bat='batcat'; alias fd='fdfind'; alias trash='trash-put'
```

The release downloads resolve `releases/latest` through the public GitHub API
rather than `gh release download`, because `gh` needs an authenticated session
that a fresh box does not have. The asset patterns assume **x86_64**.

**Docker** installs from the official `docker-ce` repo on every Linux machine,
not Ubuntu's `docker.io` (which lags) and not the snap (whose confinement causes
volume-permission surprises with bind mounts).

`tree-sitter-cli` is not optional: `init.lua` pins nvim-treesitter to its `main`
branch, which requires it at 0.26.1+ and specifically says to install it from a
package manager rather than npm. apt's is too old, hence the release binary.

## Philosophy

Package installation preference on Mac:

1. Direct when recommended
2. Homebrew (and Casks)
3. uv for Python-based tools
4. Direct when not available via brew or uv

Machine-specific state, such as local LLM models, API keys, and app logins,
stays out of the repo on purpose. The bootstrap gets a machine to the point
where those can be added, and no further.
