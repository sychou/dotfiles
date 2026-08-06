# Global Claude Code Instructions

## Additional CLI Tools Available

- bat (better cat)
- csvkit (in2csv, csvlook, csvgrep, etc.)
- eza (better ls)
- fd (better find)
- gh (GitHub CLI)
- gog (Google Workspace CLI — see `gog` skill for full reference)
- jq (JSON processor)
- msgvault (personal email archive search — see `sean-email-archive` skill for full reference)
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

Three corpora, three tools. Pick by what you're looking for — don't grep the vault by hand when qmd is indexed, and don't guess at history when the email archive has the actual record.

| Looking for | Use | Notes |
| ----------- | --- | ----- |
| Notes and journal | **qmd** | Indexed. `-c obsidian` is the vault; `-c catalytic` is the Catalytic archive. See the `qmd` skill. |
| Meeting transcripts (Granola) | **msgvault** | In the archive as `message_type = meeting_transcript`, synced nightly. NOT in qmd — the old `granola` collection was retired 2026-08-06. |
| Email — what was said, when, by whom | **msgvault** | Full history, 1993→present (~465K msgs), FTS + semantic. See the `sean-email-archive` skill. |
| `~/Desktop` documents (PDF/docx/xlsx…) | **fd** / **rg** | Not indexed anywhere. Target the relevant subdir; `poppler` for PDF text. |

Prefer `qmd query` with hand-written `intent:`/`lex:`/`vec:` fields over a bare search string — you know the domain vocabulary and the aliases below, the expansion model doesn't.

**msgvault** answers questions the notes can't: first contact with a person, how a relationship actually developed, what a company was called at the time. Use `--mode hybrid` for conceptual questions and `--mode fts` when you know the exact term.

The archive is **complete from 1993 to the present** (~465K messages) and also holds **every Granola meeting** (`message_type = meeting_transcript`, ~1,600, synced nightly at 05:15 on wells). The old 2009–2026 gap is closed. Meetings are reachable by FTS and filters; semantic search *scoped to meetings* currently hits an upstream KNN bug, so drop the scope for conceptual meeting questions.

The archive lives on **wells** and is reached over the tailnet — lem has a `[remote]` config pointing at `wells:58080`, so `msgvault` works from either machine.

### Entity aliases

Names that changed over time — needed to search any of the three corpora well, since old material uses the old name:

- **Fieldglass** — earlier **b2bpeople** (and `b2bpeople.com` addresses); "VMS" / "vendor management system" is the category
- **Catalytic** — earlier **Pushbot**; "workflow automation", "no-code", "process automation"
- **Isomer** — earlier **9root**; "insurance automation", "AI digital worker"
- Sean's own email spans ~35 addresses across eras; the `sean-email-archive` skill has the canonical_id and era map

## Rules

- Use `trash` instead of `rm` to delete files (sends to macOS Trash)
- Always quote file and directory names in shell commands (paths often contain spaces and bracketed tags like `[CLOSED]`).

## Working Style

- Be direct, concise, and proactive — prefer directness over verbosity.
- Default to reading/searching before modifying anything.
- When unsure, ask rather than guess.
