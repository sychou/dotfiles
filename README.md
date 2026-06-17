# Dotfiles

These dotfiles are managed by [yadm](https://yadm.io/).

## Setting Up a New Mac

Remove all apps from Dock (personal preference).

Install NextDNS from App Store and set up with custom ID from https://my.nextdns.io.

Download Ghostty from https://ghostty.org/ and start it.

Install Homebrew, then add it to the current shell's `PATH` (the installer does
**not** do this for you on Apple Silicon — without it the next steps can't find
`brew`).

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Install yadm.

```
brew install yadm
```

Clone my dotfiles repo and run the bootstrap. The repo is public, so cloning
needs no authentication.

```
yadm clone https://github.com/sychou/dotfiles
```

The bootstrap script handles everything else: Homebrew packages, cask apps,
fonts, mise runtimes, and Python tools. (The bootstrap itself re-runs the brew
`shellenv` step internally, so it works even on a fresh machine.)

### GitHub & Commit Signing

Cloning is public, but **pushing changes back requires authenticating as
`sychou`** and commits are SSH-signed via 1Password. Set this up before making
edits:

1. Start 1Password, sign in, and enable the SSH agent:
   **Settings → Developer → "Use the SSH agent"**. This is what serves both your
   SSH auth keys and the commit-signing key (`gpg.format = ssh`,
   `op-ssh-sign`). It's a per-machine toggle and is **not** restored by yadm.
2. Authenticate GitHub as `sychou` (not any other account) and wire it into git:

   ```
   gh auth login --hostname github.com --git-protocol https --web
   gh auth setup-git
   ```

3. Confirm the signing key is reachable: `ssh-add -l` should list your key, and a
   test commit should show `Good "git" signature`. If signing fails with
   "No SSH private key found", the key isn't in your 1Password Personal/Private
   vault or the agent is off.

### Configuration

- Start 1Password and login
- Start Brave or Chrome
    - Change default browser
    - Set up sync
    - Set up Kagi as default search
- Start Obsidian
    - Set up vaults via Sync
    - Place in /Users/sean/Vaults (it will automatically create a subdirectory named after vault)
