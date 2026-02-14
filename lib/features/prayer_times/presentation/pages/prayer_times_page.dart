import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Namaz Vakitleri Sayfası
class PrayerTimesPage extends ConsumerStatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  ConsumerState<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends ConsumerState<PrayerTimesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  // Mock namaz vakitleri (backend bağlandığında güncellenecek)
  final List<Map<String, String>> _prayerTimes = [
    {'name': 'İmsak', 'time': '05:48', 'icon': '🌙'},
    {'name': 'Güneş', 'time': '07:18', 'icon': '🌅'},
    {'name': 'Öğle', 'time': '12:28', 'icon': '☀️'},
    {'name': 'İkindi', 'time': '15:16', 'icon': '🌤'},
    {'name': 'Akşam', 'time': '17:28', 'icon': '🌇'},
    {'name': 'Yatsı', 'time': '18:50', 'icon': '🌃'},
  ];

  final int _currentPrayerIndex = 2; // Şu anki vakit (mock)

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [NurColors.darkBackground, const Color(0xFF0A1220)]
              : [NurColors.lightBackground, const Color(0xFFF5EDE0)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ─── Konum Seçimi ───
            _buildLocationBar(isDark),
            const SizedBox(height: 20),

            // ─── Geri Sayım ───
            _buildCountdownCard(isDark),
            const SizedBox(height: 20),

            // ─── Vakit Listesi ───
            ..._prayerTimes.asMap().entries.map(
                  (entry) => _buildPrayerTimeRow(
                isDark,
                entry.value,
                entry.key == _currentPrayerIndex,
                entry.key < _currentPrayerIndex,
                entry.key,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? NurColors.darkCard : NurColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            color: NurColors.gold,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'İstanbul, Türkiye',
                  style: NurTextStyles.labelLarge(
                    color: isDark ? NurColors.darkText : NurColors.lightText,
                  ),
                ),
                Text(
                  'Fatih İlçesi',
                  style: NurTextStyles.bodySmall(
                    color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit_location_alt_rounded,
              color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
            ),
            onPressed: () {
              // TODO: Konum seçimi
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark
            ? NurColors.darkPrimaryGradient
            : NurColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                .withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Bir Sonraki Vakit',
            style: NurTextStyles.labelMedium(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'İKİNDİ',
            style: NurTextStyles.headlineMedium(
              color: NurColors.goldShimmer,
            ).copyWith(letterSpacing: 3),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.7 + (_animController.value * 0.3),
                child: Text(
                  '02:48:15',
                  style: NurTextStyles.prayerCountdown(color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            'kalan süre',
            style: NurTextStyles.bodySmall(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeRow(
      bool isDark,
      Map<String, String> prayer,
      bool isCurrent,
      bool isPassed,
      int index,
      ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrent
            ? (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
            .withValues(alpha: 0.12)
            : isDark
            ? NurColors.darkCard
            : NurColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: isCurrent
            ? Border.all(
          color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
          width: 1.5,
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji ikon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(prayer['icon']!, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),

          // Vakit adı
          Expanded(
            child: Text(
              prayer['name']!,
              style: NurTextStyles.labelLarge(
                color: isPassed
                    ? (isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary)
                    : (isDark ? NurColors.darkText : NurColors.lightText),
              ),
            ),
          ),

          // Saat
          Text(
            prayer['time']!,
            style: NurTextStyles.prayerTime(
              color: isCurrent
                  ? (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                  : isPassed
                  ? (isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary)
                  : (isDark ? NurColors.darkText : NurColors.lightText),
            ),
          ),

          // Bildirim ikonu
          const SizedBox(width: 10),
          Icon(
            Icons.notifications_active_rounded,
            size: 18,
            color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }
}
