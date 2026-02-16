# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This is a **template repository** for deploying AI agent configuration (rules, skills, and ignore files) to other projects. It contains reusable Cursor rules, skills, and a deployment script.

## Commands

### Deploy Template to a New Project
```bash
./deploy.sh <destination_directory>
./deploy.sh --force /path/to/project    # Overwrite existing files
./deploy.sh --no-git ~/projects/new      # Skip git init
```

## Architecture

### Directory Structure
```
.cursor/
├── rules/       # .mdc files with AI behavior rules
├── skills/      # Reusable skill modules (SKILL.md)
└── README.md    # Skill/rule documentation
```

### Rule Categories (`.cursor/rules/`)
Rules use `.mdc` format with YAML frontmatter (`globs`, `alwaysApply`, `description`).

| Category | Files | Purpose |
|----------|-------|---------|
| **Principles** | `principles-*.mdc` | Core behaviors: critical reasoning, discovery-first, testing, security, error analysis, git etiquette |
| **Optimization** | `optimization-*.mdc` | Token/performance efficiency for iOS and data engineering |
| **Standards** | `standards-*.mdc` | Coding standards for Swift and Python/SQL |
| **Expert Personas** | `expert-*.mdc` | Domain-specific personas (iOS architect, data engineer) |
| **Housekeeping** | `housekeeping-*.mdc` | Maintenance of ignore files |

### Skills (`.cursor/skills/`)
Three skill modules available:
- `api-design/` - REST/GraphQL contract design
- `ui-design-expert/` - Cross-platform UI/UX patterns
- `web-frontend-architecture/` - React/Next.js architecture

### Ignore Files
`.cursorignore` and `.geminiignore` are kept in sync. They exclude:
- Build artifacts (DerivedData, dist, build)
- Large data files (CSV, Parquet, SQLite)
- Python environments and caches
- IDE metadata

## Key Principles from Rules

These rules apply to projects where this template is deployed:

1. **Discovery First**: Search existing code before writing new code. Reuse over rewrite.
2. **Critical Reasoning**: Challenge flawed approaches. Prioritize long-term codebase health over immediate agreement.
3. **Minimal Diffs**: Make the smallest possible code change. Avoid refactoring unrelated code.
4. **Systematic Error Analysis**: When failures occur, state evidence → root cause → proposal. No trial-and-error.
5. **Dependency Control**: Ask permission before adding new dependencies. Prefer built-in language features.
6. **Swift Concurrency (iOS)**: Use `@MainActor` for UI, `@Observable` over `ObservableObject`, `async/await` over GCD.
7. **Data Engineering**: Uppercase SQL keywords, explicit JOINs, structured logging (no `print()`), type hints on all functions.

## PR Review (BUGBOT.md)

Contains PR review formatting standards with risk indicators (🔴🟠🟢), blockers, and concerns. Used for automated PR reviews with specific rules for Swift concurrency, security-sensitive areas, test coverage, and data engineering patterns.
