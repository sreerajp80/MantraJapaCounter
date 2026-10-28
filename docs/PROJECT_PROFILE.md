# Project Profile — SreerajP MantraJapa Counter

This file records the project's declared choices — platforms, stores, languages, identity and
About options. Every rule that depends on a platform, store or language applies only when this
file declares it (engineering standard §1.2.1). It was filled in from
`docs/guidelines/PROJECT_PROFILE_TEMPLATE.md` with the intake in
`docs/guidelines/AI_AGENT_START_HERE.md` §3, and approved by the user on 2026-10-27.

Read [GUIDELINES_MANIFEST.md](GUIDELINES_MANIFEST.md) for the guideline set. Only public
information goes here.

---

## 0. Product brief

| Item | Value |
|---|---|
| What the app does | Counts mantra repetitions (japa) for named counters, with malas, daily and lifetime goals, and a practice history |
| Main features | Counters with goals and per-counter mala size; full-screen tap counting with sound and haptics; session history and Sadhana Flow heat-map; daily practice reminder; JSON backup (optionally encrypted) and offline Optical Sync between phones; help screens — see [features.md](features.md) |
| Who uses it | People who chant mantras and want to track their daily practice |
| Out of scope for now | Network features, accounts, cloud sync, iOS and other platforms |

### 0.1 Data and privacy

Every app follows the Security Baseline (engineering standard §15.1) whatever the answers are.

| Item | Value |
|---|---|
| Works offline / needs the network | Offline only — no `INTERNET` permission |
| Backend or third-party API | none |
| User accounts / sign-in | none |
| Data the app stores, and where | Counters, sessions and settings — on the device only (sqflite, SharedPreferences). Android backup is off |
| Personal, health, finance or secret data | none |
| Analytics | none |
| Crash reporting | none |
| Ads | none |
| Other third-party SDKs that send data | none |
| In-app purchases or subscriptions | none |
| Device permissions | `VIBRATE` — feedback on mala and goal completion |
| | `POST_NOTIFICATIONS` — optional goal, mala and reminder notifications (Android 13+) |
| | `CAMERA` — optional Optical Sync receive (reads QR codes on the device) |
| | `RECEIVE_BOOT_COMPLETED` — sets the daily reminder again after a restart |
| | `ACCESS_NOTIFICATION_POLICY` — optional Do Not Disturb while chanting |

## 1. Identity

| Item | Value |
|---|---|
| App display name | `SreerajP MantraJapa Counter` (per language in `assets/config/app_config.json`; dev builds add " Dev") |
| Short description (one line) | Offline-first application for tracking mantra recitation practice with customizable counters and session history. |
| Organization / publisher | Sreeraj P |
| Reverse-DNS app id | `com.sreerajp.mantrajapacounter` (dev: `com.sreerajp.mantrajapacounter.dev`) |
| Dart package name (`pubspec.yaml` `name`) | `mantra_japa_counter` |
| Public support contact | `sreerajp@zohomail.in` |
| Website | none |
| Privacy policy URL | `https://github.com/sreerajp80/MantraJapaCounter/blob/main/PRIVACY_POLICY.md` — the same URL is used in `app_config.json` (`privacyPolicy`) and every store console |
| Copyright line | `© 2026 Sreeraj P` |
| License of the app's own code | MIT |

## 2. Applicability profiles (engineering standard §1.2)

- [x] `Core Baseline` (always)
- [x] `Production App Extension` — shipped to real users through Google Play and direct APK
- [ ] `Sensitive Data Extension` — not in force: the app keeps no secrets, PII, health or finance
      data, and no local encrypted store. The only encryption is the optional passphrase on
      export files.

## 3. Target platforms and distribution

This table is the one place for the minimum OS of each platform and its reason.

| Platform | Ship? | Minimum OS | Distribution channels |
|---|---|---|---|
| Android | yes | `minSdk 29` (Android 10) — the oldest version the app is tested on; covers almost all active devices and lets the app rely on modern notification and file-picker behavior | Google Play; direct APK (split per ABI) |
| iOS | no | — | — |
| Windows | no | — | — |
| macOS | no | — | — |
| Linux | no | — | — |
| Web | no | — | — |

Build flavors: `dev + prod` (engineering standard §5.1). Orientation: portrait only.

## 4. Languages (engineering standard §8)

| Locale | Language | Script | Role | Language pack |
|---|---|---|---|---|
| `en` | English | Latin | Template ARB, ultimate fallback | — |
| `ml` | Malayalam | Malayalam | Full UI translation | `language_packs/sanskrit_malayalam.md` |
| `sa` | Sanskrit | Devanagari | Full UI translation | `language_packs/sanskrit_malayalam.md` |

- In-app language picker: required — 3 languages.
- Languages without a Flutter framework translation (need the fallback delegate, §8.3.1): `sa`.
- Store-listing languages: Google Play — English.
- Native-reader reviewer for each non-template language: the app owner.

## 5. About screen (`guideline.md` §1)

| Item | Value |
|---|---|
| `details` rows to show | author, email, privacyPolicy, license, aiUsed, ideUsed |
| Signature badge (§1.7) | on |
| Badge text — template language | `Made with {heart} from India` |
| Badge text — each other language | `ml`: `സ്നേഹത്തോടെ {heart} ഇന്ത്യയിൽ നിന്ന്`; `sa`: `सस्नेहं निर्मितम् {heart} भारततः` |
| Badge screen-reader text — each language | `en`: `Made with love from India`; `ml`: `സ്നേഹത്തോടെ ഇന്ത്യയിൽ നിന്ന്`; `sa`: `सस्नेहं निर्मितम् भारततः` |

> The heart is written as `{heart}`, never as an emoji. These texts are the record; they are
> copied into `madeWithLove` / `madeWithLoveA11y` in every ARB file (`guideline.md` §1.7).

## 6. Optional project-specific values

| Item | Value |
|---|---|
| App size budget override (§10.7) | arm64 APK target < 30 MB, hard limit 50 MB ([release_process.md](release_process.md) §6.3) |
| State management | Riverpod (`flutter_riverpod`) |
| Structure tier (§3.1) | Tier 1 layer-first |
| Brand colours | Temple palette — vermillion, tulsi, sandal, rose, cream (`lib/theme/theme.dart`) |
| Theme modes | light only |
| App icon source | supplied by the owner |

## 7. Tools and workflow

| Item | Value |
|---|---|
| AI agents used on the project | Claude Code, Google Gemini (instruction files: `CLAUDE.md`, `AGENTS.md`) |
| IDE | VS Code / Antigravity IDE |
| Can build iOS / macOS locally | not needed |
| Git hosting | GitHub |
| CI checks | GitHub CI — format, l10n staleness, analyze, test only (engineering standard §19) |
| Release owner (role) | App owner / sole developer |
