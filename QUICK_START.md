# 🚀 Nur Vakti - Hızlı Başlangıç Rehberi

## 🎯 Projenizi Çalıştırmak İçin Adım Adım Rehber

---

## 1️⃣ Ön Hazırlık (5 dakika)

### Flutter SDK Kurulumu

Eğer Flutter kurulu değilse:

```bash
# macOS (Homebrew)
brew install flutter

# Linux
# https://docs.flutter.dev/get-started/install/linux adresinden indirin

# Windows
# https://docs.flutter.dev/get-started/install/windows adresinden indirin
```

Flutter kurulumunu kontrol edin:
```bash
flutter doctor
```

Tüm ✓ işaretleri görmeli veya en azından Android/iOS platform desteği olmalı.

---

## 2️⃣ Projeyi Hazırlayın (2 dakika)

### Bağımlılıkları Yükleyin

```bash
cd nur_vakti
flutter pub get
```

Bu komut tüm gerekli paketleri indirecek (60+ paket).

---

## 3️⃣ Supabase Kurulumu (10 dakika)

### A. Supabase Hesabı Oluşturun

1. [https://supabase.com](https://supabase.com) adresine gidin
2. "Start your project" ile ücretsiz hesap oluşturun
3. Yeni bir proje oluşturun:
   - **Project Name**: nur-vakti
   - **Database Password**: Güçlü bir şifre oluşturun (kaydedin!)
   - **Region**: Central EU (Frankfurt) veya en yakın
   - **Plan**: Free tier (yeterli)

### B. API Credentials'ı Alın

Proje oluşturulduktan sonra:

1. Settings > API menüsüne gidin
2. Şu değerleri kopyalayın:
   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **anon/public key**: `eyJhbGc...` (çok uzun bir key)

### C. Environment Variables Ayarlayın

Proje klasöründe `.env` dosyası oluşturun:

```bash
cp .env.example .env
```

`.env` dosyasını düzenleyin:

```env
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
DIYANET_API_USERNAME=sizin_kullanici_adiniz
DIYANET_API_PASSWORD=sizin_sifreniz
```

### D. Database Migration'ları Kontrol Edin

Database tabloları otomatik oluşturuldu ✅

Kontrol etmek için:
1. Supabase Dashboard > Table Editor'a gidin
2. Şu tabloları görmelisiniz:
   - `prayer_times`
   - `religious_days` (9 kayıt olmalı)
   - `qibla_directions`
   - `user_favorites`
   - `notification_settings`
   - `app_settings`
   - `api_cache_status`

### E. Edge Functions Kontrol

Edge Functions deploy edildi ✅

Kontrol etmek için:
1. Supabase Dashboard > Edge Functions
2. Şunları görmelisiniz:
   - `sync-prayer-times`
   - `sync-qibla-directions`

---

## 4️⃣ Diyanet API (Opsiyonel - Şimdilik Mock Data Kullanılabilir)

Gerçek namaz vakitleri için Diyanet API credentials gerekli.

### Diyanet API Başvurusu

1. [https://api.diyanet.gov.tr](https://api.diyanet.gov.tr) adresine gidin (veya ilgili kayıt sayfası)
2. API erişimi için başvurun
3. Kullanıcı adı ve şifrenizi `.env` dosyasına ekleyin

### İlk Veri Sync (API Credentials Aldıktan Sonra)

```bash
# Edge Function'ı manuel tetikle
curl -X POST \
  https://xxxxxxxxxxxxx.supabase.co/functions/v1/sync-prayer-times?city=İstanbul \
  -H "Authorization: Bearer YOUR_SUPABASE_ANON_KEY"
```

Bu komut İstanbul için 30 günlük namaz vakitlerini çekecek.

**Not:** Şimdilik mock data ile test edebilirsiniz, API olmadan da uygulama çalışır.

---

## 5️⃣ Uygulamayı Çalıştırın (1 dakika)

### iOS Simulator'da Çalıştırma

```bash
# iOS simulator'ü açın
open -a Simulator

# Uygulamayı çalıştırın
flutter run
```

### Android Emulator'da Çalıştırma

```bash
# Android emulator'ü başlatın (Android Studio'dan)
# Veya komut satırından:
emulator -avd Pixel_5_API_33

# Uygulamayı çalıştırın
flutter run
```

### Fiziksel Cihazda Çalıştırma

```bash
# Cihazı USB ile bağlayın
# Developer mode ve USB debugging aktif olmalı

flutter devices  # Cihazları listele
flutter run      # Seçilen cihazda çalıştır
```

---

## 6️⃣ İlk Test (5 dakika)

### Test Senaryosu

1. **Ana Sayfa (Takvim Yaprağı)**
   - ✅ Bugünün tarihini görmeli
   - ✅ Hicri tarihi görmeli
   - ✅ Günün ayeti, hadisi, Risale-i Nur vecizesi, tarihi, yemeği görünmeli
   - ✅ Sağa/sola kaydırarak diğer günlere geçilebilmeli

2. **Namaz Vakitleri**
   - ✅ 6 vakit görünmeli (şu an mock data)
   - ✅ Konum: İstanbul, Fatih görünmeli
   - ✅ Geri sayım timer çalışmalı (mock)

3. **Zikirmatik**
   - ✅ Tıklayınca sayaç artmalı
   - ✅ Haptic feedback olmalı
   - ✅ Uygulamayı kapatıp açınca sayaç korunmalı (Hive persistent storage)
   - ✅ Sıfırla butonuna basınca sıfırlanmalı

4. **Kıble**
   - ✅ Pusula UI görünmeli
   - ✅ 153.5° görünmeli (İstanbul için mock)

5. **Dini Günler**
   - ✅ Sağ üst menü > Dini Günler & Kandiller
   - ✅ 9 gün/kandil listelenmeli
   - ✅ Birine tıklayınca detay popup açılmalı

6. **Tema Değiştirme**
   - ✅ Sağ üst menü > Ayarlar > Koyu Tema
   - ✅ Tema anında değişmeli, tüm ekranlar tutarlı olmalı

7. **Favoriler**
   - ✅ Alt menü > Favoriler
   - ✅ 5 kategori tab görünmeli
   - ✅ Empty state mesajları olmalı (henüz favori yok)

---

## 🎨 Tema & Tasarım Test

Uygulamayı hem açık hem koyu temada test edin:

### Açık Tema
- Krem/bej arka plan
- Yeşil primary color
- Altın accent color

### Koyu Tema
- Lacivert/siyah arka plan
- Emerald yeşil primary
- Altın accent

Her iki temada da renkler okunabilir ve tutarlı olmalı.

---

## 🔔 Bildirim Testi

### İzin İsteği

İlk açılışta bildirim izni istenir. "İzin Ver" deyin.

### Test Bildirimi (Development)

```dart
// lib/core/services/notification_service.dart dosyasına test kodu ekleyebilirsiniz:

static Future<void> sendTestNotification() async {
  await _notifications.show(
    999,
    'Test Bildirimi',
    'Bildirimler çalışıyor!',
    NotificationDetails(
      android: AndroidNotificationDetails(
        'test',
        'Test',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}
```

Ardından herhangi bir sayfada:
```dart
await NotificationService.sendTestNotification();
```

---

## 🐛 Sorun Giderme

### Hata: "Supabase client not initialized"

**Çözüm:** `.env` dosyasındaki SUPABASE_URL ve SUPABASE_ANON_KEY doğru mu kontrol edin.

```bash
flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGc...
```

### Hata: "Package not found"

**Çözüm:**
```bash
flutter clean
flutter pub get
flutter run
```

### iOS Simulator'de Bildirim Çalışmıyor

**Çözüm:** iOS Simulator bildirim göstermez ama hata vermez. Fiziksel cihazda test edin.

### Android Emulator'de Konum Çalışmıyor

**Çözüm:** Emulator settings'den manuel konum girin.

### Zikirmatik Sayaçları Sıfırlandı

**Çözüm:** Hive kutularını kontrol edin:
```bash
flutter clean
# Uygulamayı yeniden çalıştır
```

---

## 📱 Build (Production)

### Android APK

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGc...
```

APK: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA

```bash
flutter build ios --release \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGc...
```

Xcode'dan Archive > Distribute yapın.

---

## 🎉 Başarılı Kurulum!

Uygulamanız şu anda:
- ✅ Offline çalışabiliyor (Hive cache)
- ✅ Tema değiştirme çalışıyor
- ✅ Zikirmatik persistent storage ile çalışıyor
- ✅ Takvim yaprağı günler arası geçiş yapıyor
- ✅ Dini günler & kandiller listeleniyor

Gerçek namaz vakitleri için Diyanet API credentials ekleyin ve Edge Function'ı tetikleyin.

---

## 📚 Daha Fazla Bilgi

- [SETUP.md](SETUP.md) - Detaylı kurulum
- [PROJECT_STATUS.md](PROJECT_STATUS.md) - Proje durumu
- [DIYANET_API_INTEGRATION.md](DIYANET_API_INTEGRATION.md) - API entegrasyonu
- [README.md](README.md) - Genel bakış

---

## 💬 Destek

Sorun yaşarsanız:
1. `flutter doctor` çalıştırın
2. `flutter clean && flutter pub get`
3. Logs kontrol edin: `flutter logs`

**İyi çalışmalar! 🕌✨**
