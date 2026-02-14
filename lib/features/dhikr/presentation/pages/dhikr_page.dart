import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Zikir listesi provider
final selectedDhikrProvider = StateProvider<int>((ref) => 0);

/// Zikir verileri
class DhikrItem {
  final String name;
  final String arabic;
  final String meaning;
  final int targetCount;

  const DhikrItem({
    required this.name,
    required this.arabic,
    required this.meaning,
    required this.targetCount,
  });
}

const List<DhikrItem> dhikrList = [
  DhikrItem(
    name: 'Sübhanallah',
    arabic: 'سُبْحَانَ اللَّهِ',
    meaning: 'Allah\'ı tüm noksanlıklardan tenzih ederim',
    targetCount: 33,
  ),
  DhikrItem(
    name: 'Elhamdülillah',
    arabic: 'الْحَمْدُ لِلَّهِ',
    meaning: 'Hamd Allah\'a mahsustur',
    targetCount: 33,
  ),
  DhikrItem(
    name: 'Allahu Ekber',
    arabic: 'اللَّهُ أَكْبَرُ',
    meaning: 'Allah en büyüktür',
    targetCount: 33,
  ),
  DhikrItem(
    name: 'Lâ ilâhe illallah',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    meaning: 'Allah\'tan başka ilah yoktur',
    targetCount: 100,
  ),
  DhikrItem(
    name: 'Estağfirullah',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    meaning: 'Allah\'tan bağışlanma dilerim',
    targetCount: 100,
  ),
  DhikrItem(
    name: 'Salavat',
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    meaning: 'Allah\'ım, Muhammed\'e salât et',
    targetCount: 100,
  ),
];

/// Zikirmatik Sayfası
class DhikrPage extends ConsumerStatefulWidget {
  const DhikrPage({super.key});

  @override
  ConsumerState<DhikrPage> createState() => _DhikrPageState();
}

class _DhikrPageState extends ConsumerState<DhikrPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  late Box _dhikrBox;
  int _count = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _dhikrBox = Hive.box('dhikr');

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _loadCounts();
  }

  void _loadCounts() {
    final selectedIndex = ref.read(selectedDhikrProvider);
    _count = _dhikrBox.get('dhikr_count_$selectedIndex', defaultValue: 0) as int;
    _totalCount = _dhikrBox.get('dhikr_total_$selectedIndex', defaultValue: 0) as int;
  }

  void _increment() {
    final selectedIndex = ref.read(selectedDhikrProvider);
    setState(() {
      _count++;
      _totalCount++;
    });

    // Kaydet
    _dhikrBox.put('dhikr_count_$selectedIndex', _count);
    _dhikrBox.put('dhikr_total_$selectedIndex', _totalCount);

    // Animasyon
    _pulseController.forward().then((_) => _pulseController.reverse());
    _rippleController.forward(from: 0);

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Hedef sayıya ulaşıldı mı?
    if (_count == dhikrList[selectedIndex].targetCount) {
      HapticFeedback.heavyImpact();
    }
  }

  void _resetCount() {
    final selectedIndex = ref.read(selectedDhikrProvider);
    setState(() {
      _count = 0;
    });
    _dhikrBox.put('dhikr_count_$selectedIndex', 0);
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = ref.watch(selectedDhikrProvider);
    final currentDhikr = dhikrList[selectedIndex];

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
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ─── Zikir Seçici ───
            _buildDhikrSelector(isDark, selectedIndex),

            // ─── Arapça Metin ───
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                currentDhikr.arabic,
                style: NurTextStyles.arabicLarge(
                  color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Text(
              currentDhikr.meaning,
              style: NurTextStyles.bodySmall(
                color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // ─── Sayaç ───
            _buildCounter(isDark, currentDhikr),

            const Spacer(),

            // ─── Zikir Butonu ───
            _buildDhikrButton(isDark),

            const SizedBox(height: 16),

            // ─── Alt İstatistikler ───
            _buildStats(isDark, currentDhikr),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrSelector(bool isDark, int selectedIndex) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dhikrList.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              ref.read(selectedDhikrProvider.notifier).state = index;
              _loadCounts();
              setState(() {});
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                    : (isDark ? NurColors.darkCard : NurColors.lightCard),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(
                  color: isDark ? NurColors.darkDivider : NurColors.lightDivider,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                dhikrList[index].name,
                style: NurTextStyles.labelMedium(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? NurColors.darkText : NurColors.lightText),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCounter(bool isDark, DhikrItem currentDhikr) {
    final progress = _count / currentDhikr.targetCount;

    return Column(
      children: [
        // Dairesel ilerleme
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Arka plan çemberi
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 6,
                  color: isDark
                      ? NurColors.darkDivider
                      : NurColors.lightDivider,
                ),
              ),
              // İlerleme çemberi
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 6,
                  color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Sayı
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_count',
                    style: NurTextStyles.dhikrCount(
                      color: isDark ? NurColors.darkText : NurColors.lightText,
                    ),
                  ),
                  Text(
                    '/ ${currentDhikr.targetCount}',
                    style: NurTextStyles.bodySmall(
                      color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDhikrButton(bool isDark) {
    return GestureDetector(
      onTap: _increment,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple efekti
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 120 + (_rippleAnimation.value * 40),
                      height: 120 + (_rippleAnimation.value * 40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                            .withValues(alpha: 0.2 * (1 - _rippleAnimation.value)),
                      ),
                    );
                  },
                ),
                // Ana buton
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? NurColors.darkPrimaryGradient
                        : NurColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? NurColors.darkPrimary : NurColors.lightPrimary)
                            .withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.touch_app_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStats(bool isDark, DhikrItem currentDhikr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(isDark, 'Toplam', '$_totalCount'),
          // Sıfırla butonu
          GestureDetector(
            onTap: _resetCount,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: NurColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 16, color: NurColors.error),
                  const SizedBox(width: 6),
                  Text(
                    'Sıfırla',
                    style: NurTextStyles.labelSmall(color: NurColors.error),
                  ),
                ],
              ),
            ),
          ),
          _buildStatItem(isDark, 'Hedef', '${currentDhikr.targetCount}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(bool isDark, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: NurTextStyles.headlineSmall(
            color: isDark ? NurColors.darkText : NurColors.lightText,
          ),
        ),
        Text(
          label,
          style: NurTextStyles.labelSmall(
            color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
