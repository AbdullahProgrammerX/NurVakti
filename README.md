# 🕌 Nur Vakti - Islamic Lifestyle App

A modern, high-performance Islamic lifestyle application for iOS and Android. Built with Flutter, combining the spirit of traditional calendar pages with a premium mobile experience.

## ✨ Features

### 📅 Calendar Leaf (Home Screen)
- Classic calendar leaf design with daily content
- Miladi (Gregorian) + Hijri date display
- Swipe left/right to navigate between days
- Daily content includes:
  - **Verse of the Day** (Quran)
  - **Hadith of the Day**
  - **Risale-i Nur Quote**
  - **On This Day in History**
  - **Daily Dinner Suggestion**

### 🕌 Prayer Times
- 6 daily prayer times (Imsak, Sunrise, Dhuhr, Asr, Maghrib, Isha)
- Countdown timer to next prayer
- Current/passed prayer highlighting
- Location-based (city/district selection)

### 🧭 Qibla Finder
- Compass-based Qibla direction
- Visual compass UI with directional labels

### 📿 Dhikr Counter (Tasbeeh)
- Multiple dhikr types (SubhanAllah, Alhamdulillah, Allahu Akbar, etc.)
- Arabic text display
- Pulse & ripple animations
- Haptic feedback
- Circular progress indicator
- Persistent counts (survives app restart via Hive)
- Daily/total counters
- Reset functionality

### ⭐ Favorites
- Save verses, hadiths, quotes, historical events, recipes
- Category-based tabs
- Share functionality (planned)

### 📆 Religious Days & Kandils
- Upcoming religious days list
- Detail view with descriptions and recommended prayers
- Kandil vs. Religious Day categorization

### ⚙️ Settings
- Light/Dark theme toggle
- Notification preferences
- Location settings
- About page

## 🎨 Design

- **Light Theme**: Cream, forest green, gold tones
- **Dark Theme**: Deep navy, emerald, gold accents
- **Typography**: Inter (Latin) + Amiri (Arabic)
- **Micro-animations**: Page transitions, button pulses, ripple effects

## 🏗️ Architecture

```
lib/
├── app/
│   ├── router.dart          # GoRouter configuration
│   ├── shell_page.dart      # Bottom navigation shell
│   └── theme/               # Theme system
├── core/                    # Shared utilities
├── features/
│   ├── home/                # Calendar leaf home page
│   ├── prayer_times/        # Prayer times
│   ├── qibla/               # Qibla finder
│   ├── dhikr/               # Dhikr counter
│   ├── favorites/           # Favorites
│   ├── religious_days/      # Religious days & kandils
│   └── settings/            # App settings
└── services/                # API, notification, storage services
```

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Riverpod |
| Navigation | GoRouter |
| Local Storage | Hive |
| Typography | Google Fonts |
| Backend (planned) | NestJS + PostgreSQL + Redis |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x+
- Dart 3.x+
- Android Studio / Xcode

### Run
```bash
flutter pub get
flutter run
```

## 📋 Roadmap

- [x] Project setup & folder structure
- [x] Theme system (light/dark)
- [x] Navigation (bottom bar + popup menu)
- [x] Home page (calendar leaf with daily content)
- [x] Prayer times page (mock data)
- [x] Qibla finder (compass UI)
- [x] Dhikr counter (full feature)
- [x] Favorites (category tabs)
- [x] Religious days & kandils
- [x] Settings page
- [ ] Backend (NestJS + Diyanet API proxy)
- [ ] Real prayer time data
- [ ] Notification system
- [ ] Home screen widgets
- [ ] Sharing & visual card generation
- [ ] Multi-language support (TR, EN, AR)
- [ ] Cloud backup

## 📄 License

This project is private and proprietary.
