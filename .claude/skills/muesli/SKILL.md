---
name: muesli
description: Search and retrieve Granola meeting transcripts using the muesli CLI. Use when the user asks about past meetings, wants to find what was discussed, look up meeting details, or reference meeting transcripts.
user_invocable: false
---

# Muesli - Granola Meeting Transcript CLI

Muesli syncs and searches Sean's Granola meeting transcripts locally. 420+ transcripts dating back to May 2025, covering Isomer customer calls, team standups, investor meetings, board meetings, and personal meetings.

## Data Location

- Transcripts: `~/.local/share/muesli/transcripts/`
- Summaries: `~/.local/share/muesli/summaries/`
- Index: `~/.local/share/muesli/index/`

## Commands

### Sync transcripts from Granola

```bash
muesli sync              # Download new/updated transcripts
muesli sync --reindex    # Reindex all without re-downloading
```

Auth tokens are auto-detected from the Granola app on macOS.

### Search transcripts

```bash
muesli search "quarterly planning"              # Full-text BM25 search
muesli search --semantic "team collaboration"    # Meaning-based semantic search
muesli search "isomer" -n 5                      # Limit results
```

Output format: numbered list with title, date, and file path.

### List all transcripts

```bash
muesli list
```

Output format: tab-separated `doc_id`, `date`, `title`.

### Read a transcript

Transcripts are markdown files. Read them directly:

```bash
# Use the file path from search results
cat ~/.local/share/muesli/transcripts/2026-01-16_isomer-helix.md
```

### Summarize a transcript

```bash
muesli summarize <DOC_ID>          # Print summary to stdout
muesli summarize <DOC_ID> --save   # Save to summaries directory
```

Requires an OpenAI API key (`muesli set-api-key`).

## Transcript Format

Transcripts are markdown with YAML frontmatter:

```yaml
---
doc_id: uuid
source: granola
created_at: ISO-8601 timestamp
title: Meeting Title
participants: []
duration_seconds: null
labels: []
generator: muesli 1.0
---
```

Body contains timestamped speaker turns: `**Speaker (HH:MM:SS):** text`

Note: Speaker names are often generic ("Speaker") rather than identified by name.

## Usage Patterns

### Find what was discussed in a meeting

```bash
muesli search "MSIG" -n 5        # Find MSIG-related meetings
# Then read the transcript file from the results
```

### Find meetings in a date range

```bash
muesli list | grep "2026-01"     # All January 2026 meetings
```

### Cross-reference with vault

Meeting transcripts live outside the vault in `~/.local/share/muesli/`. To connect a transcript to a vault meeting note, search muesli for the meeting and reference the transcript content when creating or updating notes in `Daily/`.
