# Dotfiles

These dotfiles are designed to be managed by yadm.

## Shell profiles and RC files

The various profile and RC files are designed to be backward compatible with
sh (dash), bash, and zsh.

### Profile files

`.profile` contains the majority of login shell config
`.bash_profile` sources `.profile` and add bash-specific config
`.zprofile` sources `.profile` and add zsh-specific config

### RC files

`.shrc` contains the majority of interactive shell config
`.bashrc` sources `.shrc` and adds bash-specific config
`.zshrc` sources `.shrc` and add zsh-specific config

Note that `.shrc` is not loaded by dash (sh) by default. If using dash,
manually source `.shrc` by `source .shrc`.
