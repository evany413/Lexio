# Lexio

An AI-powered English vocabulary learning app built with Flutter. Paste any text and let AI pick the words worth learning, then master them with spaced repetition flashcards and quizzes.

## Features

- **AI Word Extraction** — paste a paragraph and AI picks 5–10 words worth learning
- **Word Management** — view, edit, and organize words with status: Active / Mastered / Achieved
- **Flashcards (SRS)** — spaced repetition using the SM-2 algorithm (same as Anki)
- **Quiz** — multiple choice and type-the-word modes
- **CSV Import / Export** — fields: word, type, pronunciation, meaning, usage example, synonym, status
- **Multi-provider AI** — bring your own API key for Anthropic (Claude), OpenAI (GPT-4o), or Google (Gemini)
- **Cross-platform** — Windows, macOS, Linux, iOS, Android, Web

## Tech Stack

| Layer | Library |
|---|---|
| Framework | Flutter / Dart |
| State management | Riverpod |
| Database | Drift (SQLite) |
| Navigation | GoRouter |
| HTTP | Dio |
| AI (Gemini) | google_generative_ai |
| Secure storage | flutter_secure_storage |
| CSV | csv + file_picker |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and on your PATH
- An API key from one of:
  - [Anthropic](https://console.anthropic.com) — starts with `sk-ant-`
  - [OpenAI](https://platform.openai.com) — starts with `sk-`
  - [Google AI Studio](https://aistudio.google.com) — starts with `AIza` (free tier available)

### Install dependencies

```bash
flutter pub get
dart run build_runner build
```

### Web setup (Chrome only)

Download the SQLite WASM binary into the `web/` folder:

```bash
# Windows (PowerShell)
Invoke-WebRequest -Uri "https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.10.2/sql-wasm.wasm" -OutFile "web/sql-wasm.wasm"

# macOS / Linux
curl -L "https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.10.2/sql-wasm.wasm" -o web/sql-wasm.wasm
```

### Run

```bash
# Windows desktop (requires Visual Studio with "Desktop development with C++" workload)
flutter run -d windows

# Chrome
flutter run -d chrome

# List all available devices
flutter run
```

### Windows desktop note

Windows desktop requires [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/) with the **Desktop development with C++** workload installed. Also enable **Developer Mode** in Windows Settings → Privacy & Security → For Developers.

## Word Status Flow

Words move through three stages automatically based on review history (SM-2 algorithm):

```
Active  →  Mastered  →  Achieved
(< 21 days)  (21–90 days)  (> 90 days interval)
```

You can also change the status manually on the word detail screen.

## API Keys

API keys are stored in the OS secure keychain (Windows Credential Manager, macOS Keychain, etc.) using `flutter_secure_storage`. They are never written to disk in plain text and never included in the codebase.

## Project Structure

```
lib/
├── core/
│   ├── database/        # Drift tables, database, DAOs
│   ├── services/ai/     # Anthropic, OpenAI, Gemini implementations
│   ├── services/        # SRS algorithm, CSV service
│   └── router/          # GoRouter configuration
├── features/
│   ├── onboarding/      # API key setup
│   ├── dashboard/       # Home screen with stats
│   ├── word_input/      # AI text analysis
│   ├── word_list/       # Word list with filters
│   ├── word_detail/     # View and edit a word
│   ├── flashcard/       # SRS flashcard session
│   ├── quiz/            # Quiz modes
│   └── settings/        # App settings, import/export
└── shared/
    ├── providers/        # Riverpod providers
    └── widgets/          # Shared widgets
```
