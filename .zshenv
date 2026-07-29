# ~/.zshenv
#
# Zsh environment configuration.
# Loaded for EVERY zsh invocation — login, interactive, scripts, and
# non-interactive remote commands (e.g. `ssh host command`), plus cron,
# LaunchAgents, and coding agents. This is the only zsh startup file
# that reaches them: ~/.zprofile is login-only, ~/.zshrc interactive-only.
#
# Step 2 of 8 in the zsh startup sequence, and the ONLY one of your own files
# that scripts, cron, LaunchAgents and coding agents ever run. Full table of
# which file loads when is in ~/.config/zsh/path.zsh.
#
# On macOS /etc/zprofile runs path_helper at step 3, AFTER this file, and
# reshuffles PATH so system directories come first. So sourcing path.zsh here
# guarantees PATH *presence* everywhere; ~/.zprofile re-sources it at step 4
# to restore *precedence*. Both are needed — see that file's header.
#
# This file is tracked by yadm and MUST NEVER CONTAIN A SECRET.
# Real secrets live in ~/.zshenv.local, which is deliberately untracked.
#
# See also: ~/.zprofile (login), ~/.zshrc (interactive), ~/.zshenv.local

# Keep PATH free of duplicates. MUST come before any PATH manipulation. It
# also makes re-sourcing path.zsh in ~/.zprofile a reorder instead of a
# duplication, which is what lets one file define PATH for both steps.
typeset -U path PATH

# PATH lives in ~/.config/zsh/path.zsh and is sourced from here AND from
# ~/.zprofile. Sourcing here is what puts these directories in front of
# scripts, cron, LaunchAgents and coding agents, none of which ever run
# ~/.zprofile. See that file's header for the full startup sequence.
[ -r "$HOME/.config/zsh/path.zsh" ] && source "$HOME/.config/zsh/path.zsh"

# Editor. Exported here rather than in ~/.zshrc so that scripts, git, cron
# and LaunchAgents inherit it too — not only interactive shells.
if (( $+commands[nvim] )); then
    export EDITOR=nvim
    export VISUAL=nvim
fi

# ---------------------------------------------------------------------------
# Machine-specific secrets
#
# ~/.zshenv.local is created per machine by hand and never synced. If it is
# missing, it is generated here with placeholders and the shell fails, so a
# machine can never run silently without its secrets. Placeholder values that
# were never filled in fail the same way.
#
# Non-interactive shells exit(1) — a hard failure for scripts, cron and
# LaunchAgents. Interactive shells report the error but keep running, so you
# still have a usable terminal in which to fix the file.
# ---------------------------------------------------------------------------

typeset -g ZSHENV_LOCAL=${HOME}/.zshenv.local
typeset -ga ZSHENV_REQUIRED=(OPENAI_API_KEY OLLAMA_API_KEY GOG_KEYRING_PASSWORD)

if [[ ! -r $ZSHENV_LOCAL ]]; then
  (
    umask 077
    {
      print '# ~/.zshenv.local — machine-specific secrets. NOT tracked by yadm.'
      print '#'
      print '# Replace every REPLACE_ME below with the real value, then open a'
      print '# new shell. Until then this machine will fail on startup.'
      print ''
      for _v in $ZSHENV_REQUIRED; print "export ${_v}=\"REPLACE_ME\""
    } > $ZSHENV_LOCAL
  )
  chmod 600 $ZSHENV_LOCAL 2>/dev/null
  print -u2 "FATAL: ~/.zshenv.local was missing on ${HOST}."
  print -u2 "       Created it with placeholders for: ${ZSHENV_REQUIRED}"
  print -u2 "       Fill in the real values, then open a new shell."
  [[ -o interactive ]] || exit 1
  return 1
fi

source $ZSHENV_LOCAL

typeset -a _zshenv_bad=()
for _v in $ZSHENV_REQUIRED; do
  if [[ -z ${(P)_v} || ${(P)_v} == *REPLACE_ME* ]]; then
    _zshenv_bad+=$_v
  fi
done
if (( $#_zshenv_bad )); then
  print -u2 "FATAL: ~/.zshenv.local is unset or still has placeholders on ${HOST}:"
  print -u2 "       ${_zshenv_bad}"
  print -u2 "       Fill in the real values in ~/.zshenv.local, then open a new shell."
  unset _v _zshenv_bad
  [[ -o interactive ]] || exit 1
  return 1
fi
unset _v _zshenv_bad
