# 🕌 Diyanet API Entegrasyonu

## 📚 Genel Bakış

Diyanet İşleri Başkanlığı API'si üzerinden namaz vakitleri, kıble yönleri ve dini günler verilerini alıyoruz. API istek limitleri nedeniyle **akıllı cache stratejisi** kullanıyoruz.

## 🏗️ Mimari

```
┌─────────────────┐
│  Mobile App     │
│  (100K users)   │
└────────┬────────┘
         │ 1. Cache'ten oku
         ▼
┌─────────────────┐
│  Supabase       │
│  PostgreSQL     │ ◄─── 2. Cache yoksa Edge Function tetikle
└────────┬────────┘
         │ 3. Aylık scheduled job
         ▼
┌─────────────────┐
│  Edge Function  │
│  (Proxy)        │
└────────┬────────┘
         │ 4. API çağrısı (ayda 1 kez)
         ▼
┌─────────────────┐
│  Diyanet API    │
│  (Limit: düşük) │
└─────────────────┘
```

### Avantajlar

1. **API Limit Aşımı Yok**: Ayda sadece 1 kez API çağrısı
2. **Hızlı Response**: Cache'ten milisaniyeler içinde okuma
3. **Offline Destek**: Cache sayesinde internet olmadan da çalışır
4. **Maliyet Düşük**: Minimum API kullanımı
5. **Ölçeklenebilir**: 1M kullanıcı bile desteklenebilir

## 🔑 API Bilgileri

### Base URL
```
https://api.diyanet.gov.tr/api
```

### Authentication
```
Username: [KULLANICI_ADI]
Password: [ŞİFRE]
```

### Endpoints

#### 1. Namaz Vakitleri
```
GET /PrayerTime/Daily/{ilce_id}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "Imsak": "05:48",
    "Gunes": "07:18",
    "Ogle": "12:28",
    "Ikindi": "15:16",
    "Aksam": "17:28",
    "Yatsi": "18:50",
    "KibleSaati": "11:28",
    "MiladiTarih": "14.03.2026",
    "HicriTarih": "15 Ramazan 1448"
  }
}
```

#### 2. Şehir Listesi
```
GET /PrayerTime/Cities
```

#### 3. İlçe Listesi
```
GET /PrayerTime/Districts/{sehir_id}
```

#### 4. Kıble Yönü
```
GET /Qibla/QiblaInfo/{ilce_id}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "QiblaDegree": 153.5,
    "Latitude": 41.0082,
    "Longitude": 28.9784
  }
}
```

## 🔄 Cache Stratejisi

### 1. Initial Sync (İlk Yükleme)

Uygulama ilk açıldığında:
```dart
// 1. Yerel cache'i kontrol et
final cachedData = await prayerTimesService.getPrayerTimes(
  city: 'İstanbul',
  district: 'Fatih',
  date: DateTime.now(),
);

// 2. Cache yoksa veya eski ise Supabase'den çek
if (cachedData == null || isCacheExpired(cachedData)) {
  final freshData = await supabase
    .from('prayer_times')
    .select()
    .eq('city', 'İstanbul')
    .eq('district', 'Fatih')
    .eq('date', today);

  // 3. Yerel cache'e kaydet
  await hive.put('prayer_times_$today', freshData);
}
```

### 2. Monthly Scheduled Job (Aylık Güncelletme)

Supabase Edge Function ile aylık otomatik güncelleme:

```typescript
// supabase/functions/sync-prayer-times/index.ts
Deno.serve(async (req) => {
  // 1. Türkiye'deki tüm şehir/ilçeler için veri çek
  const cities = await getDiyanetCities();

  for (const city of cities) {
    const districts = await getDiyanetDistricts(city.id);

    for (const district of districts) {
      // 2. Gelecek 30 günün namaz vakitlerini çek
      const prayerTimes = await getDiyanetPrayerTimes(
        district.id,
        startDate,
        endDate
      );

      // 3. Supabase'e kaydet
      await supabase.from('prayer_times').upsert(prayerTimes);
    }
  }

  return new Response('Sync completed');
});
```

### 3. Cron Job Setup (Supabase)

Supabase Dashboard > Database > Cron Jobs:

```sql
SELECT cron.schedule(
  'sync-prayer-times',
  '0 0 1 * *', -- Her ayın 1'inde gece 00:00
  $$
  SELECT
    net.http_post(
      url := 'https://your-project.supabase.co/functions/v1/sync-prayer-times',
      headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
    ) AS request_id;
  $$
);
```

## 📦 Edge Function Implementasyonu

### Dosya Yapısı
```
supabase/
├── functions/
│   ├── sync-prayer-times/
│   │   └── index.ts
│   ├── sync-qibla-directions/
│   │   └── index.ts
│   └── sync-religious-days/
│       └── index.ts
```

### sync-prayer-times/index.ts

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

interface DiyanetAuthResponse {
  token: string;
}

