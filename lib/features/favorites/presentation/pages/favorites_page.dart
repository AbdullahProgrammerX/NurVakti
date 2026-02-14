import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

/// Favoriler Sayfası
class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.menu_book_rounded, 'label': 'Ayetler', 'color': NurColors.emerald},
    {'icon': Icons.mosque_rounded, 'label': 'Hadisler', 'color': NurColors.gold},
    {'icon': Icons.auto_stories_rounded, 'label': 'Vecizeler', 'color': const Color(0xFF8B4513)},
    {'icon': Icons.history_rounded, 'label': 'Tarih', 'color': const Color(0xFF5C6BC0)},
    {'icon': Icons.restaurant_rounded, 'label': 'Yemekler', 'color': const Color(0xFFE57373)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      child: Column(
        children: [
          // ─── Tab Bar ───
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? NurColors.darkCard : NurColors.lightCard,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: isDark ? NurColors.darkPrimary : NurColors.lightPrimary,
                borderRadius: BorderRadius.circular(14),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
              labelStyle: NurTextStyles.labelSmall(),
              tabs: _categories.map((cat) {
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cat['icon'] as IconData, size: 16),
                      const SizedBox(width: 6),
                      Text(cat['label'] as String),
                    ],
                  ),
                );
              }).toList(),
              tabAlignment: TabAlignment.start,
            ),
          ),

          // ─── İçerik ───
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((cat) {
                return _buildEmptyState(isDark, cat);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Map<String, dynamic> category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category['icon'] as IconData,
              size: 48,
              color: (category['color'] as Color).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz favori ${(category['label'] as String).toLowerCase()} yok',
            style: NurTextStyles.bodyMedium(
              color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ana sayfadaki ❤️ butonuna tıklayarak\nfavorilere ekleyebilirsiniz',
            style: NurTextStyles.bodySmall(
              color: isDark ? NurColors.darkTextSecondary : NurColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
