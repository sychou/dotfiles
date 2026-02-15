# Dotfiles

These dotfiles are managed by [yadm](https://yadm.io/).

## Setting Up a New Mac

Remove all apps from Dock (personal preference).

Install NextDNS from App Store and set up with custom ID from https://my.nextdns.io.

Download Ghostty from https://ghostty.org/ and start it.

Install Homebrew (and follow instructions for adding brew to environment).

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install yadm.

```
brew install yadm
```

Clone my dotfiles repo and run the bootstrap.

```
yadm clone https://github.com/sychou/dotfiles
```

The bootstrap script handles everything else: Homebrew packages, cask apps, fonts, mise runtimes, and Python tools.

### Configuration

- Start 1Password and login
- Start Brave or Chrome
    - Change default browser
    - Set up sync
    - Set up Kagi as default search
- Start Obsidian
    - Set up vaults via Sync
    - Place in /Users/sean/Vaults (it will automatically create a subdirectory named after vault)
- System Settings
    - Automatically hide and show the Dock
    - Set up Internet Accounts
    - Enable iCloud > iCloud Drive > Desktop & Document Folders
- Restore ~/.ssh files

## Tracked Files

```
.bash_profile
.bashrc
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
.profile
.shrc
.sqliterc
.tmux.conf
.vim/colors/nord.vim
.vimrc
.visidatarc
.zprofile
.zshrc
README.md
bin/fzf-preview.sh
```

## sh, bash, and zsh

Main shell is zsh but these configs retain backward compatibility with sh (dash), bash, and zsh.

### Profile files

- `.profile` contains the majority of login shell config
- `.bash_profile` sources `.profile` and adds bash-specific config
- `.zprofile` sources `.profile` and adds zsh-specific config

### RC files

- `.shrc` contains the majority of interactive shell config
- `.bashrc` sources `.shrc` and adds bash-specific config
- `.zshrc` sources `.shrc` and adds zsh-specific config

Note: `.shrc` is not loaded by dash (sh) by default. If using dash, manually source it with `source .shrc`.

## Installed Packages

The bootstrap script installs everything via Homebrew. Here are the key CLI tools:

- bat, better cat
- eza, better ls
- fd, better find
- fzf, fuzzy finder
- gdu, disk usage
- gh, GitHub CLI
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
- neovim, improved vim
- nerdfetch, improved neofetch
- ollama, local LLM runner
- openssl
- ripgrep, better grep
- starship, better prompt
- temporal, workflow engine
- tmux, terminal multiplexer
- tree, directory listing
- uv, Python package manager
- yadm, dotfile manager
- yq, YAML processor

### Fonts (Cask)

- FiraCode Nerd Font
- JetBrains Mono Nerd Font

### GUI Apps (Cask)

1Password, Bambu Studio, ChatGPT, Claude, CleanShot, Cursor, Discord, Docker, Google Chrome, Granola, HandBrake, Logi Options+, Microsoft Teams, MonitorControl, Notion, Obsidian, Postman, Signal, Slack, Spotify, Tailscale, Telegram, Trezor Suite, Visual Studio Code, VLC, Webex, WhatsApp, Zoom

### Python Tools (via uv)

- tldr, better man pages

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

