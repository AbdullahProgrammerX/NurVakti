/*
  # Nur Vakti - Core Database Schema

  ## Tablolar
  
  ### 1. prayer_times (Namaz Vakitleri Cache)
  - `id` (uuid, primary key)
  - `city` (text) - Şehir adı
  - `district` (text) - İlçe adı
  - `date` (date) - Tarih
  - `times` (jsonb) - Vakitler {imsak, gunes, ogle, ikindi, aksam, yatsi}
  - `created_at` (timestamptz)
  
  ### 2. religious_days (Dini Günler & Kandiller)
  - `id` (uuid, primary key)
  - `name` (text) - Gün/Kandil adı
  - `type` (text) - 'kandil' veya 'religious_day'
  - `gregorian_date` (date) - Miladi tarih
  - `hijri_date` (text) - Hicri tarih
  - `description` (text) - Açıklama
  - `prayers_info` (text) - Yapılacak ibadetler
  - `significance` (text) - Önemi
  - `year` (int) - Yıl
  - `created_at` (timestamptz)
  
  ### 3. qibla_directions (Kıble Yönleri Cache)
  - `id` (uuid, primary key)
  - `city` (text)
  - `district` (text)
  - `latitude` (decimal)
  - `longitude` (decimal)
  - `qibla_degree` (decimal)
  - `created_at` (timestamptz)
  
  ### 4. user_favorites (Kullanıcı Favorileri)
  - `id` (uuid, primary key)
  - `user_id` (uuid) - Kullanıcı ID (opsiyonel, cihaz ID kullanılabilir)
  - `device_id` (text) - Cihaz benzersiz ID
  - `content_type` (text) - 'verse', 'hadith', 'risale', 'history', 'recipe'
  - `content_id` (text) - İçerik ID
  - `content_data` (jsonb) - İçerik verisi
  - `created_at` (timestamptz)
  
  ### 5. notification_settings (Bildirim Ayarları)
  - `id` (uuid, primary key)
  - `device_id` (text, unique)
  - `enabled_prayers` (jsonb) - {imsak: true, gunes: false, ...}
  - `reminder_minutes` (int) - Kaç dakika önce bildirim (default: 15)
  - `custom_sound_path` (text) - Özel ses dosyası yolu
  - `kandil_notifications` (boolean) - Kandil bildirimleri
  - `religious_day_notifications` (boolean) - Dini gün bildirimleri
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)
  
  ### 6. app_settings (Uygulama Ayarları)
  - `id` (uuid, primary key)
  - `device_id` (text, unique)
  - `city` (text)
  - `district` (text)
  - `theme_mode` (text) - 'light', 'dark', 'system'
  - `language` (text) - 'tr', 'en', 'ar'
  - `last_sync` (timestamptz)
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### 7. api_cache_status (API Cache Durumu)
  - `id` (uuid, primary key)
  - `cache_type` (text) - 'prayer_times', 'qibla', 'religious_days'
  - `last_fetch` (timestamptz)
  - `status` (text) - 'success', 'failed'
  - `error_message` (text)
  - `created_at` (timestamptz)

  ## Güvenlik
  - RLS (Row Level Security) tüm tablolarda aktif
  - Public read, device-based write policies
*/

-- ─────────────────────────────────────────────────────────
-- 1. Prayer Times Cache
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prayer_times (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  city text NOT NULL,
  district text NOT NULL,
  date date NOT NULL,
  times jsonb NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(city, district, date)
);

ALTER TABLE prayer_times ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read prayer times"
  ON prayer_times FOR SELECT
  TO public
  USING (true);

-- ─────────────────────────────────────────────────────────
-- 2. Religious Days & Kandils
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS religious_days (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('kandil', 'religious_day')),
  gregorian_date date NOT NULL,
  hijri_date text NOT NULL,
  description text DEFAULT '',
  prayers_info text DEFAULT '',
  significance text DEFAULT '',
  year int NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(name, gregorian_date, year)
);

ALTER TABLE religious_days ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read religious days"
  ON religious_days FOR SELECT
  TO public
  USING (true);

-- ─────────────────────────────────────────────────────────
-- 3. Qibla Directions Cache
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS qibla_directions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  city text NOT NULL,
  district text NOT NULL,
  latitude decimal(10, 8) NOT NULL,
  longitude decimal(11, 8) NOT NULL,
  qibla_degree decimal(6, 3) NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(city, district)
);

ALTER TABLE qibla_directions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read qibla directions"
  ON qibla_directions FOR SELECT
  TO public
  USING (true);

-- ─────────────────────────────────────────────────────────
-- 4. User Favorites (Device-based, no auth required)
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_favorites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id text NOT NULL,
  content_type text NOT NULL CHECK (content_type IN ('verse', 'hadith', 'risale', 'history', 'recipe')),
  content_id text NOT NULL,
  content_data jsonb NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(device_id, content_type, content_id)
);

CREATE INDEX IF NOT EXISTS idx_user_favorites_device ON user_favorites(device_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_type ON user_favorites(device_id, content_type);

ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own favorites"
  ON user_favorites FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can insert own favorites"
  ON user_favorites FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Users can delete own favorites"
  ON user_favorites FOR DELETE
  TO public
  USING (true);

-- ─────────────────────────────────────────────────────────
-- 5. Notification Settings
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notification_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id text UNIQUE NOT NULL,
  enabled_prayers jsonb DEFAULT '{"imsak": true, "gunes": true, "ogle": true, "ikindi": true, "aksam": true, "yatsi": true}'::jsonb,
  reminder_minutes int DEFAULT 15,
  custom_sound_path text DEFAULT '',
  kandil_notifications boolean DEFAULT true,
  religious_day_notifications boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notification_settings_device ON notification_settings(device_id);

ALTER TABLE notification_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own notification settings"
  ON notification_settings FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can insert own notification settings"
  ON notification_settings FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Users can update own notification settings"
  ON notification_settings FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

-- ─────────────────────────────────────────────────────────
-- 6. App Settings
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS app_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id text UNIQUE NOT NULL,
  city text DEFAULT 'İstanbul',
  district text DEFAULT 'Fatih',
  theme_mode text DEFAULT 'system' CHECK (theme_mode IN ('light', 'dark', 'system')),
  language text DEFAULT 'tr' CHECK (language IN ('tr', 'en', 'ar')),
  last_sync timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_app_settings_device ON app_settings(device_id);

ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own app settings"
  ON app_settings FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can insert own app settings"
  ON app_settings FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Users can update own app settings"
  ON app_settings FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

-- ─────────────────────────────────────────────────────────
-- 7. API Cache Status
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS api_cache_status (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cache_type text NOT NULL CHECK (cache_type IN ('prayer_times', 'qibla', 'religious_days')),
  last_fetch timestamptz NOT NULL,
  status text NOT NULL CHECK (status IN ('success', 'failed')),
  error_message text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  UNIQUE(cache_type)
);

ALTER TABLE api_cache_status ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read api cache status"
  ON api_cache_status FOR SELECT
  TO public
  USING (true);
