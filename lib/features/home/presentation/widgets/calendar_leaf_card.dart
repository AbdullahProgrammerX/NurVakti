import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../data/daily_content_provider.dart';

/// Takvim Yaprağı Kartı
class CalendarLeafCard extends ConsumerWidget {
  final DateTime date;
  final bool isToday;

  const CalendarLeafCard({
    super.key,
    required this.date,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyContent = ref.watch(dailyContentProvider(date));
    final hijri = HijriCalendar.fromDate(date);

    final dayName = DateFormat('EEEE', 'tr_TR').format(date);
    final monthName = DateFormat('MMMM', 'tr_TR').format(date);
    final dayNumber = date.day.toString();
    final year = date.year.toString();

    // Hicri tarih
    final hijriMonths = [
      '', 'Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir',
      'Cemaziyelevvel', 'Cemaziyelahir', 'Recep', 'Şaban',
      'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce'
    ];
    final hijriText = '${hijri.hDay} ${hijriMonths[hijri.hMonth]} ${hijri.hYear}';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ─── Tarih Başlığı ───
          _buildDateHeader(
            context, isDark, dayName, dayNumber, monthName, year, hijriText,
          ),

          const SizedBox(height: 16),

          // ─── Günün Ayeti ───
          _buildContentCard(
            context,
            isDark,
            icon: Icons.menu_book_rounded,
            title: 'Günün Ayeti',
            content: dailyContent.verse,
            source: dailyContent.verseSource,
            accentColor: NurColors.emerald,
            contentId: 'verse_${date.toIso8601String()}',
          ),

          // ─── Günün Hadisi ───
          _buildContentCard(
            context,
            isDark,
            icon: Icons.mosque_rounded,
            title: 'Günün Hadisi',
            content: dailyContent.hadith,
            source: dailyContent.hadithSource,
            accentColor: NurColors.gold,
            contentId: 'hadith_${date.toIso8601String()}',
          ),

          // ─── Risale-i Nur Vecizesi ───
          _buildContentCard(
            context,
            isDark,
            icon: Icons.auto_stories_rounded,
            title: 'Risale-i Nur\'dan',
            content: dailyContent.risaleQuote,
            source: dailyContent.risaleSource,
            accentColor: const Color(0xFF8B4513),
            contentId: 'risale_${date.toIso8601String()}',
          ),

          // ─── Tarihte Bugün ───
          _buildContentCard(
            context,
            isDark,
            icon: Icons.history_rounded,
            title: 'Tarihte Bugün',
            content: dailyContent.historyToday,
            source: dailyContent.historyYear,
            accentColor: const Color(0xFF5C6BC0),
            contentId: 'history_${date.toIso8601String()}',
          ),

          // ─── Günlük Yemek Önerisi ───
          _buildContentCard(
            context,
            isDark,
            icon: Icons.restaurant_rounded,
            title: 'Akşam Yemeği Önerisi',
            content: dailyContent.recipe,
            source: dailyContent.recipeDetail,
            accentColor: const Color(0xFFE57373),
            contentId: 'recipe_${date.toIso8601String()}',
          ),

          const SizedBox(height: 24),

          // ─── Kaydırma İpucu ───
          if (isToday)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe_rounded,
                    size: 16,
                    color: isDark
                        ? NurColors.darkTextSecondary
                        : NurColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sola / sağa kaydırarak günleri değiştirin',
                    style: NurTextStyles.bodySmall(
                      color: isDark
                          ? NurColors.darkTextSecondary
                          : NurColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(
    BuildContext context,
    bool isDark,
    String dayName,
    String dayNumber,
    String monthName,
    String year,
    String hijriText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
          // Gün adı
          Text(
            dayName.toUpperCase(),
            style: NurTextStyles.labelLarge(
              color: Colors.white.withValues(alpha: 0.8),
            ).copyWith(letterSpacing: 4),
          ),
          const SizedBox(height: 4),

          // Gün numarası
          Text(
            dayNumber,
            style: NurTextStyles.dateDay(color: Colors.white),
          ),
          const SizedBox(height: 4),

          // Ay yıl
          Text(
            '$monthName $year'.toUpperCase(),
            style: NurTextStyles.dateMonth(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),

          // Hicri tarih
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NurColors.goldShimmer.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.nightlight_round,
                  size: 16,
                  color: NurColors.goldShimmer,
                ),
                const SizedBox(width: 8),
                Text(
                  hijriText,
                  style: NurTextStyles.hijriDate(
                    color: NurColors.goldShimmer,
                  ),
                ),
              ],
            ),
          ),

          if (isToday) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: NurColors.goldShimmer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'BUGÜN',
                style: NurTextStyles.labelSmall(
                  color: NurColors.goldShimmer,
                ).copyWith(letterSpacing: 2),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String content,
    required String source,
    required Color accentColor,
    required String contentId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? NurColors.darkCard : NurColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık satırı
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 20, color: accentColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: NurTextStyles.labelLarge(
                          color: isDark ? NurColors.darkText : NurColors.lightText,
                        ),
                      ),
                    ),
                    // Favori + Paylaş
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border_rounded,
                        size: 20,
                        color: isDark
                            ? NurColors.darkTextSecondary
                            : NurColors.lightTextSecondary,
                      ),
                      onPressed: () {
                        // TODO: Favori ekle
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(
                        Icons.share_rounded,
                        size: 20,
                        color: isDark
                            ? NurColors.darkTextSecondary
                            : NurColors.lightTextSecondary,
                      ),
                      onPressed: () {
                        // TODO: Paylaş
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // İçerik
                Text(
                  content,
                  style: NurTextStyles.bodyMedium(
                    color: isDark ? NurColors.darkText : NurColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),

                // Kaynak
                Text(
                  source,
                  style: NurTextStyles.labelSmall(
                    color: accentColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
