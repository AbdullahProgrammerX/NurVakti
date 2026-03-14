# 🎯 Sonraki Adımlar - Nur Vakti

## 🏁 Şu Ana Kadar Yapılanlar (Özet)

### ✅ Tamamlanan İşler

1. **Supabase Database Yapısı** oluşturuldu:
   - 7 tablo (prayer_times, religious_days, qibla_directions, user_favorites, notification_settings, app_settings, api_cache_status)
   - Row Level Security (RLS) aktif
   - 9 dini gün/kandil kaydı eklendi

2. **Edge Functions Deploy Edildi**:
   - `sync-prayer-times` - Diyanet API'den namaz vakitleri çekmek için
   - `sync-qibla-directions` - Kıble yönleri için

3. **Service Layer Hazır**:
   - SupabaseService
   - PrayerTimesService
   - FavoritesService
   - NotificationService
   - DeviceService

4. **Bildirim Sistemi Altyapısı**:
   - flutter_local_notifications entegrasyonu
   - Timezone desteği
   - Permission handling
   - Scheduled notification logic

5. **Dokümantasyon**:
   - QUICK_START.md - Hızlı başlangıç rehberi
   - PROJECT_STATUS.md - Detaylı proje durumu
   - SETUP.md - Kurulum talimatları
   - DIYANET_API_INTEGRATION.md - API entegrasyon rehberi

6. **Platform Hazırlıkları**:
   - Android permissions eklendi
   - iOS Info.plist güncellendi
   - .env yapılandırması

---

## 🎬 HEMEN ŞİMDİ YAPILACAKLAR

### 1. Environment Variables Ayarlama (2 dakika)

`.env` dosyası oluşturun ve şu bilgileri ekleyin:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
DIYANET_API_USERNAME=sizin_kullanici_adiniz
DIYANET_API_PASSWORD=sizin_sifreniz
```

**Nasıl Alınır:**
- **Supabase**: [supabase.com](https://supabase.com) > Settings > API
- **Diyanet API**: Size iletilmesi gereken credentials (veya API başvurusu)

---

### 2. Uygulamayı Test Edin (5 dakika)

```bash
flutter pub get
flutter run
```

**Test Edilecekler:**
- ✅ Tema değiştirme (çalışıyor olmalı)
- ✅ Zikirmatik (sayaç persistent)
- ✅ Takvim yaprağı (günler arası geçiş)
- ✅ Dini günler listesi

---

### 3. İlk Veri Sync'i (10 dakika)

Diyanet API credentials aldıktan sonra:

```bash
# Supabase Dashboard > Edge Functions > sync-prayer-times
# "Invoke" butonuna tıklayın

# Veya terminal'den:
curl -X POST \
  https://your-project-id.supabase.co/functions/v1/sync-prayer-times?city=İstanbul \
  -H "Authorization: Bearer YOUR_SUPABASE_ANON_KEY"
