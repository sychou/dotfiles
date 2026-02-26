---
name: sprites
description: Create and preview HTML pages, sites, and web apps using Sprite sandboxes (sprites.dev). Use when the user asks to build a webpage, preview HTML, create a site, deploy a prototype, or serve any web content for live preview. Triggers include "preview this", "make a page", "create a site", "show me what this looks like", "deploy to sprite", or any request to build and view web content in a browser.
---

# Sprites Skill

Build HTML pages and web apps, deploy them to a Sprite sandbox, and give the user a live preview URL.

## Overview

Sprites are persistent, hardware-isolated Linux VMs (via sprites.dev / Fly.io). They expose a public URL routed to a configurable port (default 8080). This skill uses them as live preview environments.

## CLI Reference (Host)

Commands run from the local machine:

```text
sprite create <name>              Create a new sprite
sprite use <name>                 Set active sprite for current directory
sprite list                       List all sprites
sprite exec <cmd>                 Run a command in the sprite
sprite exec -file src:dest <cmd>  Upload file(s) then run a command
sprite console                    Open interactive shell in the sprite
sprite url                        Show the sprite's public URL
sprite url update --auth public   Make URL publicly accessible
sprite proxy <port>               Forward a local port to the sprite
sprite checkpoint create          Snapshot current state
sprite checkpoint list            List checkpoints
sprite restore <id>               Restore a checkpoint
sprite destroy <name>             Delete a sprite
```

### `sprite exec` Flags

| Flag | Description |
| --- | --- |
| `-file src:dest` | Upload file before exec (repeatable) |
| `-dir <path>` | Working directory for the command |
| `-env KEY=val,...` | Environment variables |
| `-tty` | Allocate a pseudo-TTY |

## In-Sprite Tools (`sprite-env`)

These commands run **inside** the sprite (via `sprite exec`):

```text
sprite-env info                   Show sprite name, URL, version
sprite-env services list          List all services and their states
sprite-env services create <name> Create a persistent service
sprite-env services delete <name> Delete a service
sprite-env services start <name>  Start a stopped service
sprite-env services stop <name>   Stop a running service
sprite-env services restart <name> Restart a service
sprite-env services get <name>    Get a service's state
sprite-env checkpoints            Manage checkpoints from inside
```

### `sprite-env services create` Flags

| Flag | Description |
| --- | --- |
| `--cmd <command>` | Command to run (required, use full path) |
| `--args <a,b,...>` | Comma-separated arguments |
| `--env KEY=val,...` | Environment variables |
| `--dir <path>` | Working directory |
| `--http-port <port>` | Route HTTP traffic to this port (auto-starts on request) |
| `--needs <svc,...>` | Service dependencies |
| `--no-stream` | Don't tail logs after creation |
| `--duration <time>` | How long to stream logs (default 5s) |

**Only one service can have `--http-port` at a time.**

## Workflow

### 1. Check for Existing Sprite

```bash
sprite list
```

If an appropriate sprite exists, use it. If not, create one.

### 2. Create or Select a Sprite

```bash
sprite create <name>
sprite use <name>
```

Name sprites descriptively based on the project (e.g., `landing-page`, `dashboard-proto`).

### 3. Write Content Locally, Then Upload

Write HTML/CSS/JS files locally first using normal file tools, then upload to the sprite using the `-file` flag on `sprite exec`.

```bash
# Upload a single file
sprite exec -file ./index.html:/home/sprite/index.html echo 'uploaded'

# Upload multiple files
sprite exec \
  -file ./index.html:/home/sprite/index.html \
  -file ./style.css:/home/sprite/style.css \
  echo 'uploaded'
```

### 4. Start a Persistent Service

**Always use `sprite-env services` instead of background processes or `nohup`.** Services survive hibernation and auto-restart when the sprite wakes.

For static files:

```bash
sprite exec bash -c 'sprite-env services create web-server \
  --cmd /usr/bin/python3 --args "-m,http.server,8080" \
  --dir /home/sprite --http-port 8080 --no-stream'
```

For Node.js apps:

```bash
sprite exec bash -c 'sprite-env services create web-server \
  --cmd /usr/bin/node --args server.js \
  --dir /home/sprite --http-port 8080 --no-stream'
```

With `--http-port`, incoming HTTP requests auto-start the service — no manual restart needed after hibernation.

To check service status:

```bash
sprite exec bash -c 'sprite-env services list'
```

To restart after uploading new files (if the server doesn't hot-reload):

```bash
sprite exec bash -c 'sprite-env services restart web-server'
```

### 5. Make the URL Public

```bash
sprite url update --auth public
sprite url
```

Always share the URL with the user after deploying.

### 6. Iterate

Upload new files — static servers pick up changes automatically:

```bash
sprite exec -file ./index.html:/home/sprite/index.html echo 'updated'
```

If the server needs a restart:

```bash
sprite exec bash -c 'sprite-env services restart web-server'
```

### 7. Checkpoint (Optional)

Save the sprite's state before major changes:

```bash
sprite checkpoint create
```

Restore if needed:

```bash
sprite restore <checkpoint-id>
```

## Important Notes

- **Always use `sprite-env services`** for web servers — never `nohup` or `&` background processes, which die on hibernation
- The `--http-port` flag enables auto-start on incoming requests — the sprite wakes AND starts the service automatically
- Use full paths for `--cmd` (e.g., `/usr/bin/python3`, `/usr/bin/node`)
- Sprites hibernate when idle and wake automatically on HTTP request
- Files, packages, and services persist across sessions
- Node.js, Python, Go, and Git are pre-installed
- Use `sprite destroy <name>` to clean up when done
- Always make the URL public (`--auth public`) before sharing with the user
- When the user says "preview" or "show me", always include the sprite URL in your response
