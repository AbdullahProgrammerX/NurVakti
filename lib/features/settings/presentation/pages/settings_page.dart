import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../app/theme/theme_provider.dart';

/// Ayarlar Sayfası
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayarlar',
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── Konum Ayarları ───
            _buildSectionTitle(isDark, 'Konum Ayarları'),
            _buildSettingCard(
              isDark,
              icon: Icons.location_on_rounded,
              title: 'Konum',
              subtitle: 'İstanbul, Fatih',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
              onTap: () {
                // TODO: Konum seçimi
              },
            ),

            const SizedBox(height: 20),

            // ─── Bildirim Ayarları ───
            _buildSectionTitle(isDark, 'Bildirim Ayarları'),
            _buildSettingCard(
              isDark,
              icon: Icons.notifications_rounded,
              title: 'Ezan Bildirimleri',
              subtitle: 'Tüm vakitler açık',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Bildirim ayarı
                },
                activeColor: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
              ),
            ),
            _buildSettingCard(
              isDark,
              icon: Icons.timer_rounded,
              title: 'Erken Bildirim',
              subtitle: '15 dakika önce',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
              onTap: () {},
            ),
            _buildSettingCard(
              isDark,
              icon: Icons.music_note_rounded,
              title: 'Bildirim Sesi',
              subtitle: 'Varsayılan ezan',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
              onTap: () {},
            ),
            _buildSettingCard(
              isDark,
              icon: Icons.event_rounded,
              title: 'Kandil Bildirimleri',
              subtitle: 'Açık',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
              ),
            ),

            const SizedBox(height: 20),

            // ─── Tema Ayarları ───
            _buildSectionTitle(isDark, 'Tema Ayarları'),
            _buildSettingCard(
              isDark,
              icon: Icons.dark_mode_rounded,
              title: 'Koyu Tema',
              subtitle: themeMode == ThemeMode.dark ? 'Aktif' : 'Pasif',
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                activeColor: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
              ),
            ),

            const SizedBox(height: 20),

            // ─── Genel ───
            _buildSectionTitle(isDark, 'Genel'),
            _buildSettingCard(
              isDark,
              icon: Icons.language_rounded,
              title: 'Dil',
              subtitle: 'Türkçe',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
              onTap: () {},
            ),
            _buildSettingCard(
              isDark,
              icon: Icons.info_outline_rounded,
              title: 'Hakkında',
              subtitle: 'Nur Vakti v1.0.0',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
              onTap: () {
                _showAboutDialog(context, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: NurTextStyles.labelLarge(
          color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingCard(
      bool isDark, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget trailing,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? NurColors.darkCard : NurColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: NurTextStyles.labelLarge(
                          color: isDark ? NurColors.darkText : NurColors.lightText,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: NurTextStyles.bodySmall(
                          color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? NurColors.darkCard : NurColors.lightCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Nur Vakti',
            style: NurTextStyles.headlineMedium(
              color: isDark ? NurColors.darkText : NurColors.lightText,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'İslami Yaşam Uygulaması',
                style: NurTextStyles.bodyMedium(
                  color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Versiyon 1.0.0\n\nNamaz vakitleri, zikirmatik, günlük dini içerikler ve daha fazlası...\n\nDini hassasiyetlere uygun, modern ve güvenilir.',
                style: NurTextStyles.bodySmall(
                  color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tamam',
                style: NurTextStyles.labelLarge(
                  color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
