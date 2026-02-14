import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../features/qibla/presentation/pages/qibla_page.dart';
import '../features/dhikr/presentation/pages/dhikr_page.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/religious_days/presentation/pages/religious_days_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'shell_page.dart';

/// Ana Router yapısı
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellPage(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/prayer-times',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PrayerTimesPage(),
          ),
        ),
        GoRoute(
          path: '/qibla',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: QiblaPage(),
          ),
        ),
        GoRoute(
          path: '/dhikr',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DhikrPage(),
          ),
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FavoritesPage(),
          ),
        ),
      ],
    ),
    // Menü dışı sayfalar
    GoRoute(
      path: '/religious-days',
      builder: (context, state) => const ReligiousDaysPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
