---
name: gog
description: Google Workspace CLI for Gmail, Calendar, Drive, Contacts, Tasks, Sheets, Docs, and more. Use when the user asks to send/read email, check calendar, manage contacts, work with Drive files, Google Sheets, or any Google Workspace operation.
user_invocable: false
---

# gog - Google Workspace CLI

`gog` (v0.11.0) provides CLI access to Google Workspace: Gmail, Calendar, Drive, Contacts, Tasks, Sheets, Docs, Slides, Forms, and more.

## Accounts

Sean has two Google accounts:

| Account | Flag | Use |
|---------|------|-----|
| `choufam` | `-a choufam` | Personal — family, personal errands, non-work |
| `isomer` | `-a isomer` | Work — Isomer business, colleagues, customers |

**Default account is choufam.** Always pass `-a isomer` for work context.

When Sean doesn't specify, infer from context:
- Work meetings, Isomer business, colleagues, customers → `isomer`
- Family, personal errands, non-work items → `choufam`
- If ambiguous, ask.

The vault's People files have an `account:` field that maps to these accounts.

## Global Flags

| Flag | Description |
|------|-------------|
| `-a, --account` | Account to use (`choufam` or `isomer`) |
| `-j, --json` | JSON output (best for scripting/parsing) |
| `-p, --plain` | TSV output (no colors, stable for parsing) |
| `--results-only` | JSON mode: emit only primary result (drops pagination tokens) |
| `--select` | JSON mode: select specific fields (dot paths) |
| `-n, --dry-run` | Preview changes without executing |
| `-y, --force` | Skip confirmations |
| `--max` | Max results (available on most list/search commands) |
| `--page` | Pagination token for next page |
| `--all` / `--all-pages` | Fetch all pages |

## Gmail

```bash
# Search threads (uses Gmail query syntax)
gog gmail search "from:jane subject:meeting" -a isomer --max 5
gog gmail search "is:unread" -a choufam

# Read a message
gog gmail get <messageId> -a isomer

# Send email
gog gmail send -a isomer \
  --to "jane@example.com" \
  --subject "Follow up" \
  --body "Message text here"

# Send with attachment
gog gmail send -a isomer \
  --to "jane@example.com" \
  --subject "Report" \
  --body "See attached." \
  --attach report.pdf

# Reply to a thread
gog gmail send -a isomer \
  --thread-id <threadId> \
  --reply-all \
  --body "Thanks for the update."

# Send body from file
gog gmail send -a isomer \
  --to "jane@example.com" \
  --subject "Newsletter" \
  --body-file content.txt

# Drafts
gog gmail drafts list -a isomer
gog gmail drafts create -a isomer --to "jane@example.com" --subject "Draft" --body "..."

# Labels
gog gmail labels list -a isomer
```

## Calendar

```bash
# List today's events
gog cal events -a isomer --today

# List this week
gog cal events -a isomer --week

# List next 7 days
gog cal events -a isomer --days 7

# Date range
gog cal events -a isomer --from 2026-02-01 --to 2026-02-28

# All calendars
gog cal events -a choufam --today --all

# Search events
gog cal search "board meeting" -a isomer

# Create event
gog cal create primary -a isomer \
  --summary "Team Standup" \
  --from "2026-02-22T10:00:00" \
  --to "2026-02-22T10:30:00" \
  --attendees "jane@isomer.ai,tom@isomer.ai" \
  --with-meet

# RSVP
gog cal respond primary <eventId> -a isomer --status accepted

# Find conflicts
gog cal conflicts -a isomer --from 2026-02-22 --to 2026-02-28

# List calendars
gog cal calendars -a choufam
```

## Contacts

```bash
# Search contacts
gog contacts search "Jane Smith" -a choufam

# List contacts (paginated, max 100 per page)
gog contacts list -a choufam --max 500
gog contacts list -a choufam --max 500 --page <token>  # next page

# Get contact details
gog contacts get <resourceName> -a choufam

# Create contact
gog contacts create -a choufam --name "Jane Smith" --email "jane@example.com"

# Update contact
gog contacts update <resourceName> -a choufam --phone "555-1234"
```

**Note:** Contact lists are paginated (default 100, max 500 per page). Use `--page` with the token from the previous response to get subsequent pages. Always check for a `nextPageToken` in JSON output.

## Drive

```bash
# List files in root
gog drive ls -a isomer

# List files in folder
gog drive ls -a isomer --parent <folderId>

# Search files
gog drive search "quarterly report" -a isomer

# Download file
gog drive download <fileId> -a isomer

# Upload file
gog drive upload report.pdf -a isomer --parent <folderId>

# Get file metadata
gog drive get <fileId> -a isomer

# Share file
gog drive share <fileId> -a isomer --email "jane@example.com" --role reader
```

Aliases: `gog ls` = `gog drive ls`, `gog search` = `gog drive search`, `gog download` = `gog drive download`, `gog upload` = `gog drive upload`.

## Google Docs

```bash
# Read a doc as plain text
gog docs cat <docId> -a isomer

# Export doc
gog docs export <docId> -a isomer --format pdf

# Create doc
gog docs create "Meeting Notes" -a isomer

# Write/replace content
gog docs write <docId> "New content" -a isomer

# Insert text at position
gog docs insert <docId> "Inserted text" -a isomer --index 1

# Find and replace
gog docs find-replace <docId> "old text" "new text" -a isomer
```

## Google Sheets

```bash
# Read values
gog sheets get <spreadsheetId> "Sheet1!A1:D10" -a isomer

# Update values
gog sheets update <spreadsheetId> "Sheet1!A1" "value1" "value2" -a isomer

# Append row
gog sheets append <spreadsheetId> "Sheet1!A1" "val1" "val2" "val3" -a isomer

# Get metadata (sheet names, etc.)
gog sheets metadata <spreadsheetId> -a isomer

# Export as CSV
gog sheets export <spreadsheetId> -a isomer --format csv
```

## Tasks

```bash
# List task lists
gog tasks lists -a choufam

# List tasks in a list
gog tasks list <tasklistId> -a choufam

# Add a task
gog tasks add <tasklistId> -a choufam --title "Buy groceries" --due 2026-02-25

# Mark done
gog tasks done <tasklistId> <taskId> -a choufam

# Update a task
gog tasks update <tasklistId> <taskId> -a choufam --title "Updated title"
```

## Tips

- Use `-j --results-only` for clean JSON output when piping to `jq`.
- Use `-p` for stable TSV output when piping to `awk`/`cut`.
- Gmail search uses standard Gmail query syntax (`from:`, `to:`, `subject:`, `is:unread`, `after:`, `before:`, `has:attachment`, etc.).
- Calendar times accept RFC3339, date strings, or relative values (`today`, `tomorrow`, `monday`).
- Always use `--dry-run` before destructive operations if unsure.
