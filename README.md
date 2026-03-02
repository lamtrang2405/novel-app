# DramaVerse 🎭

> **Your Drama. Your Story.**  
> A niche romance & drama audio novel app targeting Gen Z female readers (20–45+).

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-00B4AB?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📱 Screenshots

| Splash | Home | Novel Detail |
|--------|------|--------------|
| Dark neon splash with animated logo | Featured carousel + trending shelves | Full-bleed cover + chapter list |

| Chapter Reader | Audio Player | Library |
|----------------|--------------|---------|
| Dark/Sepia/Light modes | Pulsing album art + neon controls | Reading history + bookmarks |

---

## ✨ Features

- **Immersive Reading** — Chapter reader with Dark / Sepia / Light themes, font size & line spacing controls
- **Audio Narration** — Full-screen audio player with progress, speed selector, skip controls
- **Persistent Mini Player** — Always-accessible audio controls above the bottom nav
- **Coin Economy** — Buy coin packages, spend coins to unlock premium chapters
- **VIP Subscription** — Weekly & monthly plans that unlock all chapters + audio
- **Smart Paywall** — Free chapters, coin-unlock (persisted per chapter), and subscription gate
- **Library** — Reading history with progress bars + bookmarked stories
- **Discovery** — Search + genre filter (Dark Romance, Billionaire, Enemies to Lovers, etc.)
- **Gen Z UI** — Dark-first, neon pink/purple/cyan palette, Oswald + Inter typography

---

## 🗂️ Project Structure

```
lib/
├── app.dart                    # Root widget
├── main.dart                   # Entry point
├── core/
│   ├── constants/
│   │   └── app_constants.dart  # App-wide constants, route paths, coin costs
│   ├── router/
│   │   └── app_router.dart     # GoRouter configuration
│   └── theme/
│       ├── app_colors.dart     # Color palette + neon glow helpers
│       ├── app_text_styles.dart# Typography (Oswald, Inter, Crimson Text)
│       └── app_theme.dart      # ThemeData (dark-first Material 3)
├── features/
│   ├── audio_player/           # Full-screen audio player
│   ├── auth/                   # Sign in / sign up
│   ├── chapter_reader/         # Immersive reading + paywall
│   ├── discover/               # Search + genre filters
│   ├── home/                   # Home feed + main shell/nav
│   ├── library/                # Reading history + bookmarks
│   ├── novel_detail/           # Novel info + chapter list
│   ├── onboarding/             # Splash + onboarding + genre picker
│   ├── profile/                # User stats + settings
│   ├── subscription/           # VIP plans
│   └── wallet/                 # Coin balance + purchase
└── shared/
    ├── models/
    │   ├── mock_data.dart       # Sample novels & reading history
    │   ├── novel_model.dart     # Novel, Chapter, NovelGenre
    │   ├── reading_settings_model.dart
    │   └── user_model.dart     # UserModel, ReadingProgress
    ├── providers/
    │   ├── audio_provider.dart  # Audio playback state (Riverpod)
    │   ├── novels_provider.dart # Novels, search, genre filter
    │   ├── reading_settings_provider.dart
    │   └── user_provider.dart  # User, coins, unlocked chapters
    └── widgets/
        ├── gradient_button.dart
        ├── mini_player.dart
        ├── novel_card.dart      # Vertical + wide card variants
        ├── section_header.dart
        └── shimmer_loading.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Chrome (for web) or Android/iOS simulator

### Installation

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/dramaverse.git
cd dramaverse

# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome --web-port 9000

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios
```

### Build

```bash
# Web
flutter build web --release

# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.6.1 | State management |
| `go_router` | ^14.8.1 | Declarative routing |
| `just_audio` | ^0.9.46 | Audio playback |
| `audio_service` | ^0.18.16 | Background audio |
| `cached_network_image` | ^3.4.1 | Image caching |
| `google_fonts` | ^6.2.1 | Oswald, Inter, Crimson Text |
| `flutter_animate` | ^4.5.2 | Animations & transitions |
| `smooth_page_indicator` | ^1.2.1 | Page dot indicators |
| `percent_indicator` | ^4.2.3 | Progress bars |
| `shimmer` | ^3.0.0 | Loading skeletons |
| `shared_preferences` | ^2.5.2 | Local persistence |

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| **Primary** | `#FF2D78` (hot neon pink) |
| **Accent** | `#BB3CFF` (electric purple) |
| **Cyan** | `#00E5FF` |
| **Gold** | `#FFD600` |
| **Background** | `#0F0F1A` (near-black) |
| **Card** | `#161625` |
| **Display font** | Oswald (Bold, uppercase) |
| **UI font** | Inter (700/400) |
| **Reader font** | Crimson Text |

---

## 💰 Monetization Model

- **Free tier** — First `3` chapters of every novel free
- **Coin unlock** — `2` coins per chapter (persisted per user session)
- **VIP subscription** — Weekly `$2.99` / Monthly `$9.99` — unlocks everything

---

## 🗺️ Roadmap

- [ ] Firebase backend (auth, Firestore novels, cloud coins)
- [ ] Real audio file playback with `just_audio`
- [ ] Push notifications for chapter updates
- [ ] Social features (reviews, ratings, following authors)
- [ ] Android & iOS native builds
- [ ] In-app purchases (RevenueCat integration)

---

## 📄 License

MIT © 2026 DramaVerse
