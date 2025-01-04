# Dotfiles

These dotfiles are designed to be managed by yadm.

## Setting Up a New Mac

Remove all apps from Dock (just my personal preference).

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

### Configuration

- Start 1Password and login
- Start Brave
    - Configure appearance
    - Download 1password extension
    - Set up Kagi
- Start Obsidian
    - Set up vaults via Sync
    - Place in /Users/sean/Vaults (it will automatically create a subdirectory named after vault)
- Set up Internet Accounts

## How to Install on Linux

Linux

```
sudo apt install yadm
yadm clone https://github.com/sychou/dotfiles
```

## sh, bash, and zsh

My main shell is zsh but I wanted to retain backward compatbility with sh
(dash), bash, and zsh.

### profile files

`.profile` contains the majority of login shell config
`.bash_profile` sources `.profile` and add bash-specific config
`.zprofile` sources `.profile` and add zsh-specific config

### rc files

`.shrc` contains the majority of interactive shell config
`.bashrc` sources `.shrc` and adds bash-specific config
`.zshrc` sources `.shrc` and add zsh-specific config

Note that `.shrc` is not loaded by dash (sh) by default. If using dash, manually
source `.shrc` by `source .shrc`.

### Installed apps

While there are a number of installed support apps and libraries, the common
apps include:

- bat - better cat
- eza - better ls
- fd - better find
- fzf - awesome fuzzy finder
- gdu - disk usage
- git - version control
- htop - better top
- httpie (pipx)
- jless - json viewer
- jq - json processor
- llm (pipx)
- lua
- luarocks
- mise - pyenv replacement
- neovim - improved vim
- nerdfetch - improved neofetch
- node - js interpreter
- openssl
- pipx
- pyright (pipx)
- pytube (pipx)
- ripgrep - better grep
- ruff (pipx)
- starship - better prompt
- tailscale - vpn
- tldr (pipx) - better man
- tmux - terminal multiplexer => replacing with zellij
- visidata (pipx) - csv editor and more

## vim and neovim

My main editor is neovim but I wanted to have vim be usable on systems where I
haven't loaded up neovim for whatever reason.

`.vimrc` contains basic vim config
`./config/nvim/init.lua` references `.vimrc` but adds neovim specific plugins

My neovim init.lua has a number of plugins all managed by lazy.nvim:

- various color schemes
- lualine
- vim-tmux-navigator
- treesitter
- lsp (configured for python, lua, and json)
- cmp autocompletion
- which-key
- telescope
- gitsigns
- nvim-surround
- rainbow_csv
- dressing

## tmux and neovim

My tmux configuration relies on a few extras:

- tpm (https://github.com/tmux-plugins/tpm)
- catppuccin (https://github.com/catppuccin/tmux)
- vim-tmux navigator (https://github.com/christoomey/vim-tmux-navigator)

The bootstrap code should pull tpm but the plugins may need to be installed
via `<leader>I`. 

These plugins create a much better looking tmux, but more importantly,
enable seamless pane navigation from tmux and neovim using `<ctrl>h/j/k/l`
without any leader key required.

## wezterm and alacritty

My main terminal is wezterm so it's configuration will be the most up-to-date.
There is an alacritty config file as well but it may be out of date.

## Color Schemes

The following are good and robust color schemes with nvim and wezterm support:

- [Catpuccin](https://catppuccin.com/)
- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim)
- [Nord](https://www.nordtheme.com/ports/vim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)

These even have good Obsidian theme support!

## Philosophy

My preference on Mac for installation of packages is:

- Direct when recommended
- Homebrew (and Casks)
- Pipx for all Python based apps
- Direct when not available via brew or pipx

My preference on Ubuntu is:

- Direct when recommended
- apt
- snap
- Direct when not available via apt or snap
