# Flutter Guidelines — Manifest

This is a **single, portable pointer file**. It carries the relative paths to the shared Flutter
guideline documents. Copy this file into your Flutter app's `docs/` folder, and add the guidelines
repository as a Git submodule at `docs/guidelines/` to keep your app consistent.

The guidelines live at:

```
docs/guidelines/
```

## How to use this file

1. Copy `GUIDELINES_MANIFEST.md` into the `docs/` folder of your Flutter app.
2. The user adds the guidelines repository as a Git submodule at `docs/guidelines/`:
   ```bash
   git submodule add <REPOSITORY_URL> docs/guidelines
   ```
3. **The submodule is read-only for the project.** Never edit, pull, check out or commit it or
   its version from the project. Only the user updates its version. If a guideline needs a
   change, see `docs/guidelines/DOCS_FOLDER_GUIDELINE.md` §1.1 "When the guidelines need a change".
4. Copy `docs/guidelines/PROJECT_PROFILE_TEMPLATE.md` to `docs/PROJECT_PROFILE.md` and fill it in
   (product brief, platforms, stores, languages, identity, About options, tools) — an AI agent does
   this with the intake in `docs/guidelines/AI_AGENT_START_HERE.md` §3. Copy the other templates
   (`architecture.md`, `security.md`, `release_process.md`) into `docs/` and create the rest of
   the baseline set (`DOCS_FOLDER_GUIDELINE.md` §6).
5. Reference it from the app's mandatory root `CLAUDE.md` and `AGENTS.md` (e.g. "Follow the guidelines listed in
   `docs/GUIDELINES_MANIFEST.md`, starting with `docs/guidelines/AI_AGENT_START_HERE.md`.").
6. Open the documents at the relative paths below to read the guidelines.

> **Templates vs. references.** Four files are **templates**: copy them into this app's `docs/`
> folder and fill them in — `PROJECT_PROFILE_TEMPLATE.md` (as `PROJECT_PROFILE.md`),
> `architecture.md`, `security.md`, `release_process.md`. For these, the **local copy wins**.
> This manifest is the one **pointer file**: it is copied into `docs/` unchanged and never
> edited there. Every other file is a **reference**: never copy it; read it at the submodule path
> below.

## Core documents

| Core documents | Relative path | What it is |
|---|---|---|
| AI agent entry point | `docs/guidelines/AI_AGENT_START_HERE.md` | Read order, new-app bootstrap, existing-app adoption, "ready for the stores" checklist. |
| Project profile template | `docs/guidelines/PROJECT_PROFILE_TEMPLATE.md` | Template for this app's `docs/PROJECT_PROFILE.md` — product brief and data use, identity, platforms, stores, languages, About options, tools. |
| Common app conventions | `docs/guidelines/guideline.md` | About-screen JSON config, optional signature badge, Android release keystore rules (**source of truth for keystore rules**), signing on other platforms, baseline `lib/` layout. |
| Engineering standard | `docs/guidelines/flutter_project_engineering_standard.md` | The master, project-agnostic rulebook — rules that apply to *every* app (structure, UI, accessibility, localization, performance, database, logging, security, desktop setup, CI, git, Definition of Done). |
| Store readiness gates | `docs/guidelines/platform_store_readiness.md` | Release gates for Google Play, App Store, Microsoft Store, Mac App Store / Developer ID, Snap Store / Flathub / Linux packages. |
| Release process | `docs/guidelines/release_process.md` | Step-by-step release runbook — versioning, hardening, signing, per-platform build commands, distribution, rollback. |
| Build flavors guide | `docs/guidelines/flutter_build_flavors_guide.md` | Platform-by-platform technical reference for build flavors on Android, iOS, Windows, macOS and Linux. |
| Architecture blueprint | `docs/guidelines/architecture.md` | A per-project architecture blueprint template. Fill it in with one app's actual decisions. |
| Security blueprint | `docs/guidelines/security.md` | A per-project security blueprint template — threat model, sensitive-data inventory, crypto design, platform controls, OWASP checklist. |
| Language packs | `docs/guidelines/language_packs/` | Language-specific rules, mandatory only for declared languages. Currently `sanskrit_malayalam.md`. |
| Example profiles | `docs/guidelines/profiles/` | Worked examples of filled-in project profiles. |
| CLAUDE.md writing guideline | `docs/guidelines/CLAUDE_MD_GUIDELINE.md` | Mandatory guideline for creating and maintaining the project-root `CLAUDE.md` for every Flutter project (**MUST**). |
| AGENTS.md writing guideline | `docs/guidelines/AGENTS_MD_GUIDELINE.md` | Mandatory guideline for creating and maintaining the project-root `AGENTS.md` for other LLMs and AI agents (**MUST**). |
| Docs folder guideline | `docs/guidelines/DOCS_FOLDER_GUIDELINE.md` | How to create files in a project's `docs/` folder (local vs submodule, naming rules, file anatomy, catalog of recognized doc types). |
| Index / README | `docs/guidelines/README.md` | The overview of the whole guideline set and where to start. |

