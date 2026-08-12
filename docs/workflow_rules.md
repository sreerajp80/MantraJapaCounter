# Workflow Rules — Mantra Japa Counter

This document defines the mandatory development workflow rules for the Mantra Japa Counter project.

Read [AGENTS.md](../AGENTS.md) and [CLAUDE.md](../CLAUDE.md) before making any code changes. See [GUIDELINES_MANIFEST.md](GUIDELINES_MANIFEST.md) for the complete list of guidelines.

---

## 1. Plan Before Changing

Before making any non-trivial code modification, bug fix, or feature implementation:
- Create a dedicated plan file in the `plans/` directory named `yyyymmdd_hhMMss_<short-slug>.md`.
- Include a `**Status:**` header line (e.g., `Draft`, `Approved`, `In Progress`).
- Detail the problem, objective, affected files, proposed changes, and verification steps.

---

## 2. Explicit Approval Gate

- Do not edit, create, or delete any project file (other than the plan file itself) until the user has explicitly approved the plan.
- A question, suggestion, or ambiguous response does not constitute approval.

---

## 3. Log After Changing

- After completing the implementation and passing all verification checks, write a change log entry in `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md`.
- Summarize the exact changes made, files modified, and verification results, referencing the corresponding plan file.

---

## 4. Relative Paths & Privacy Standard

- All `plans/` and `change_log/` documents MUST use relative repository paths only (e.g., `lib/screens/about_screen.dart`). Never use absolute system paths (such as `C:\...`, `l:\...`, or `file:///...`).
- Plans and change logs MUST NOT contain sensitive or private data (passwords, keystore passphrases, tokens, local absolute paths, internal IP addresses, or PII).
