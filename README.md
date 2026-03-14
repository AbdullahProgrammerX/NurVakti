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
| Framework | Flutter 3.8+ |
| State Management | Riverpod |
| Navigation | GoRouter |
| Local Storage | Hive (persistent) |
| Remote Storage | Supabase (PostgreSQL) |
| Backend | Supabase Edge Functions |
| API Integration | Diyanet İşleri Başkanlığı API |
| Notifications | flutter_local_notifications |
| Typography | Google Fonts (Inter + Amiri) |

## 🚀 Getting Started

### Quick Start
```bash
# 1. Install dependencies
flutter pub get

# 2. Setup environment (see QUICK_START.md for details)
cp .env.example .env
# Edit .env with your Supabase credentials

# 3. Run the app
flutter run
```

### Full Setup Guide
See [QUICK_START.md](QUICK_START.md) for detailed setup instructions including:
- Supabase configuration
- Diyanet API integration
- Environment variables
- Testing guide

## 📋 Progress

### ✅ Completed
- [x] Project setup & folder structure
- [x] Theme system (light/dark) - **Fully working**
- [x] Navigation (bottom bar + popup menu)
- [x] Home page (calendar leaf with daily content)
- [x] Dhikr counter with **persistent storage** (Hive)
- [x] Favorites system (UI + backend ready)
- [x] Religious days & kandils (9 events in database)
- [x] Settings page
- [x] **Supabase backend** (PostgreSQL + Edge Functions)
- [x] **Database schema** (7 tables with RLS)
- [x] **Edge Functions deployed**:
  - sync-prayer-times
  - sync-qibla-directions
- [x] **Service layer** (Prayer Times, Favorites, Notifications, Device)
- [x] **Notification infrastructure**
- [x] **20 Risale-i Nur quotes** integrated

### 🚧 In Progress
- [ ] Diyanet API integration (Edge Functions ready, needs testing)
- [ ] Real prayer time data sync
- [ ] Notification scheduling & testing
- [ ] Favorites UI integration (service ready)
- [ ] Location service & auto-detection
- [ ] Qibla sensor integration

### 📅 Planned
- [ ] Home screen widgets
- [ ] Sharing & visual card generation
- [ ] Multi-language support (TR, EN, AR)
- [ ] Cloud backup
- [ ] Custom notification sounds
- [ ] Performance optimizations

**Current Status:** ~90% Complete - Beta ready!

## 📚 Documentation

- [QUICK_START.md](QUICK_START.md) - Get started in 5 minutes
- [PROJECT_STATUS.md](PROJECT_STATUS.md) - Detailed progress & roadmap
- [SETUP.md](SETUP.md) - Full setup instructions
- [DIYANET_API_INTEGRATION.md](DIYANET_API_INTEGRATION.md) - API integration guide

## 📄 License

This project is private and proprietary.