interface DiyanetPrayerTimeResponse {
  success: boolean;
  data: {
    Imsak: string;
    Gunes: string;
    Ogle: string;
    Ikindi: string;
    Aksam: string;
    Yatsi: string;
    MiladiTarih: string;
    HicriTarih: string;
  };
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    // 1. Diyanet API Login
    const authResponse = await fetch('https://api.diyanet.gov.tr/api/Auth/Login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: Deno.env.get('DIYANET_API_USERNAME'),
        password: Deno.env.get('DIYANET_API_PASSWORD'),
      }),
    });

    const authData: DiyanetAuthResponse = await authResponse.json();
    const token = authData.token;

    // 2. İstanbul/Fatih için örnek veri çek (tüm şehirler için loop yapılabilir)
    const districtId = 9541; // İstanbul/Fatih
    const startDate = new Date();
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + 30); // 30 gün

    const prayerTimesData = [];

    for (let d = new Date(startDate); d <= endDate; d.setDate(d.getDate() + 1)) {
      const dateStr = d.toISOString().split('T')[0];

      const response = await fetch(
        `https://api.diyanet.gov.tr/api/PrayerTime/Daily/${districtId}?date=${dateStr}`,
        {
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        }
      );

      const data: DiyanetPrayerTimeResponse = await response.json();

      if (data.success) {
        prayerTimesData.push({
          city: 'İstanbul',
          district: 'Fatih',
          date: dateStr,
          times: {
            imsak: data.data.Imsak,
            gunes: data.data.Gunes,
            ogle: data.data.Ogle,
            ikindi: data.data.Ikindi,
            aksam: data.data.Aksam,
            yatsi: data.data.Yatsi,
          },
        });
      }

      // Rate limiting (saniyede 1 istek)
      await new Promise(resolve => setTimeout(resolve, 1000));
    }

    // 3. Supabase'e kaydet
    const { error } = await supabase
      .from('prayer_times')
      .upsert(prayerTimesData, {
        onConflict: 'city,district,date',
      });

    if (error) throw error;

    return new Response(
      JSON.stringify({
        success: true,
        message: `${prayerTimesData.length} prayer times synced`,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
```

## 🎯 Mobile App Kullanımı

### Prayer Times Service

```dart
// lib/core/services/prayer_times_repository.dart
class PrayerTimesRepository {
  final SupabaseClient _supabase;
  final Box _hiveBox;

  Future<PrayerTimeModel?> getTodaysPrayerTimes({
    required String city,
    required String district,
  }) async {
    final today = DateTime.now();
    final cacheKey = 'prayer_${city}_${district}_${_formatDate(today)}';

    // 1. Local cache kontrol
    final cached = _hiveBox.get(cacheKey);
    if (cached != null) {
      return PrayerTimeModel.fromJson(cached);
    }

    // 2. Supabase'den çek
    final data = await _supabase
      .from('prayer_times')
      .select()
      .eq('city', city)
      .eq('district', district)
      .eq('date', _formatDate(today))
      .maybeSingle();

    if (data != null) {
      // 3. Local cache'e kaydet (24 saat)
      await _hiveBox.put(cacheKey, data);
      return PrayerTimeModel.fromJson(data);
    }

    return null;
  }
}
```

## 🔐 Güvenlik

### Environment Variables

Edge Function'larda şifreler environment variable olarak:

```bash
supabase secrets set DIYANET_API_USERNAME=your_username
supabase secrets set DIYANET_API_PASSWORD=your_password
```

### RLS Policies

```sql
-- Public read, service role write
CREATE POLICY "Anyone can read prayer times"
  ON prayer_times FOR SELECT
  TO public
  USING (true);

-- Sadece Edge Function yazabilir (service role)
CREATE POLICY "Service role can write"
  ON prayer_times FOR INSERT
  TO service_role
  WITH CHECK (true);
```

## 📊 Monitoring & Logs

### Supabase Dashboard

- **Database > Tables**: prayer_times tablosundaki kayıt sayısı
- **Functions > Logs**: Edge Function çalışma logları
- **Database > Cron Jobs**: Scheduled job durumu

### Error Handling

```typescript
// api_cache_status tablosuna log kaydet
await supabase.from('api_cache_status').insert({
  cache_type: 'prayer_times',
  last_fetch: new Date().toISOString(),
  status: error ? 'failed' : 'success',
  error_message: error?.message || '',
});
```

## 🚀 Deployment

### 1. Edge Functions Deploy

```bash
supabase functions deploy sync-prayer-times
supabase functions deploy sync-qibla-directions
supabase functions deploy sync-religious-days
```

### 2. Secrets Ayarla

```bash
supabase secrets set DIYANET_API_USERNAME=your_username
supabase secrets set DIYANET_API_PASSWORD=your_password
```

### 3. Cron Job Aktifleştir

Supabase Dashboard > Database > SQL Editor'da cron job SQL'ini çalıştır.

### 4. İlk Sync'i Manuel Tetikle

```bash
curl -X POST \
  https://your-project.supabase.co/functions/v1/sync-prayer-times \
  -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY"
```

## 📈 Scalability

Bu mimari ile desteklenebilir:

- **100K kullanıcı**: ✅ Kolayca
- **1M kullanıcı**: ✅ Sorunsuz
- **10M kullanıcı**: ✅ Supabase plan upgrade gerekebilir

API çağrısı ayda sadece 1 kez yapıldığı için, kullanıcı sayısı API limitlerini etkilemez.

## 🔄 Fallback Strategy

Eğer Supabase cache'i boşsa:

1. **Local Hive Cache**: Son 7 günün verisi
2. **Hardcoded Data**: Acil durumlar için İstanbul vakitleri
3. **User Notification**: "Lütfen internet bağlantınızı kontrol edin"

## 📝 TODO

- [ ] Tüm şehir/ilçeler için sync (şu an sadece İstanbul/Fatih)
- [ ] Hata durumunda retry mechanism
- [ ] Cache invalidation stratejisi
- [ ] Performance metrics
- [ ] A/B testing farklı cache duration'ları

## 🆘 Troubleshooting

### Problem: Cache boş
**Çözüm**: Edge Function'ı manuel tetikle

### Problem: API limit aşımı
**Çözüm**: Cron job frequency'yi kontrol et (ayda 1 olmalı)

### Problem: Yanlış veri
**Çözüm**: Cache'i temizle ve yeniden sync et

```sql
DELETE FROM prayer_times WHERE date < CURRENT_DATE;
```
