# Cursor Configuration

This directory contains configuration files for Cursor AI assistance.

## Directory Structure

- `rules/` - Contains rule files (`.mdc` format) that provide persistent context to the AI agent

## Rules Directory

Rules are `.mdc` files with YAML frontmatter that help guide the AI agent's behavior:

- **Always-apply rules**: Apply to every conversation (set `alwaysApply: true`)
- **File-specific rules**: Apply when working with specific file patterns (use `globs` field)

### Example Rule Structure

```markdown
---
description: Brief description of what this rule does
globs: **/*.ts  # File pattern for file-specific rules
alwaysApply: false  # Set to true if rule should always apply
---

# Rule Title

Your rule content here...
```

### Creating Rules

You can create rules by:
1. Manually creating `.mdc` files in the `rules/` directory
2. Asking the AI agent to create rules for you
3. Using the create-rule skill

For more information, ask the AI agent about creating Cursor rules.