```

Bu komut:
- İstanbul için 30 günlük namaz vakitlerini çeker
- Database'e kaydeder
- Uygulamada gerçek veriler görünür

---

## 🔄 SONRASINDA YAPILACAKLAR (Öncelik Sırası)

### Öncelik 1: Real Data Integration (1-2 gün)

#### A. Prayer Times Service Integration
```dart
// lib/features/prayer_times/presentation/pages/prayer_times_page.dart
// Mock data yerine Supabase'den veri çekme
final prayerTimes = ref.watch(currentPrayerTimesProvider((
  'İstanbul',
  'Fatih',
  DateTime.now(),
)));
```

**Yapılacaklar:**
- [ ] Prayer times provider'ı UI'a bağla
- [ ] Current prayer detection logic
- [ ] Countdown timer real data ile
- [ ] Loading/error states

#### B. Location Service
```dart
// lib/core/services/location_service.dart oluştur
// Geolocator ile kullanıcı konumunu al
// Supabase'den en yakın şehir/ilçeyi bul
```

**Yapılacaklar:**
- [ ] Geolocator entegrasyonu
- [ ] Permission handling
- [ ] Reverse geocoding (koordinat → şehir/ilçe)
- [ ] Settings'e kaydet

---

### Öncelik 2: Notification Scheduling (1 gün)

```dart
// Her gün için namaz vakti bildirimleri oluştur
await NotificationService.schedulePrayerNotifications(
  prayerTimes: todaysPrayerTimes,
  date: DateTime.now(),
  enabledPrayers: userSettings.enabledPrayers,
  reminderMinutes: userSettings.reminderMinutes,
);
```

**Yapılacaklar:**
- [ ] Settings'ten bildirim ayarlarını oku
- [ ] Her gün için bildirimleri schedule et
- [ ] Fiziksel cihazda test
- [ ] Background task için daily refresh

---

### Öncelik 3: Favorites Integration (yarım gün)

```dart
// lib/features/home/presentation/widgets/calendar_leaf_card.dart
// Favori butonuna basılınca:
onPressed: () async {
  final service = await ref.read(favoritesServiceProvider.future);
  await service.toggleFavorite(
    type: ContentType.verse,
    contentId: contentId,
    contentData: {
      'content': dailyContent.verse,
      'source': dailyContent.verseSource,
    },
  );
  // UI refresh
  ref.invalidate(favoritesProvider);
}
```

**Yapılacaklar:**
- [ ] Favori butonu tap event
- [ ] Supabase'e kaydet/sil
- [ ] Optimistic UI update
- [ ] Favoriler sayfasında listeleme

---

### Öncelik 4: Qibla Sensor Integration (yarım gün)

```dart
// flutter_compass paketi ekle
// Sensor + Supabase kıble verisi birleştir
```

**Yapılacaklar:**
- [ ] flutter_compass ekle
- [ ] Permission handling
- [ ] Sensor data + database qibla degree birleştir
- [ ] Smooth compass rotation

---

### Öncelik 5: Sharing Feature (1 gün)

```dart
// Her içerik için görsel kart oluştur
// screenshot paketi ile
// share_plus ile paylaş
```

**Yapılacaklar:**
- [ ] Screenshot widget oluştur (ayet, hadis, vb. için)
- [ ] Tema renklerini kullan
- [ ] Social media optimize boyutlar
- [ ] Share button entegrasyonu

---

## 🚀 PRODUCTION HAZIRLIKLARI (Son Aşama)

### 1. App Icons & Splash Screen
- [ ] App icon tasarla (1024x1024)
- [ ] flutter_launcher_icons ile generate et
- [ ] Splash screen oluştur

### 2. App Store Assets
- [ ] Screenshots (iOS 6.5", 5.5" + iPad)
- [ ] Screenshots (Android phone, tablet, 7")
- [ ] App Store description (TR)
- [ ] Google Play description (TR)
- [ ] Privacy Policy
- [ ] Terms of Service

### 3. Testing
- [ ] iOS fiziksel cihaz testi
- [ ] Android fiziksel cihaz testi
- [ ] Bildirim testi (her vakit)
- [ ] Offline mode testi
- [ ] Performance profiling
- [ ] Beta test (TestFlight / Internal Testing)

### 4. Analytics & Monitoring
- [ ] Firebase Analytics ekle
- [ ] Crashlytics ekle
- [ ] Remote Config (feature flags)

---

## 💡 ÖNERİLER

### Hızlı Kazanımlar
1. **Diyanet API credentials** alın → gerçek veriler gelsin
2. **iOS TestFlight** için build alın → kullanıcı feedback
3. **Bildirim testi** yapın → en kritik özellik

### Öncelikli Değil Ama Güzel Olur
- Sesli ezan özelliği
- Dua koleksiyonu
- Kabe canlı yayını
- Namaz kılma rehberi (sesli/görsel)

---

## 📞 İhtiyacınız Olanlar

### 1. Diyanet API Credentials
**Acil**: Gerçek namaz vakitleri için gerekli
**Nereden**: [https://api.diyanet.gov.tr](https://api.diyanet.gov.tr) veya size iletilecek

### 2. Apple Developer Account
**Ne Zaman**: iOS App Store'a yüklemeden önce
**Maliyet**: $99/yıl

### 3. Google Play Console Account
**Ne Zaman**: Android Play Store'a yüklemeden önce
**Maliyet**: $25 (bir kerelik)

---

## ✅ Kontrol Listesi

Uygulamayı yayınlamadan önce:

- [ ] `.env` dosyası oluşturuldu
- [ ] Supabase projesi hazır
- [ ] Edge Functions deploy edildi (✅ zaten yapıldı)
- [ ] Diyanet API credentials alındı
- [ ] İlk veri sync'i tamamlandı
- [ ] Bildirimler test edildi
- [ ] Tema değiştirme çalışıyor (✅ çalışıyor)
- [ ] Zikirmatik persistent storage çalışıyor (✅ çalışıyor)
- [ ] iOS build alındı
- [ ] Android build alındı
- [ ] Privacy Policy hazır
- [ ] App Store screenshots hazır
- [ ] Beta test yapıldı

---

## 🎯 1 Haftalık Plan

| Gün | Görev | Süre |
|-----|-------|------|
| 1 | Diyanet API + İlk Sync | 2 saat |
| 2 | Prayer Times Real Data | 4 saat |
| 3 | Notification Scheduling | 4 saat |
| 4 | Location Service | 3 saat |
| 5 | Favorites Integration | 3 saat |
| 6 | Qibla Sensor + Sharing | 4 saat |
| 7 | Testing & Bug Fixes | 4 saat |

**Toplam:** ~24 saat → Production ready!

---

## 🏆 Başarı Kriterleri

Uygulama hazır sayılır:
1. ✅ Gerçek namaz vakitleri gösteriliyor
2. ✅ Bildirimler çalışıyor (test edildi)
3. ✅ Konum otomatik tespit ediliyor
4. ✅ Favoriler kaydediliyor
5. ✅ Paylaşım çalışıyor
6. ✅ iOS & Android build'ler hatasız
7. ✅ Beta testler olumlu

---

**Sonraki adım:** `.env` dosyasını oluşturun ve `flutter run` ile uygulamayı çalıştırın! 🚀

Sorularınız için hazırım! 😊
