# Implementation Plan — Mantra Japa Counter

This document records the overall implementation roadmap and build phases for the Mantra Japa Counter application.

**Date:** 2026-08-12  
Read [architecture.md](architecture.md) and [project_structure.md](project_structure.md) for technical design details.

---

## 1. Overview & Objectives

The goal of the Mantra Japa Counter Flutter migration is to build a high-performance, offline-first application for tracking mantra recitations with zero data loss guarantees, precise mala calculation (1 mala = 108 chants), session history management, and byte-level export/import compatibility with the legacy Android (Compose + Room) application.

---

## 2. Phased Build Roadmap

### Phase 1: Core Domain & Data Layer
- Implement immutable models (`Counter`, `JapaSession`, `ExportData`).
- Implement sqflite Database Helper (Schema v3) and SharedPreferences recovery layer.
- Build mala calculation utilities and unit test suite.

### Phase 2: Services & State Management
- Implement `NotificationService` for local daily practice reminders.
- Implement `ExportService` for JSON export and import parsing with fallback safety.
- Implement Riverpod state providers for counter lists, active session state, and user preferences.

### Phase 3: Presentation & User Experience
- Build `CounterListScreen`, `CountingScreen`, `HistoryScreen`, `AboutCounterScreen`, and `SettingsScreen`.
- Implement dynamic, data-driven `AboutScreen` loading from `assets/config/app_config.json` via `ConfigService`.
- Apply custom typography (EBGaramond, Inter, NotoSansMalayalam) and Material 3 thematic styling.

### Phase 4: Quality Assurance & Guidelines Alignment
- Ensure 100% compliance with `docs/GUIDELINES_MANIFEST.md` standards.
- Add mandatory root AI instructions (`AGENTS.md` and `CLAUDE.md`).
- Populate complete mandatory documentation suite in `docs/`.
- Run full automated test suite and static analysis (`flutter analyze`, `flutter test`).
