import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/colors.dart';
import 'theme/text_styles.dart';

/// Ana Shell - Bottom Navigation Bar + Popup Menü
class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/home':
        return 0;
      case '/prayer-times':
        return 1;
      case '/qibla':
        return 2;
      case '/dhikr':
        return 3;
      case '/favorites':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/prayer-times');
        break;
      case 2:
        context.go('/qibla');
        break;
      case 3:
        context.go('/dhikr');
        break;
      case 4:
        context.go('/favorites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = _currentIndex(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nur Vakti',
          style: NurTextStyles.headlineSmall(
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? NurColors.darkCalendarHeaderGradient
                : NurColors.calendarHeaderGradient,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'favorites':
                  context.go('/favorites');
                  break;
                case 'religious_days':
                  context.push('/religious-days');
                  break;
                case 'settings':
                  context.push('/settings');
                  break;
              }
            },
            itemBuilder: (context) => [
              _buildPopupItem(
                Icons.star_rounded,
                'Favoriler',
                'favorites',
                NurColors.gold,
              ),
              _buildPopupItem(
                Icons.event_rounded,
                'Dini Günler & Kandiller',
                'religious_days',
                NurColors.emerald,
              ),
              const PopupMenuDivider(),
              _buildPopupItem(
                Icons.settings_rounded,
                'Ayarlar',
                'settings',
                null,
              ),
            ],
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mosque_rounded),
              activeIcon: Icon(Icons.mosque_rounded),
              label: 'Namaz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Kıble',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.touch_app_rounded),
              activeIcon: Icon(Icons.touch_app_rounded),
              label: 'Zikirmatik',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_rounded),
              activeIcon: Icon(Icons.star_rounded),
              label: 'Favoriler',
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    IconData icon,
    String label,
    String value,
    Color? iconColor,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}
