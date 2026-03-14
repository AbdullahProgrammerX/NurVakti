import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_provider.dart';
import 'core/services/supabase_service.dart';
import 'core/services/notification_service.dart';
import 'core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase başlat (env config kontrol et)
  if (EnvConfig.isConfigured) {
    await SupabaseService.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
  } else {
    print('⚠️  Supabase config missing. Running in offline mode.');
  }

  // Bildirim servisi başlat
  await NotificationService.initialize();
  await NotificationService.requestPermissions();

  // Hive başlat
  await Hive.initFlutter();

  // Kutuları aç
  await Hive.openBox('dhikr');
  await Hive.openBox('favorites');
  await Hive.openBox('settings');

  runApp(
    const ProviderScope(
      child: NurVaktiApp(),
    ),
  );
}

class NurVaktiApp extends ConsumerWidget {
  const NurVaktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Nur Vakti',
      debugShowCheckedModeBanner: false,
      theme: NurTheme.lightTheme,
      darkTheme: NurTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
