# 🚀 Nur Vakti - Kurulum Rehberi

## 📋 Gereksinimler

- Flutter SDK 3.8.1+
- Dart 3.8+
- Android Studio / Xcode
- Supabase hesabı (ücretsiz)

## 🔧 Kurulum Adımları

### 1. Projeyi İndirin

```bash
git clone <repository-url>
cd nur_vakti
```

### 2. Bağımlılıkları Yükleyin

```bash
flutter pub get
```

### 3. Supabase Kurulumu

#### 3.1. Supabase Projesi Oluşturun
1. [Supabase](https://supabase.com) hesabı oluşturun
2. Yeni bir proje oluşturun
3. Proje URL ve Anon Key'i kopyalayın

#### 3.2. Environment Variables

`.env.example` dosyasını `.env` olarak kopyalayın:

```bash
cp .env.example .env
```

`.env` dosyasını düzenleyin:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
DIYANET_API_USERNAME=your-diyanet-username
DIYANET_API_PASSWORD=your-diyanet-password
```

#### 3.3. Veritabanı Migration (Otomatik Yapıldı ✅)

Database tabloları otomatik olarak oluşturuldu. Eğer tekrar çalıştırmak isterseniz:
- Supabase Dashboard > SQL Editor'dan migration dosyalarını çalıştırabilirsiniz.

### 4. Android Yapılandırması

#### 4.1. Bildirim İkonları

`android/app/src/main/res/` klasörüne bildirim ikonu ekleyin.

#### 4.2. AndroidManifest.xml

`android/app/src/main/AndroidManifest.xml` dosyasına bildirimi permission'ları ekleyin:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### 5. iOS Yapılandırması

#### 5.1. Info.plist

`ios/Runner/Info.plist` dosyasına bildiri permission açıklamalarını ekleyin:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Namaz vakitlerini belirlemek için konumunuza ihtiyacımız var.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Namaz vakti bildirimlerini göndermek için konumunuza ihtiyacımız var.</string>
```

### 6. Uygulamayı Çalıştırın

#### Development Mode (Supabase olmadan)

```bash
flutter run
```

#### Production Mode (Supabase ile)

```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## 🏗️ Mimari Yapı

```
lib/
├── app/                    # Uygulama yapılandırması
│   ├── router.dart        # Navigation
│   ├── shell_page.dart    # Bottom nav
│   └── theme/             # Tema sistemi
├── core/                  # Paylaşılan kodlar
│   ├── config/            # Konfigürasyon
│   ├── models/            # Data modelleri
│   └── services/          # API servisleri
│       ├── supabase_service.dart
│       ├── prayer_times_service.dart
│       ├── notification_service.dart
│       └── favorites_service.dart
└── features/              # Özellikler
    ├── home/              # Ana sayfa (takvim yaprağı)
    ├── prayer_times/      # Namaz vakitleri
    ├── qibla/             # Kıble bulucu
    ├── dhikr/             # Zikirmatik
    ├── favorites/         # Favoriler
    ├── religious_days/    # Dini günler & kandiller
    └── settings/          # Ayarlar
```

## 🔑 Backend (Supabase) Yapılandırması

### Database Tables

1. **prayer_times** - Namaz vakitleri cache
2. **religious_days** - Dini günler & kandiller
3. **qibla_directions** - Kıble yönleri cache
4. **user_favorites** - Kullanıcı favorileri
5. **notification_settings** - Bildirim ayarları
6. **app_settings** - Uygulama ayarları
7. **api_cache_status** - API cache durumu

### Row Level Security (RLS)

Tüm tablolarda RLS aktif. Public read, device-based write policies mevcut.

## 📱 Özellikler

### ✅ Tamamlanan
- Temel UI (takvim yaprağı, namaz vakitleri, kıble, zikirmatik)
- Tema sistemi (açık/koyu)
- Navigation
- Zikirmatik (persistent storage)
- Günlük içerik sistemi
- Database yapısı
- Favoriler servisi
- Bildirim servisi

### 🚧 Devam Eden
- Diyanet API entegrasyonu
- Gerçek namaz vakitleri
- Bildirim zamanlaması
- Konum servisi
- Paylaşım özelliği

## 🔔 Bildirim Sistemi

Bildirimler `flutter_local_notifications` ile yönetiliyor:

- **Prayer Times**: Her namaz vaktinden X dakika önce bildirim
- **Kandil/Dini Gün**: Sabah 09:00'da bildirim
- **Custom Sound**: Kullanıcı kendi sesini ekleyebilir

## 📊 Diyanet API Entegrasyonu

API limitleri nedeniyle akıllı cache stratejisi:

1. **Edge Function** (Supabase) aylık scheduled job ile Diyanet API'den veri çeker
2. **PostgreSQL** cache olarak kullanılır
3. **Mobile App** cache'ten okur, API'yi doğrudan çağırmaz

Bu sayede 100,000+ kullanıcı desteklenir.

## 🛠️ Geliştirme Komutları

```bash
# Build runner (code generation)
flutter pub run build_runner build --delete-conflicting-outputs

# Hive generator
flutter packages pub run build_runner build

# Clean & rebuild
flutter clean && flutter pub get

# Format code
flutter format .

# Analyze
flutter analyze
```

## 📦 Build

### Android APK

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

### iOS IPA

```bash
flutter build ios --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## 🐛 Debugging

### Supabase Bağlantı Sorunları

```bash
# Offline mode'da çalıştır (test için)
flutter run
```

### Bildirim Testi

```dart
await NotificationService.requestPermissions();
```

## 📞 Destek

Sorun yaşarsanız:
1. `flutter doctor` çalıştırın
2. `flutter clean && flutter pub get`
3. Logs kontrol edin: `flutter logs`

## 📄 Lisans

Private & Proprietary
