# Dotfiles

These dotfiles are managed by [yadm](https://yadm.io/).

## Repository access

The repo went private on 2026-08-05, so every machine has to prove who it is to
pull. There is no single method, because the machines differ in what they can
do unattended:

| Host | Method | Why |
| ---- | ------ | --- |
| `lem` | HTTPS + `gh` credential helper | 1Password requires interactive approval to *sign*, so SSH cannot run unattended here |
| `verne` | SSH + 1Password agent | its agent signs without prompting |
| `wells` | SSH + read-only deploy key | headless, no 1Password, and `gh` tokens expire silently |
| `tiptree` | SSH + read-only deploy key | not Sean's GitHub account |

Deploy keys are the right tool for the last two: scoped to this one repo,
read-only so the machine can never push, revocable without touching anyone's
account, and tied to the machine rather than to a person.

**The failure mode is silence.** `yadm fetch -q` swallows an auth error, so a
machine that cannot authenticate reports "0 commits behind" while drifting.
`common_repo_access` in the bootstrap tests this up front and prints the remedy.

Per-machine key selection lives in `~/.ssh/config.local`, which the tracked
`~/.ssh/config` includes **first** — ssh takes the first value it finds for each
keyword, so a local override wins over the shared `github.com` block. That block
points at a 1Password-held key that exists only on Sean's own machines.

## Machines

Every machine gets the **same tracked configs and the same core CLI toolchain**.
Only two things vary.

| Host | OS | Role | GUI apps |
| ---- | -- | ---- | -------- |
| `verne` | macOS | daily driver + dev | all 29 |
| `lem` | macOS | daily driver + dev; ollama served to the tailnet, exit node | 28 (no `trezor-suite`) |
| `tiptree` | macOS | Sheldon's box; OpenClaw (by hand), obsidian-headless syncing the workspace as the "Sheldon" vault | 10 |
| `wells` | Ubuntu | msgvault server + Gmail sync, nightly archive pipeline, exit node | opt-in |


**1. GUI apps.** Always installed on macOS. On Linux it is a per-machine choice:

```sh
yadm config local.gui true
```

**2. Hostname.** Each machine's one-off role is keyed on `hostname -s` rather
than on a class, because no two of these are alike enough to share a category.
`lem` serves ollama to the tailnet from its own LaunchAgent — Homebrew's
service cannot, since a plist that declares `EnvironmentVariables` receives
exactly that dict and `launchctl setenv OLLAMA_HOST` never reaches the process.
`wells` runs the msgvault server and embeds against `lem`; `tiptree` gets
OpenClaw by hand.

**OS detection is independent of hostname.** An unrecognised machine still
takes the correct macOS or Ubuntu path and gets the full core toolchain — only
the per-machine extras are skipped, and the bootstrap says so rather than
finishing silently. On macOS it also installs the full base cask list, since
exclusions are opt-in per host.

> **The bootstrap never uninstalls.** The per-machine cask lists control what
> gets *installed*, not what gets removed. A machine that already has extra apps
> keeps them until you `brew uninstall --cask` them yourself.

## Nightly archive pipeline (`wells`)

`bin/msgvault-nightly` runs one ordered pass and reports once:

```text
02:00 / 03:00 / 04:00   mail sync per account   (msgvault daemon, config.toml)
06:00                   msgvault-nightly        (cron)
                          sync -> calendar -> Granola -> backup snapshot
07:00                   repo pull to lem        (launchd on lem)
```

It replaced three separate cron entries sequenced only by guessed times — each
scheduled late enough that the previous had *probably* finished. That held until
a long sync during the Gmail backfill would have run straight through the next
job's window.

The mail syncs stay in `config.toml` deliberately: email still syncs if the
script never runs, and the script's `sync` step is then a cheap incremental
catch-up before the snapshot is taken.

A failed **sync** does not abort the run — a stale-but-complete archive is still
worth snapshotting — but the result reports as `degraded` and names the failed
step, so a bad night is never indistinguishable from a good one. A failed
**backup** is fatal.

Results publish over MQTT via `bin/report-mqtt` as retained JSON on
`homelab/<host>/<job>/status`, so the last known state of every job is one
subscribe away rather than five logs across two machines and two timezones.
Reporting is fire-and-forget: an unreachable broker warns and still exits 0,
because it must never fail the backup it reports on.

Backups live on wells' **internal** NVMe while the archive sits on the external
USB disk, so a failure of either device does not take both. lem holds the
offsite copy in the other house.

## Setting Up a New Mac

Remove all apps from Dock (personal preference).

Install NextDNS from App Store and set up with custom ID from https://my.nextdns.io.

You need a terminal before you have Homebrew. Either use the built-in
Terminal.app for the next few steps, or download Ghostty from
https://ghostty.org/ and start it.

> If you install Ghostty by hand, adopt it into Homebrew afterwards rather than
> letting the bootstrap install a second copy:
> `brew install --cask --adopt ghostty`. The bootstrap lists `ghostty` as a
> cask, so without `--adopt` you end up with an unmanaged app that brew will
> never update.

Install Homebrew, then add it to the current shell's `PATH` (the installer does
**not** do this for you on Apple Silicon — without it the next steps can't find
`brew`).

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Install yadm.

