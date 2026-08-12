# Project Structure — Mantra Japa Counter

This document outlines the project file tree and layer responsibility layout for the Mantra Japa Counter application.

Read [architecture.md](architecture.md) for full architectural guidelines.

---

## 1. Directory Tree Layout

```
MantraJapaCounter/
├── .gitignore
├── .gitmodules
├── AGENTS.md                          ← AI agent root instructions
├── CLAUDE.md                          ← Claude Code root instructions
├── LICENSE
├── README.md
├── analysis_options.yaml
├── android/                           ← Android platform integration
│   ├── app/
│   │   ├── build.gradle.kts
│   │   └── src/
│   ├── key.properties (gitignored)
│   ├── keystore.jks (gitignored)      ← Release keystore
│   └── build.gradle.kts
├── assets/                            ← App assets
│   ├── config/
│   │   └── app_config.json            ← Single source of truth for About metadata
│   └── fonts/                         ← Custom fonts (EBGaramond, Inter, NotoSansMalayalam)
├── change_log/                        ← Historical change log records
├── docs/                              ← Architecture, security, guidelines
│   ├── GUIDELINES_MANIFEST.md
│   ├── architecture.md
│   ├── dependencies.md
│   ├── features.md
│   ├── flutter_build_flavors_guide.md
│   ├── flutter_project_engineering_standard.md
│   ├── guidelines/                    ← Git submodule for shared guidelines
│   ├── implementation_plan.md
│   ├── implementation_progress.md
│   ├── project_structure.md
│   ├── release_process.md
│   ├── security.md
│   └── workflow_rules.md
├── lib/                               ← Application source code
│   ├── config/                        ← Router, theme, locale config, app constants
│   ├── core/                          ← Core framework utilities & config
│   │   └── config/                    ← AppConfig model & ConfigService loader
│   ├── l10n/                          ← Localization arb files & generated code
│   ├── models/                        ← Pure Dart domain models
│   ├── providers/                     ← Riverpod state management providers
│   ├── repositories/                  ← Local database (sqflite) & preferences access
│   ├── screens/                       ← UI screens (CounterList, Counting, History, etc.)
│   ├── services/                      ← Platform services (Notification, Export, Audio)
│   ├── utils/                         ← Helper functions & extensions
│   ├── widgets/                       ← Reusable UI widgets
│   └── main.dart                      ← App initialization entry point
├── plans/                             ← Implementation plans
├── pubspec.yaml                       ← Dependencies and assets manifest
└── test/                              ← Unit, widget, and fixture tests
```

---

## 2. Layer Responsibilities

- **`lib/core/config/`**: Holds `AppConfig` and `ConfigService` for loading and validating `assets/config/app_config.json`.
- **`lib/models/`**: Holds immutable pure Dart data classes (`Counter`, `JapaSession`, `ExportData`). No Flutter or sqflite dependencies.
- **`lib/repositories/`**: Handles sqflite SQLite operations and `shared_preferences` storage for crash recovery.
- **`lib/services/`**: Encapsulates platform capabilities (local notifications, export/import file parsing, audio player).
- **`lib/providers/`**: Riverpod providers exposing state to UI components.
- **`lib/screens/`**: High-level page widgets (`CounterListScreen`, `CountingScreen`, `HistoryScreen`, `AboutCounterScreen`, `SettingsScreen`, `AboutScreen`).
- **`lib/widgets/`**: Reusable component widgets (stat cards, counter cards, dialogs).
