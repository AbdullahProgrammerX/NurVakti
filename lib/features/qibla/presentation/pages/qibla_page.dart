import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Kıble Bulucu Sayfası
class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  final double _qiblaDirection = 153.5; // İstanbul'dan Kabe'ye derece (mock)

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kabe ikonu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NurColors.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mosque_rounded,
                size: 32,
                color: NurColors.gold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'KIBLE YÖNÜ',
              style: NurTextStyles.labelLarge(
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ).copyWith(letterSpacing: 3),
            ),
            const SizedBox(height: 32),

            // ─── Pusula ───
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dış halka
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isDark
                            ? [NurColors.darkCard, NurColors.darkSurface]
                            : [NurColors.lightCard, const Color(0xFFF0E8DC)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: NurColors.gold.withValues(alpha: 0.3),
                        width: 3,
                      ),
                    ),
                  ),

                  // Yön etiketleri
                  _buildDirectionLabel('K', 0, isDark),
                  _buildDirectionLabel('D', 90, isDark),
                  _buildDirectionLabel('G', 180, isDark),
                  _buildDirectionLabel('B', 270, isDark),

                  // Kıble iğnesi
                  Transform.rotate(
                    angle: _qiblaDirection * (pi / 180),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigation_rounded,
                          size: 48,
                          color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),

                  // Merkez nokta
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: NurColors.gold,
                      boxShadow: [
                        BoxShadow(
                          color: NurColors.gold.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Derece bilgisi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? NurColors.darkCard : NurColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                '${_qiblaDirection.toStringAsFixed(1)}°',
                style: NurTextStyles.headlineLarge(
                  color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Pusula sensörü için cihazınızı düz tutun',
              style: NurTextStyles.bodySmall(
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionLabel(String letter, double angle, bool isDark) {
    return Transform.rotate(
      angle: angle * (pi / 180),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 230),
        child: Transform.rotate(
          angle: -angle * (pi / 180),
          child: Text(
            letter,
            style: NurTextStyles.labelLarge(
              color: letter == 'K'
                  ? NurColors.error
                  : (isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