```sh
brew install yadm
```

Clone my dotfiles repo and run the bootstrap. The repo is public, so cloning
needs no authentication.

```sh
yadm clone https://github.com/sychou/dotfiles
```

The bootstrap script handles everything else: Homebrew packages, cask apps,
fonts, mise runtimes, Python tools, and Claude Code. (The
bootstrap itself re-runs the brew `shellenv` step internally, so it works even
on a fresh machine.)

It picks the cask list from `hostname -s`, so **set the hostname before running
it** — otherwise the machine gets the full base list:

```sh
sudo scutil --set LocalHostName tiptree
```

### GitHub & Commit Signing

Cloning is public, but **pushing changes back requires authenticating as
`sychou`** and commits are SSH-signed via 1Password. Set this up before making
edits:

1. Start 1Password, sign in, and enable the SSH agent:
   **Settings → Developer → "Use the SSH agent"**. This is what serves both your
   SSH auth keys and the commit-signing key (`gpg.format = ssh`,
   `op-ssh-sign`). It's a per-machine toggle and is **not** restored by yadm.
2. Authenticate GitHub as `sychou` (not any other account) and wire it into git:

   ```sh
   gh auth login --hostname github.com --git-protocol https --web
   gh auth setup-git
   ```

3. Confirm the signing key is reachable: `ssh-add -l` should list your key, and a
   test commit should show `Good "git" signature`. If signing fails with
   "No SSH private key found", the key isn't in your 1Password Personal/Private
   vault or the agent is off.

If a commit dies with `1Password: failed to fill whole buffer` /
`fatal: failed to write commit object`, 1Password is locked or the integration
prompt went unanswered. Unlock it and retry. To get one commit through without
signing, use `git -c commit.gpgsign=false commit` — this leaves your global
config alone, but the commit will show as unverified on GitHub.

### Configuration

- Start 1Password and login
- Start Chrome
    - Change default browser
    - Set up sync
    - Set up Kagi as default search
- Start Obsidian
    - Set up vaults via Sync
    - Place in `~/Vaults` (it will automatically create a subdirectory named after the vault)