- Index notes in qmd (see [qmd — Local Note Search](#qmd--local-note-search))
- System Settings
    - Automatically hide and show the Dock
    - Set up Internet Accounts
    - Enable iCloud > iCloud Drive > Desktop & Document Folders
- SSH keys and the commit-signing key come from 1Password's SSH agent (see
  "GitHub & Commit Signing" above). `~/.ssh/config` **is** tracked and points
  `IdentityAgent` at the 1Password agent socket, so terminal SSH routes through
  1Password automatically once the agent is enabled — no manual step needed
- Restore any other `~/.ssh` files / secrets not held in 1Password

## Tracked Files

```
.claude/CLAUDE.md
.config/gh/config.yml
.config/ghostty/config
.config/git/ignore
.config/lf/lfrc
.config/lf/previewer.sh
.config/mise/config.toml
.config/nvim/.luarc.json
.config/nvim/init.lua
.config/nvim/lua/plugins/which-key.lua
.config/yadm/bootstrap
.config/zed/keymap.json
.config/zed/settings.json
.gitconfig
.inputrc
.nethackrc
.sqliterc
.ssh/config
.tmux.conf
.vim/colors/nord.vim
.vimrc
.visidatarc
.zprofile
.zshrc
README.md
bin/fzf-preview.sh
```

## zsh

The shell is zsh. Two files are tracked, split by when they load:

- `.zprofile` — login shell config, loaded **once** per session. Sets `PATH`,
  runs the Homebrew `shellenv`, and sources secrets from `~/.keys` (untracked —
  restore separately).
- `.zshrc` — interactive shell config, loaded for **every** new tab/window/shell.
  Holds the prompt, aliases, functions, key bindings (vi mode), completions,
  history options, and `mise` activation.

`~/.keys` holds secrets and is intentionally not tracked by yadm; restore it from
your password manager / backup on a new machine.

## Installed Packages

The bootstrap script installs everything via Homebrew. Here are the key CLI tools:

- bat, better cat
- eza, better ls
- fd, better find
- flyctl, Fly.io CLI
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
- mise, runtime version manager (python, node)
- mlx, Apple ML framework
- mosh, better ssh
- nerdfetch, improved neofetch
- neovim, improved vim
- ollama, local LLM runner
- openssl
- poppler, PDF utilities (pdftotext, etc.)
- ripgrep, better grep
- starship, better prompt
- temporal, workflow engine
- tmux, terminal multiplexer
- trash, safe rm (sends to macOS Trash)
- tree, directory listing
- tree-sitter-cli, parser generator/CLI
- uv, Python package manager
- yadm, dotfile manager
- yq, YAML processor

### Fonts (Cask)

- FiraCode Nerd Font
- JetBrains Mono
- JetBrains Mono Nerd Font

### GUI Apps (Cask)

1Password, 1Password CLI, Bambu Studio, ChatGPT, Claude, CleanShot, Cursor, Discord, Docker Desktop, Ghostty, Google Chrome, Granola, HandBrake, Logi Options+, Microsoft Teams, MonitorControl, Notion, Obsidian, Postman, Signal, Slack, Spotify, Tailscale, Telegram, Trezor Suite, Visual Studio Code, VLC, Webex, WhatsApp, Zoom

### Python Tools (via uv)

- tldr, better man pages
- csvkit, CSV toolkit (in2csv, csvlook, csvgrep, etc.)

### Global npm Tools (via mise node)

Not on Homebrew, so installed as global npm packages after mise sets up node:

- qmd, local markdown search engine (see [qmd](#qmd--local-note-search))

## qmd — Local Note Search

[qmd](https://github.com/tobi/qmd) is a local, offline search engine for markdown
(BM25 + vector + LLM re-ranking). The bootstrap installs the CLI and its Claude
Code skill:

```
npm install -g @tobilu/qmd
qmd skill install --global --yes -f   # skill into ~/.agents/skills/qmd (+ ~/.claude symlink)
```

First run downloads ~2GB of models into `~/.cache/qmd/models/` (one time, offline
thereafter).

### Index notes

After install, add the note directories as collections and build the index. This
is a manual post-install step (the bootstrap only prints a reminder):

```
qmd collection add ~/Vaults/Main --name obs-main             # Obsidian vault
qmd collection add ~/.local/share/muesli/transcripts --name granola  # Granola transcripts (via muesli)
qmd update                                                   # index files
qmd embed                                                    # generate embeddings
```

Verify and search:

```
qmd collection list
qmd query "what did we decide about X"
```

Re-run `qmd update && qmd embed` after notes change. Scope searches to a
collection with `-c obs-main` or `-c granola`.

### Optional: MCP server

For faster, persistent access from Claude (keeps models warm across queries),
run qmd as an HTTP MCP daemon:

```
qmd mcp --http --daemon            # localhost:8181
```

Then point Claude Code/Desktop at it (see qmd's `references/mcp-setup.md`).

## Ghostty

Terminal emulator. Config at `.config/ghostty/config`.

- Font: FiraCode Nerd Font
- Global quick terminal: `ctrl+space`
- Shift+enter sends literal newline
- SSH env shell integration enabled

## lf (Terminal File Manager)

Config at `.config/lf/lfrc` with a custom previewer script.

Key bindings:
- `gh` home, `gd` Desktop, `gi` INBOX, `gp` PROJECTS, `gc` CHOUFAM, `gl` LIBRARY, `ga` ARCHIVES, `gC` ~/.config
- `a` create directory, `T` create file, `D` trash, `e` open in nvim, `x` extract archive

On quit, lf writes its current directory so the shell can follow (pair with a shell function in `.zshrc`).

## vim and neovim

Main editor is neovim but `.vimrc` keeps vim usable on systems without neovim.

`.config/nvim/init.lua` is a standalone neovim config managed by lazy.nvim with these plugins:

- catppuccin (default theme: catppuccin-mocha)
- lualine (status line)
- gitsigns (git integration)
- telescope (fuzzy finder)
- treesitter (syntax highlighting)
- rainbow_csv (CSV handling)
- which-key (keybinding help)
- gruvbox, nord, tokyonight (additional themes)

Theme switching via `:Theme <name>`.

## tmux

Prefix is `ctrl-a` (not the default `ctrl-b`). Status bar at the top.

Plugins managed by tpm:
- catppuccin (status bar theme, frappe flavor)
- vim-tmux-navigator (seamless pane navigation with neovim via `ctrl+h/j/k/l`)

The bootstrap clones tpm automatically but plugins need to be installed via `<prefix>I` on first run.

## Color Schemes

Good color schemes with broad support across nvim, ghostty, tmux, and obsidian:

- [Catppuccin](https://catppuccin.com/)
- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim)
- [Nord](https://www.nordtheme.com/ports/vim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)

## Philosophy

Package installation preference on Mac:

1. Direct when recommended
2. Homebrew (and Casks)
3. uv for Python-based tools
4. Direct when not available via brew or uv

