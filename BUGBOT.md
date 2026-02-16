# PR Review Standards

Review every pull request and format the response for rapid scanning by a busy maintainer.
Follow the structure below strictly.

---

## Review Format

### 🔴🟠🟢 Risk Assessment

Begin every review with one of the following top-level risk indicators:

- 🔴 **HIGH** — Blockers found. Do **not** merge until resolved.
- 🟠 **MEDIUM** — Concerns that should be addressed or explicitly accepted before merge.
- 🟢 **LOW** — Clean PR. Safe to merge after standard review.

Then provide supporting detail:

**Complexity:** [Simple | Moderate | Complex | Very Complex]
**Blast Radius:** [Isolated | Module-wide | System-wide | External APIs affected]
**Requires Immediate Review:** [YES / NO – why]

---

### 🚨 Critical Issues
_If none, write "None found" and skip to the next section._

#### [CRITICAL ISSUE TITLE]
**File:** `path/to/file:L125`
**Impact:** Data loss / Security hole / System crash
**Fix:**
```
// Quick code fix example here
```

---

### ⚠️ Concerns
_Should discuss or fix before merge. If none, write "None found."_

Use consistent prefixes:
- `[SECURITY]` — Missing input sanitization, hardcoded secrets, auth bypass
- `[PERFORMANCE]` — Unindexed queries, O(n²) loops, full table scans
- `[LOGIC]` — Incorrect conditions, off-by-one, missing edge cases
- `[CONCURRENCY]` — Data races, missing isolation, legacy GCD patterns (may be blocker or concern — see Swift Concurrency rules)
- `[TESTING]` — Missing or inadequate test coverage

---

### 🎯 Maintainer Decision Guide

**Merge confidence:** [0–100]%
- [ ] Safe to merge after fixing blockers
- [ ] Needs architecture discussion first
- [ ] Requires performance testing
- [ ] Get security team review
- [ ] Author should split into smaller PRs

**Time to properly review:** ~[X] minutes
**Recommended reviewer expertise:** [Backend | Security | Database | Frontend | iOS | Data]

---

### Formatting Rules

- Emoji are reserved for section headers and risk indicators only — do not scatter them through body text
- Keep sections short; if empty, say "None found"
- Blockers get full detail, everything else stays concise
- Include code examples only for blockers
- Bold key impact/risk words
- Use consistent prefixes like [SECURITY], [PERFORMANCE], [LOGIC] for easy scanning
- If PR is genuinely fine, end with: ✅ "This PR is safe to merge as-is." (This is an exception to the first formatting rule.)

---

## Project-Specific Review Rules

### Test Coverage
If the PR modifies files in `Sources/**`, `server/**`, or `api/**` and there
are **no** corresponding changes in `Tests/**` or `**/*.test.*`, flag as
**needing tests**. Reference: every new public function or bug fix requires
at least one test (Arrange-Act-Assert, one concern per test).

### Security-Sensitive Areas
If the PR modifies files related to authentication, payments, token handling,
or PII access, add a comment requesting **security review**. Specifically:
- Hardcoded API keys, tokens, passwords, or connection strings → **blocker**
- SQL built with string interpolation instead of parameterized queries → **blocker**
- Missing input validation on public endpoints → **concern**
- Logging that may expose secrets or auth headers → **concern**

### Swift Concurrency (iOS)
Flag the following in any `.swift` file:
- `DispatchQueue.main.async` → **blocker** — must use `@MainActor` or `MainActor.run {}`
- `@unchecked Sendable` → **blocker** — must fix underlying isolation instead
- Missing `@MainActor` on classes or functions that update UI → **blocker**
- `ObservableObject` / `@Published` in new code → concern — should use `@Observable` macro
- Unstructured `Task { }` without `[weak self]` → concern — potential retain cycle

### Data Engineering (SQL / Python)
Flag the following in SQL or Python pipeline code:
- SQL keywords not in UPPERCASE → style violation
- Implicit joins (comma-separated FROM) → should use explicit JOIN type
- Missing table aliases → readability concern
- `print()` in pipeline code → **blocker** — must use structured logging
- Missing type hints on pipeline function signatures → concern

### Dependency Changes
If `Package.swift`, `Podfile`, `package.json`, or `requirements.txt` is
modified:
- Flag **new** dependencies for review — justify why they are needed
- Check if an existing dependency or built-in framework already covers the use case
- Flag version pins or unpinned versions as a concern

### Common Patterns to Enforce
- TODO/FIXME comments without linked issues → flag
- SwiftUI View bodies exceeding ~30 lines → suggest extracting subviews
- Functions exceeding single responsibility → flag
- Duplicated logic that exists elsewhere in the codebase → flag with path to existing implementation
