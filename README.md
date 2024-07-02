# Dotfiles

These dotfiles are designed to be managed by yadm.

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

## vim and neovim

My main editor is neovim but I wanted to have vim be usable on systems where I
haven't loaded up neovim for whatever reason.

`.vimrc` contains basic vim config
`./config/nvim/init.lua` references `.vimrc` but adds neovim specific plugins

## wezterm and alacritty

My main terminal is wezterm so it's configuration will be the most up-to-date.
There is an alacritty config file as well but it may be out of date.
