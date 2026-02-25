---
name: sprites
description: Create and preview HTML pages, sites, and web apps using Sprite sandboxes (sprites.dev). Use when the user asks to build a webpage, preview HTML, create a site, deploy a prototype, or serve any web content for live preview. Triggers include "preview this", "make a page", "create a site", "show me what this looks like", "deploy to sprite", or any request to build and view web content in a browser.
---

# Sprites Skill

Build HTML pages and web apps, deploy them to a Sprite sandbox, and give the user a live preview URL.

## Overview

Sprites are persistent, hardware-isolated Linux VMs (via sprites.dev / Fly.io). They run a web server on port 8080 and expose a public URL. This skill uses them as live preview environments.

## CLI Reference

```text
sprite create <name>        Create a new sprite
sprite use <name>           Set active sprite for current directory
sprite list                 List all sprites
sprite exec <cmd>           Run a command in the sprite
sprite exec -file src:dest  Upload a file then run a command
sprite url                  Show the sprite's public URL
sprite url update --auth public   Make URL publicly accessible
sprite checkpoint create    Snapshot current state
sprite restore <id>         Restore a checkpoint
sprite destroy <name>       Delete a sprite
```

## Workflow

### 1. Check for Existing Sprite

Before creating a new sprite, check if one already exists.

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
# Upload a single file and start the server
sprite exec -file ./index.html:/home/sprite/index.html bash -c 'cd /home/sprite && python3 -m http.server 8080'

# Upload multiple files
sprite exec \
  -file ./index.html:/home/sprite/index.html \
  -file ./style.css:/home/sprite/style.css \
  bash -c 'cd /home/sprite && python3 -m http.server 8080'
```

Alternatively, pipe content via `sprite exec bash -c 'cat > /path/to/file << ...'` if writing small files directly.

### 4. Start a Web Server

For static files, use Python's built-in server:

```bash
sprite exec bash -c 'cd /home/sprite && nohup python3 -m http.server 8080 > /dev/null 2>&1 &'
```

For dev servers (Vite, Next.js, etc.), install dependencies first:

```bash
sprite exec bash -c 'cd /home/sprite && npm install && npx vite --host 0.0.0.0 --port 8080'
```

The sprite routes all HTTP traffic to port 8080 automatically.

### 5. Make the URL Public

```bash
sprite url update --auth public
```

Then retrieve and share the URL:

```bash
sprite url
```

### 6. Iterate

When updating content, upload new files and the server picks up changes automatically (for static serving). No redeploy needed.

```bash
sprite exec -file ./index.html:/home/sprite/index.html echo 'updated'
```

For changes that require a server restart, kill and restart the process.

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

- Port 8080 is the only externally routed port
- Sprites persist across commands and sessions (files, installed packages, running processes survive)
- Sprites hibernate when idle and wake automatically on HTTP request
- Use `sprite destroy <name>` to clean up when done
- The sprite has Node.js, Python, Go, and Git pre-installed
- Always make the URL public (`--auth public`) before sharing the preview link with the user
- When the user says "preview" or "show me", always include the sprite URL in your response