## Plain-English explainers

Dense documents have a matching explainer that describes, in simple English, what the document
says and how to use it. Open the explainer first if a document looks hard.

| Explainer | Relative path |
|---|---|
| Architecture explainer | `docs/guidelines/docs/architecture_README.md` |
| Engineering standard explainer | `docs/guidelines/docs/flutter_project_engineering_standard_README.md` |
| Build flavors explainer | `docs/guidelines/docs/flutter_build_flavors_guide_README.md` |
| Store readiness explainer | `docs/guidelines/docs/platform_store_readiness_README.md` |
| Release process explainer | `docs/guidelines/docs/release_process_README.md` |
| Security explainer | `docs/guidelines/docs/security_README.md` |

## Which documents apply to my app (by profile)

The engineering standard defines three applicability profiles. Profiles stack — pick the ones
that fit your app, then read across the row. A small internal tool is `Core Baseline` only; a
shipped password manager is in all three. Platform-, store- and language-specific rules apply only
to what `docs/PROJECT_PROFILE.md` declares.

| Profile | Applies to | Documents in force |
|---|---|---|
| `Core Baseline` | Every app | The Security Baseline (`flutter_project_engineering_standard.md` §15.1, `security.md` §1.1, **MUST**); Root `CLAUDE.md` (via `CLAUDE_MD_GUIDELINE.md`, **MUST**); Root `AGENTS.md` (via `AGENTS_MD_GUIDELINE.md`, **MUST**); the 9 baseline `docs/` files, including `PROJECT_PROFILE.md`, `architecture.md`, `security.md` and `release_process.md` (`DOCS_FOLDER_GUIDELINE.md` §6, **MUST**); `guideline.md`; Core Baseline rules of `flutter_project_engineering_standard.md`; language packs for declared languages |
| `Production App Extension` | Apps shipped to real users / QA / stores | The above **plus** `platform_store_readiness.md` (declared channels), the full `release_process.md`, the OWASP sign-off in `security.md` §12, `flutter_build_flavors_guide.md` (if using flavors), and the Production sections of the engineering standard |
| `Sensitive Data Extension` | Apps handling secrets, PII, health, finance, or local encrypted stores | The above **plus** the full `security.md` and the Sensitive Data sections of the engineering standard |

`security.md` and `release_process.md` exist in every app; an app outside the matching profile
keeps them short and says so at the top. Every app is secure by default: the Security Baseline
applies whatever the profile, and the profiles only add controls on top.

## Where to start

- **Using an AI agent** — point it at `AI_AGENT_START_HERE.md`.
- **Writing / maintaining project root `CLAUDE.md` & `AGENTS.md` (MUST)** — follow `CLAUDE_MD_GUIDELINE.md` and `AGENTS_MD_GUIDELINE.md`.
- **Starting a new app** — fill in `PROJECT_PROFILE_TEMPLATE.md`, then read `guideline.md` and `flutter_project_engineering_standard.md`.
- **Structuring project `docs/` files** — follow `DOCS_FOLDER_GUIDELINE.md`.
- **Designing one app's structure** — fill in `docs/architecture.md` (copied from the template).
- **Setting up build flavors** — see `flutter_build_flavors_guide.md`.
- **Publishing to a store** — pass `platform_store_readiness.md`, then follow `docs/release_process.md`.
- **Handling sensitive data** — fill in `docs/security.md` in full.
