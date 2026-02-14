import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/colors.dart';
import '../widgets/calendar_leaf_card.dart';

/// Ana Sayfa - Takvim Yaprağı
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PageController _pageController;
  static const int _initialPage = 500; // Ortadan başla (geri/ileri kaydırma)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getDateForIndex(int index) {
    final offset = index - _initialPage;
    return DateTime.now().add(Duration(days: offset));
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
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {},
        itemBuilder: (context, index) {
          final date = _getDateForIndex(index);
          final isToday = index == _initialPage;
          return CalendarLeafCard(date: date, isToday: isToday);
        },
      ),
    );
  }
}
