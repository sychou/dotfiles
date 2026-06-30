# Global Claude Code Instructions

## Additional CLI Tools Available

- bat (better cat)
- csvkit (in2csv, csvlook, csvgrep, etc.)
- eza (better ls)
- fd (better find)
- gh (GitHub CLI)
- gog (Google Workspace CLI — see `gog` skill for full reference)
- muesli (Granola meeting transcripts — see `muesli` skill for full reference)
- jq (JSON processor)
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

**qmd** is the unified search across the *markdown* notes + meetings (two indexed collections):

- `obsidian` — the entire Obsidian vault (personal PKM)
- `granola` — Granola transcripts (Isomer meeting notes)
- Scope to one with `qmd search "query" -c obsidian` (or `-c granola`); see the `qmd` skill.

qmd indexes only the markdown above — for `~/Desktop` documents (PDF/docx/xlsx/etc.) search the filesystem directly with `fd`/`rg` (and `poppler` for PDF text).

## Rules

- Use `trash` instead of `rm` to delete files (sends to macOS Trash)
- Always quote file and directory names in shell commands (paths often contain spaces and bracketed tags like `[CLOSED]`).

## Working Style

- Be direct, concise, and proactive — prefer directness over verbosity.
- Default to reading/searching before modifying anything.
- When unsure, ask rather than guess.