- Index notes in qmd (see [qmd — Local Note Search](#qmd--local-note-search))
- Pull any local models you rely on — these are machine-specific and the
  bootstrap deliberately does not install them:
  `ollama pull nomic-embed-text` (embeddings), plus whatever chat model you want
- System Settings
    - Automatically hide and show the Dock
    - Set up Internet Accounts
    - Enable iCloud > iCloud Drive > Desktop & Document Folders
- SSH keys and the commit-signing key come from 1Password's SSH agent (see
  "GitHub & Commit Signing" above). `~/.ssh/config` **is** tracked and points
  `IdentityAgent` at the 1Password agent socket, so terminal SSH routes through
  1Password automatically once the agent is enabled — no manual step needed
- Restore any other `~/.ssh` files / secrets not held in 1Password

## Setting Up an Ubuntu Box

Same repo, same bootstrap. `yadm` is in apt, so:

```sh
sudo apt update && sudo apt install -y yadm
yadm clone https://github.com/sychou/dotfiles
yadm config local.gui true      # only if this box has a display
~/.config/yadm/bootstrap
```

The bootstrap detects Linux and takes the apt path instead of Homebrew. See
[Ubuntu package sources](#ubuntu-package-sources) for what comes from where.

### Either platform: secrets first

**Before the first shell will work on any machine**, create `~/.zshenv.local`
with that machine's secrets — see [Secrets](#secrets) below. Without it every
new shell fails loudly, by design.

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
.config/zsh/path.zsh
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
.zshenv
.zshrc
README.md
bin/fzf-preview.sh
```

## zsh

Four files are tracked. Which ones a given shell runs depends on whether it is
a *login* shell, an *interactive* shell, both, or neither.

| File | Runs for | Holds |
| ---- | -------- | ----- |
| `.zshenv` | **every** zsh, no exceptions | `typeset -U path`, sources `path.zsh`, `EDITOR`, sources secrets from `~/.zshenv.local` |
| `.config/zsh/path.zsh` | not run directly — sourced by `.zshenv` and `.zprofile` | the single definition of `PATH` |
| `.zprofile` | login shells only | re-sources `path.zsh`, runs Homebrew `shellenv` |
| `.zshrc` | interactive shells only | prompt, aliases, functions, vi-mode key bindings, completions, history, `mise activate` |

### Startup sequence on macOS

Files run top to bottom. A shell only runs the rows whose "runs for" column
matches it. Note that the `/etc/*` system files are interleaved with your own,
which is where the surprise below comes from.

| # | File | Runs for | Notes |
| - | ---- | -------- | ----- |
| 1 | `/etc/zshenv` | every zsh, no exceptions | usually absent |
| 2 | `~/.zshenv` | every zsh, no exceptions | **sources `path.zsh`** |
| 3 | `/etc/zprofile` | login shells only | **runs `path_helper`** |
| 4 | `~/.zprofile` | login shells only | **sources `path.zsh`** |
| 5 | `/etc/zshrc` | interactive shells only | |
| 6 | `~/.zshrc` | interactive shells only | aliases, prompt, mise |
| 7 | `/etc/zlogin` | login shells only | |
| 8 | `~/.zlogin` | login shells only | not used here |

On exit: `~/.zlogout`, then `/etc/zlogout` (login shells only).

What counts as what:

| Invocation | Kind | Runs |
| ---------- | ---- | ---- |
| Terminal tab/window | login + interactive | 1,2,3,4,5,6,7,8 |
| `zsh` typed at a prompt | interactive | 1,2,5,6 |
| `./script.zsh`, cron, LaunchAgent, `ssh host cmd`, coding agents (Claude Code) | neither | **1,2 only** |

That last row is the one that matters. `~/.zshenv` is the only file of your own
that automation ever runs.

### Why `path.zsh` is sourced twice

Two different questions have two different right answers:

**"Is this directory on `PATH` at all?"** Only `~/.zshenv` (step 2) reaches
scripts, cron, LaunchAgents and agents — `~/.zprofile` never runs for them. Miss
this and `uv`-installed tools in `~/.local/bin` are invisible to any automation
while working fine when you test by hand. Ask me how I know.

**"In what order?"** Only `~/.zprofile` (step 4) runs *after* `path_helper`. At
step 3 macOS rebuilds `PATH` from `/etc/paths` and `/etc/paths.d`, putting system
directories first and appending whatever you had set. So anything step 2 puts up
front gets demoted. Measured, with only `.zshenv` setting it:

```
 1  /usr/local/bin
 3  /usr/bin
11  /opt/homebrew/bin     <- demoted, so Apple git beats Homebrew git
```

Sourcing at step 2 answers the first question, at step 4 the second.

The second pass is a **reorder, not a duplication**, because `~/.zshenv` sets
`typeset -U path PATH` before sourcing. With the unique flag set, prepending an
entry that already exists promotes it to the front:

```
before: /usr/bin:/bin:/opt/homebrew/bin
after : /opt/homebrew/bin:/usr/bin:/bin
```

### Editing `path.zsh`

Entries are prepended, so the list reads **lowest priority first** and the final
`PATH` comes out in reverse of the order in the file. Add new entries at the
bottom for high priority, at the top for low.

Deliberately **not** in `path.zsh`:

- **`brew shellenv`** — stays in `~/.zprofile`. It forks a subprocess and also
  sets `MANPATH`/`INFOPATH`/`HOMEBREW_PREFIX`; worth it once per login, not on
  every `zsh -c`. The bare `bin`/`sbin` entries are all a script actually needs.
- **`mise activate`** — stays in `~/.zshrc`. Moving it would slow every shell. If
  cron ever needs mise tools, add the shim directory to `path.zsh` instead.

Because mise's shims are prepended in `.zshrc`, mise-managed runtimes win over
Homebrew ones. That is why `node` resolves to mise's copy even though Homebrew
also has one installed as an `opencode` dependency.

### Secrets

`~/.zshenv.local` holds this machine's real secrets. It is **never tracked** —
`.config/git/ignore` carries an anchored `/.zshenv.local` rule so it cannot be
staged by accident.

`~/.zshenv` sources it and hard-fails if it is missing or still contains
placeholders. Non-interactive shells `exit 1` (a hard failure for scripts, cron
and LaunchAgents); interactive shells print the error but keep running so you
have a usable terminal in which to fix it. On a new machine `~/.zshenv`
generates the file with `REPLACE_ME` placeholders on first run, mode 600, and
tells you what to fill in.

Currently required:

```sh
export OPENAI_API_KEY="..."
export OLLAMA_API_KEY="..."
export GOG_KEYRING_PASSWORD="..."
```

To add another, append it to the `ZSHENV_REQUIRED` array in `~/.zshenv` so a
machine missing it fails fast instead of silently misbehaving.

## Installed Packages

**Every machine gets the same CLI toolchain**, regardless of role. On macOS it
comes from Homebrew; on Ubuntu the same tools come from four different places —
see [Ubuntu package sources](#ubuntu-package-sources) below.

Not installed on Ubuntu: `lazygit` and `flyctl` (Mac-only by choice), plus
`ffmpeg`, `lf`, `mlx`, `mole`, `poppler` and `temporal` (Mac-only in practice —
`mlx` is Apple-silicon and `mole` is a macOS cleanup app).

- bat, better cat
- eza, better ls
- fd, better find
- ffmpeg, audio/video transcoding
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
- mise, runtime version manager
- mlx, Apple ML framework
- mole, port forwarding / tunnels
- mosh, better ssh
- nerdfetch, improved neofetch
- neovim, improved vim
- ntfy, push notifications from the shell
- ollama, local LLM runner
- opencode, terminal coding agent
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
- yazi, terminal file manager (TUI)
- yq, YAML processor

### Fonts (Cask)

- FiraCode Nerd Font
- JetBrains Mono
- JetBrains Mono Nerd Font

### GUI Apps (Cask)

One base list of 29, with small per-machine exclusions. Adding an app means
editing one array in the bootstrap; a machine opts out by name.

**Base list** — what `verne` gets:

1Password, 1Password CLI, Bambu Studio, Boop, ChatGPT, Claude, CleanShot,
Discord, Docker Desktop, Ghostty, Google Chrome, Granola, HandBrake,
Logi Options+, Microsoft Teams, MonitorControl, Obsidian, Signal, Slack,
Spotify, Tailscale, Telegram, Trezor Suite, Visual Studio Code, VLC, Webex,
WhatsApp, Wispr Flow, Zoom

**`lem`** — base minus `trezor-suite` (28).

**`tiptree`** — 11. Sheldon's box, so OpenClaw is the assistant there and the
other AI desktop apps go, along with personal comms, media and hardware
utilities:

> 1Password · 1Password CLI · CleanShot · Docker Desktop · Ghostty ·
> Google Chrome · MonitorControl · Obsidian · Slack · Tailscale ·
> Visual Studio Code

Excluded on `tiptree`: Bambu Studio, Boop, ChatGPT, Claude, Discord, Granola,
HandBrake, Logi Options+, Microsoft Teams, Obsidian, Signal, Spotify, Telegram,
Trezor Suite, VLC, Webex, WhatsApp, Wispr Flow, Zoom.

Obsidian is excluded in favour of `obsidian-headless`: nobody sits at that
machine, it only needs to push the OpenClaw workspace to Sync.

**`wells`** — no casks; Ubuntu. If given a desktop (`yadm config local.gui
true`) it gets `ubuntu-desktop-minimal` and `vlc` from apt, and the rest —
1Password, Chrome, Obsidian, VS Code, Ghostty — install from vendor `.deb`s.

### Mac App Store Only

Not available via Homebrew — install by hand:

NextDNS, Paprika Recipe Manager 3, Pixelmator Pro, Obsidian Web Clipper (Safari extension)

### Runtimes (via mise)

Set globally by the bootstrap: python 3.12, node, bun, go, pnpm.

### Python Tools (via uv)

- tldr, better man pages
- csvkit, CSV toolkit (in2csv, csvlook, csvgrep, etc.)

### Global npm Tools (via mise node)

Not on Homebrew, so installed as global npm packages after mise sets up node:

- qmd, local markdown search engine (see [qmd](#qmd--local-note-search))

> **Granola meetings are not here any more.** muesli was retired on 2026-08-06.
> Meetings now sync into msgvault on `wells` via Granola's official API
> (nightly, 05:15) and are searched with `msgvault`, not `qmd`. The `granola`
> collection no longer exists.

### Built from Source

- **Claude Code** — installed via `curl -fsSL https://claude.ai/install.sh | bash`,
  landing in `~/.local/bin/claude`.

  On Ubuntu, `rustup` is not installed — nothing there needs `cargo` now that
  `tree-sitter` comes as a release binary. Add it if you want `cargo install`
  on that box.

## Ubuntu package sources

The same toolchain, but apt only has part of it. Four patterns, in dependency
order — `ubuntu_apt` runs first because it brings `curl`, `jq`, `gnupg` and
`unzip`, which the rest depend on.

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

Two things to know about the release downloads:

- They resolve `releases/latest` through the public GitHub API rather than
  `gh release download`, because `gh` needs an authenticated session that a
  fresh box does not have.
- The asset patterns assume **x86_64**. Naming is inconsistent across those
  projects (`linux_amd64`, `linux_x86_64`, `x86_64-unknown-linux-gnu`), so an
  arm64 box needs each one checked individually.

**Docker** installs from the official `docker-ce` repo on every Linux machine —
not Ubuntu's `docker.io` (which lags) and not the snap (whose confinement causes
volume-permission surprises with bind mounts).

`tree-sitter-cli` is not optional: `init.lua` pins nvim-treesitter to its `main`
branch, which requires it at 0.26.1+ and specifically says to install it from a
package manager rather than npm. apt's is too old, hence the release binary.

## qmd — Local Note Search

[qmd](https://github.com/tobi/qmd) is a local, offline search engine for markdown
(BM25 + vector + LLM re-ranking). The bootstrap installs the CLI and its Claude
Code skill:

```sh
npm install -g @tobilu/qmd
qmd skill install --global --yes -f   # skill into ~/.agents/skills/qmd (+ ~/.claude symlink)
```

First run downloads ~2GB of models into `~/.cache/qmd/models/` (one time, offline
thereafter).

### Index notes

After install, add the note directories as collections and build the index. This
is a manual post-install step (the bootstrap only prints a reminder):

```sh
qmd collection add ~/Vaults/Main --name obsidian   # Obsidian vault
qmd update                                        # index files
qmd embed                                         # generate embeddings
```

**The collection names matter.** `~/.claude/CLAUDE.md`, the vault's own
`CLAUDE.md`, and the qmd skill all reference `-c obsidian` by name. Name it
anything else and those documented commands fail with `Collection not found`.

Naming convention: bare **`obsidian`** always means the Main vault. If a second
vault is ever indexed, it takes a suffix (`obsidian-work`, etc.) and `obsidian`
stays pointed at Main — so nothing already written has to be revised.

Verify and search:

```sh
qmd collection list
qmd query "what did we decide about X"
```

Re-run `qmd update && qmd embed` after notes change. Scope searches to a
collection with `-c obsidian`.

### Optional: MCP server

For faster, persistent access from Claude (keeps models warm across queries),
run qmd as an HTTP MCP daemon:

```sh
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

**No plugin manager.** The config is plain tmux (3.6) with the status bar styled
inline — tpm was dropped, and the bootstrap no longer clones it. The previous
tpm-based config is kept at `~/.tmux.conf.bak` if you ever want to look back.

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

Machine-specific state — local LLM models, API keys, app logins — stays out of
the repo on purpose. The bootstrap gets a machine to the point where those can
be added, and no further.
