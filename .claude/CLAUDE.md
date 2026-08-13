# Global Claude Code Instructions

## Additional CLI Tools Available

- bat (better cat)
- csvkit (in2csv, csvlook, csvgrep, etc.)
- eza (better ls)
- fd (better find)
- gh (GitHub CLI)
- gog (Google Workspace CLI — see `gog` skill for full reference)
- jq (JSON processor)
- msgvault (email/meeting/calendar archive search — see `pkm` skill for routing and corpus facts)
- poppler (pdftotext and other PDF tools)
- qmd (local markdown note search — see `qmd` skill for full reference)
- ripgrep / rg (better grep)
- trash (rm replacement)
- uv (Python package manager)
- yadm (dotfile manager)
- yq (YAML processor)

## File Locations & Personal Knowledge

Sean's files live across two first-class roots — search both (and the relevant subdir) when looking for a file or topic, not just the vault:

- **`~/Desktop`** — the primary store for everything that isn't a note: downloads, documents, statements, contracts, work files, media. It's structured, not a dumping ground:
  - `PROJECTS/` — active work (Isomer briefs/decks/code repos, personal projects)
  - `CHOUFAM/` — household records: Finance, Insurance, Investments, Legal, Real Estate, Vehicles, Family, Reports (has its own `CLAUDE.md`)
  - `LIBRARY/` — reference by topic (AI, Isomer, Insurance Industry, Programming, Lit and Fiction, Greenhouse, Homestead, …)
  - `ARCHIVES/` — historical records (Taxes, Receipts, Loans, Career, Presentations, …)
  - `INBOX/` — landing zone for new files; process to a home within a few days
- **`~/Vaults/Main`** — the Obsidian vault: Sean's personal knowledge base (PKM) of notes — daily journal, people, projects, reference, writing. Has its own `CLAUDE.md`; read it when working in the vault.

### How to search

**Load the `pkm` skill before searching any of Sean's data** — notes, journal, email, meetings, calendar, or documents. It routes each question to the right tool and corpus (qmd for the Main vault and Catalytic archive; msgvault for email 1993→present, Granola meetings, and Google Calendar; fd/rg for `~/Desktop`), carries the entity aliases old material needs (Fieldglass←b2bpeople, Catalytic←Pushbot, Isomer←9root) and the archive identity/coverage facts, and hands off to the `qmd` and `msgvault-*` skills for CLI depth. Don't grep the vault by hand when qmd is indexed, and don't guess at history when the archive has the record.

## Rules

- Use `trash` instead of `rm` to delete files (sends to macOS Trash)
- Always quote file and directory names in shell commands (paths often contain spaces and bracketed tags like `[CLOSED]`).
- Don't guess CLI command syntax — check `--help` (or the man page) before writing commands for a tool or subcommand you haven't verified, especially when giving Sean commands to run himself.

## tmux Panes

If running inside tmux (check `$TMUX`), **load the `tmux` skill before running any slow or watchable CLI command** — it puts the work in its own pane, launched next to this session's pane, so Sean can watch it progress. This is his default preference for any tmux session; the skill carries the pane-targeting rules that make it safe.

## Working Style

- Be direct, concise, and proactive — prefer directness over verbosity.
- Default to reading/searching before modifying anything.
- When unsure, ask rather than guess.
