import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/prayer_time_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation =
      _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission() ?? false;
    } else if (Platform.isIOS) {
      final iosImplementation =
      _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    }
    return false;
  }

  static Future<void> schedulePrayerNotifications({
    required PrayerTimesModel prayerTimes,
    required DateTime date,
    required Map<String, bool> enabledPrayers,
    required int reminderMinutes,
    String? customSoundPath,
  }) async {
    await cancelAllPrayerNotifications();

    final prayers = {
      'imsak': prayerTimes.imsak,
      'gunes': prayerTimes.gunes,
      'ogle': prayerTimes.ogle,
      'ikindi': prayerTimes.ikindi,
      'aksam': prayerTimes.aksam,
      'yatsi': prayerTimes.yatsi,
    };

    for (final entry in prayers.entries) {
      if (enabledPrayers[entry.key] != true) continue;

      final prayerTime = _parseTime(entry.value, date);
      if (prayerTime.isBefore(DateTime.now())) continue;

      final notificationTime = prayerTime.subtract(Duration(minutes: reminderMinutes));

      await _scheduleNotification(
        id: _getPrayerId(entry.key),
        title: '${_getPrayerDisplayName(entry.key)} Vakti',
        body: '${_getPrayerDisplayName(entry.key)} vaktine $reminderMinutes dakika kaldı',
        scheduledTime: notificationTime,
        customSoundPath: customSoundPath,
      );
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? customSoundPath,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'prayer_times',
      'Namaz Vakitleri',
      channelDescription: 'Namaz vakti bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
      sound: customSoundPath != null
          ? UriAndroidNotificationSound(customSoundPath)
          : const RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      playSound: true,
    );

    final iosDetails = DarwinNotificationDetails(
      sound: customSoundPath ?? 'notification.aiff',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleReligiousDayNotification({
    required String dayName,
    required DateTime date,
    String? customSoundPath,
  }) async {
    final notificationTime = DateTime(date.year, date.month, date.day, 9, 0);

    if (notificationTime.isBefore(DateTime.now())) return;

    await _scheduleNotification(
      id: date.millisecondsSinceEpoch ~/ 1000,
      title: dayName,
      body: 'Bugün mübarek $dayName',
      scheduledTime: notificationTime,
      customSoundPath: customSoundPath,
    );
  }

  static Future<void> cancelAllPrayerNotifications() async {
    for (int i = 0; i < 6; i++) {
      await _notifications.cancel(i);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static DateTime _parseTime(String time, DateTime date) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  static int _getPrayerId(String prayer) {
    switch (prayer) {
      case 'imsak':
        return 0;
      case 'gunes':
        return 1;
      case 'ogle':
        return 2;
      case 'ikindi':
        return 3;
      case 'aksam':
        return 4;
      case 'yatsi':
        return 5;
      default:
        return 0;
    }
  }

  static String _getPrayerDisplayName(String prayer) {
    switch (prayer) {
      case 'imsak':
        return 'İmsak';
      case 'gunes':
        return 'Güneş';
      case 'ogle':
        return 'Öğle';
      case 'ikindi':
        return 'İkindi';
      case 'aksam':
        return 'Akşam';
      case 'yatsi':
        return 'Yatsı';
      default:
        return prayer;
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
