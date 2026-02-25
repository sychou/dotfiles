---
name: markdown
description: Markdown formatting standards for all markdown files. Use when creating or editing any markdown document (.md files) to ensure consistent, clean formatting. Applies to READMEs, documentation, notes, skills, and any other markdown content.
---

# Markdown Formatting Standards

Apply these formatting rules when creating or editing any markdown file.

## General Rules

- Use blank lines around block objects (headers, code blocks, lists, blockquotes)
- Use YAML front matter for document metadata when appropriate
- Include a blank line after the closing `---` of front matter
- Always specify a language/type for code blocks (use `text` for plain text)
- End every file with a blank line

## What to Avoid

- Bold instead of headers for section titles
- Bold to highlight field names in bullet lists
- Horizontal rule lines (`---` as separators between sections)
- Tables unless explicitly requested or absolutely necessary
- Multiple top-level (`#`) headings in a single document
- Bare URLs or email addresses

## Headers

Headers must have a blank line both before and after them. This applies to all header levels (`#`, `##`, `###`, etc.).

Good:

```markdown
Some paragraph text.

## New Section

More text here.
```

Bad:

```markdown
Some paragraph text.
## New Section
More text here.
```

## Lists

Lists should be surrounded by blank lines.

Good:

```markdown
Introduction paragraph.

- Item one
- Item two
- Item three

Conclusion paragraph.
```

Bad:

```markdown
Introduction paragraph.
- Item one
- Item two
- Item three
Conclusion paragraph.
```

## URLs and Emails

Never use bare URLs or email addresses. Always wrap them.

Options:

- Angle brackets: `<https://example.com>` or `<email@example.com>`
- Link syntax: `[link text](https://example.com)`

Keep angle brackets even when applying other markup like strikethrough or bold.

Good:

- Visit <https://example.com> for more info
- Contact us at <support@example.com>
- See the [documentation](https://docs.example.com)
- ~~<old@example.com>~~ is deprecated, use <new@example.com>

Bad:

- Visit https://example.com for more info
- Contact us at support@example.com

## YAML Front Matter

When using front matter, format tags as a list:

```yaml
---
tags:
  - topic1
  - topic2
created: 2026-01-01
updated: 2026-01-01
---
```

Always include a blank line after the closing `---` before the first header.

## Code Blocks

Always specify a language or type:

- `markdown` for markdown examples
- `yaml` for YAML
- `json` for JSON
- `text` for plain text, emails, or other unformatted content
- Appropriate language identifier for code (js, python, bash, etc.)

Good:

````markdown
```python
def hello():
    print("Hello")
```
````

Bad:

````markdown
```
def hello():
    print("Hello")
```
````

## Tables

Avoid tables unless explicitly requested or truly necessary for the content. Convert tabular information to prose or bullet lists when possible.

When tables are necessary:

- Leave a space between the column separator and content
- Surround tables with blank lines

```markdown
| Column 1 | Column 2 |
| -------- | -------- |
| value 1  | value 2  |
```

## Document Structure

- Use a single top-level `#` heading per document
- Use `##` and lower for sections
- Prefer prose over excessive formatting
- Let the content hierarchy emerge from headers, not visual tricks
