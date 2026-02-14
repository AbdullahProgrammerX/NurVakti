import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Dini Günler & Kandiller Sayfası
class ReligiousDaysPage extends StatelessWidget {
  const ReligiousDaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dini Günler & Kandiller',
          style: NurTextStyles.headlineSmall(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? NurColors.darkCalendarHeaderGradient
                : NurColors.calendarHeaderGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [NurColors.darkBackground, const Color(0xFF0A1220)]
                : [NurColors.lightBackground, const Color(0xFFF5EDE0)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _religiousDays.length,
          itemBuilder: (context, index) {
            final day = _religiousDays[index];
            return _buildReligiousDayCard(context, isDark, day, index);
          },
        ),
      ),
    );
  }

  Widget _buildReligiousDayCard(
      BuildContext context, bool isDark, Map<String, String> day, int index) {
    final isKandil = day['type'] == 'kandil';
    final accentColor = isKandil ? NurColors.gold : NurColors.emerald;

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
          onTap: () {
            _showDetailDialog(context, isDark, day);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // İkon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isKandil ? '🕯️' : '🌙',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 14),

                // Bilgi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day['name']!,
                        style: NurTextStyles.labelLarge(
                          color: isDark ? NurColors.darkText : NurColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day['hijriDate']}',
                        style: NurTextStyles.bodySmall(
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tarih
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      day['date']!,
                      style: NurTextStyles.labelMedium(
                        color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isKandil ? 'Kandil' : 'Dini Gün',
                        style: NurTextStyles.labelSmall(color: accentColor),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, bool isDark, Map<String, String> day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? NurColors.darkCard : NurColors.lightCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? NurColors.darkDivider : NurColors.lightDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                day['name']!,
                style: NurTextStyles.headlineMedium(
                  color: isDark ? NurColors.darkText : NurColors.lightText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${day['date']} • ${day['hijriDate']}',
                style: NurTextStyles.bodyMedium(color: NurColors.gold),
              ),
              const SizedBox(height: 16),

              Text(
                day['description'] ?? 'Bu mübarek gün hakkında detaylı bilgi yakında eklenecektir.',
                style: NurTextStyles.bodyMedium(
                  color: isDark ? NurColors.darkText : NurColors.lightText,
                ),
              ),
              const SizedBox(height: 24),

              if (day['ibadetler'] != null) ...[
                Text(
                  'Yapılabilecek İbadetler',
                  style: NurTextStyles.labelLarge(
                    color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  day['ibadetler']!,
                  style: NurTextStyles.bodyMedium(
                    color: isDark ? NurColors.darkText : NurColors.lightText,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Mock dini günler verileri
const List<Map<String, String>> _religiousDays = [
  {
    'name': 'Mevlid Kandili',
    'date': '14 Eylül 2026',
    'hijriDate': '12 Rebiülevvel 1448',
    'type': 'kandil',
    'description': 'Peygamber Efendimiz Hz. Muhammed (s.a.v.)\'in dünyaya teşrif ettikleri gecedir.',
    'ibadetler': '• Kur\'an-ı Kerim okunması\n• Salâvat-ı şerife\n• Nafile namaz kılınması\n• Dua ve istiğfar',
  },
  {
    'name': 'Regaip Kandili',
    'date': '22 Ocak 2027',
    'hijriDate': '1 Recep 1448',
    'type': 'kandil',
    'description': 'Üç ayların başlangıcıdır. Hz. Peygamber\'in anne rahmine düştüğü gecedir.',
    'ibadetler': '• Kur\'an-ı Kerim okunması\n• Nafile namaz kılınması\n• Oruç tutulması\n• Dua ve istiğfar',
  },
  {
    'name': 'Miraç Kandili',
    'date': '11 Şubat 2027',
    'hijriDate': '27 Recep 1448',
    'type': 'kandil',
    'description': 'Hz. Peygamber\'in göklere yükseldiği; İsra ve Miraç mucizesinin gerçekleştiği gecedir.',
    'ibadetler': '• Kur\'an-ı Kerim okunması\n• Nafile namaz kılınması\n• Dua ve istiğfar\n• Salâvat-ı şerife',
  },
  {
    'name': 'Berat Kandili',
    'date': '26 Şubat 2027',
    'hijriDate': '15 Şaban 1448',
    'type': 'kandil',
    'description': 'Kulların bir yıl içinde işleyecekleri amellerin ve rızıklarının takdir edildiği gecedir.',
    'ibadetler': '• Kur\'an-ı Kerim okunması\n• Nafile namaz kılınması\n• Oruç tutulması\n• Tövbe ve istiğfar',
  },
  {
    'name': 'Ramazan Başlangıcı',
    'date': '13 Mart 2027',
    'hijriDate': '1 Ramazan 1448',
    'type': 'dini_gun',
    'description': 'Ramazan-ı Şerif ayının başlangıcıdır. Oruç ibadeti bu ayda farz kılınmıştır.',
    'ibadetler': '• Oruç tutmak\n• Teravih namazı\n• Kur\'an-ı Kerim hatmi\n• Sadaka vermek',
  },
  {
    'name': 'Kadir Gecesi',
    'date': '7 Nisan 2027',
    'hijriDate': '27 Ramazan 1448',
    'type': 'kandil',
    'description': 'Kur\'an-ı Kerim\'in indirilmeye başlandığı, bin aydan hayırlı olan gecedir.',
    'ibadetler': '• Kur\'an-ı Kerim okunması\n• Nafile namaz kılınması\n• "Allahümme inneke afüvvün..." duası\n• İtikâf',
  },
  {
    'name': 'Ramazan Bayramı',
    'date': '12 Nisan 2027',
    'hijriDate': '1 Şevval 1448',
    'type': 'dini_gun',
    'description': 'Ramazan ayının sona ermesiyle kutlanan, üç gün süren bayramdır.',
    'ibadetler': '• Bayram namazı\n• Fitır sadakası\n• Akraba ve komşu ziyareti\n• Bayramlaşma',
  },
  {
    'name': 'Kurban Bayramı',
    'date': '19 Haziran 2027',
    'hijriDate': '10 Zilhicce 1448',
    'type': 'dini_gun',
    'description': 'Hz. İbrahim\'in oğlu İsmail\'i kurban etme hadisesinin anısına kutlanan bayramdır.',
    'ibadetler': '• Bayram namazı\n• Kurban kesmek\n• Akraba ziyareti\n• Pay dağıtmak',
  },
];
