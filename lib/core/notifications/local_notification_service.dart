import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../ads/ad_service.dart';
import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  static const reminderId = 1001;
  static const _scheduledIdsKey = 'recitation_scheduled_notification_ids';
  static const _scheduleKey = 'recitation_notification_schedule';

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {
      if (kDebugMode) debugPrint('Using UTC for reminder scheduling.');
    }
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  @override
  Future<void> scheduleDaily({required int hour, required int minute}) async {
    await initialize();
    await cancelDaily();
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
    final prefs = await SharedPreferences.getInstance();
    final isRemoveAds = prefs.getBool('remove_ads_entitlement') ?? false;
    final suffix = AdService.instance.streakNotificationSuffix(
      isRemoveAdsPurchased: isRemoveAds,
    );
    await _plugin.zonedSchedule(
      id: reminderId,
      title: 'Time for your daily Dua',
      body: 'Take a quiet moment to read and reflect on a favorite Dua.$suffix',
      scheduledDate: next,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_dua_reminders',
          'Daily Dua reminders',
          channelDescription: 'A gentle daily reminder to read your Duas',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '/home',
    );
  }

  @override
  Future<void> cancelDaily() async {
    await initialize();
    await _plugin.cancel(id: reminderId);
  }

  @override
  Future<void> scheduleRecitationReminders({
    required List<int> minutesOfDay,
    required Set<String> completedDays,
  }) async {
    await initialize();
    final prefs = await SharedPreferences.getInstance();
    final now = tz.TZDateTime.now(tz.local);
    final scheduleKey =
        '${now.year}-${now.month}-${now.day}|'
        '${minutesOfDay.join(',')}|${completedDays.toList()..sort()}';
    if (prefs.getString(_scheduleKey) == scheduleKey) return;
    await cancelRecitationReminders();
    if (minutesOfDay.isEmpty) return;

    final ids = <String>[];
    // Keep a rolling window. Opening the app extends it; marking today done
    // replaces the window and removes all remaining reminders for today.
    for (var dayOffset = 0; dayOffset < 60; dayOffset++) {
      final day = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + dayOffset,
      );
      final key =
          '${day.year.toString().padLeft(4, '0')}-'
          '${day.month.toString().padLeft(2, '0')}-'
          '${day.day.toString().padLeft(2, '0')}';
      if (completedDays.contains(key)) continue;
      for (var slot = 0; slot < minutesOfDay.length; slot++) {
        final time = minutesOfDay[slot];
        final scheduled = tz.TZDateTime(
          tz.local,
          day.year,
          day.month,
          day.day,
          time ~/ 60,
          time % 60,
        );
        if (!scheduled.isAfter(now)) continue;
        final calendarDay =
            DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
        final id = 200000 + calendarDay * 5 + slot;
        await _plugin.zonedSchedule(
          id: id,
          title: 'Read a Dua today',
          body: 'Read a Dua and mark today done in Favorite Dua.',
          scheduledDate: scheduled,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_recitation_reminders',
              'Daily recitation reminders',
              channelDescription:
                  'Reminders to read a Dua and mark the day done',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: '/recitation-report',
        );
        ids.add('$id');
      }
    }
    await prefs.setStringList(_scheduledIdsKey, ids);
    await prefs.setString(_scheduleKey, scheduleKey);
  }

  @override
  Future<void> cancelRecitationReminders() async {
    await initialize();
    final prefs = await SharedPreferences.getInstance();
    for (final id
        in prefs.getStringList(_scheduledIdsKey) ?? const <String>[]) {
      final parsed = int.tryParse(id);
      if (parsed != null) await _plugin.cancel(id: parsed);
    }
    await prefs.remove(_scheduledIdsKey);
    await prefs.remove(_scheduleKey);
  }
}
