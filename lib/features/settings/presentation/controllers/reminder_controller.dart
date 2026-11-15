import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/notifications/local_notification_service.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../recitation/data/daily_recitation_log.dart';

class ReminderSettings {
  const ReminderSettings({required this.enabled, required this.minutesOfDay});

  final bool enabled;
  final List<int> minutesOfDay;
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService(),
);
final reminderControllerProvider =
    AsyncNotifierProvider<ReminderController, ReminderSettings>(
      ReminderController.new,
    );

class ReminderController extends AsyncNotifier<ReminderSettings> {
  static const _enabledKey = 'daily_reminder_enabled';
  static const _timesKey = 'daily_reminder_times';
  static const _hourKey = 'daily_reminder_hour';
  static const _minuteKey = 'daily_reminder_minute';

  @override
  Future<ReminderSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_timesKey);
    final legacy =
        (prefs.getInt(_hourKey) ?? 23) * 60 + (prefs.getInt(_minuteKey) ?? 0);
    final times = stored == null
        ? <int>[legacy]
        : (stored
              .map(int.tryParse)
              .whereType<int>()
              .where((t) => t >= 0 && t < 1440)
              .toSet()
              .toList()
            ..sort());
    final result = ReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      minutesOfDay: times,
    );
    if (result.enabled) {
      await ref.read(notificationServiceProvider).cancelDaily();
      await _schedule(result);
    }
    return result;
  }

  Future<void> _schedule(ReminderSettings settings) async {
    final service = ref.read(notificationServiceProvider);
    if (!settings.enabled) {
      await service.cancelRecitationReminders();
      return;
    }
    final log = await ref.read(dailyRecitationProvider.future);
    await service.scheduleRecitationReminders(
      minutesOfDay: settings.minutesOfDay,
      completedDays: log.answers.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toSet(),
    );
  }

  Future<bool> setEnabled(bool enabled) async {
    final current = state.value ?? await future;
    final service = ref.read(notificationServiceProvider);
    if (enabled && !await service.requestPermission()) return false;
    final next = ReminderSettings(
      enabled: enabled,
      minutesOfDay: current.minutesOfDay,
    );
    await (await SharedPreferences.getInstance()).setBool(_enabledKey, enabled);
    await service.cancelDaily();
    await _schedule(next);
    state = AsyncData(next);
    return true;
  }

  Future<void> addTime(int hour, int minute) async {
    final current = state.value ?? await future;
    final times = {...current.minutesOfDay, hour * 60 + minute}.toList()
      ..sort();
    if (times.length > 5) throw StateError('Add up to five reminder times.');
    await _saveTimes(current, times);
  }

  Future<void> updateTime(int oldTime, int hour, int minute) async {
    final current = state.value ?? await future;
    final times = {...current.minutesOfDay}
      ..remove(oldTime)
      ..add(hour * 60 + minute);
    await _saveTimes(current, times.toList()..sort());
  }

  Future<void> removeTime(int time) async {
    final current = state.value ?? await future;
    final times = [...current.minutesOfDay]..remove(time);
    await _saveTimes(current, times);
  }

  Future<void> refresh() async => _schedule(state.value ?? await future);

  Future<void> _saveTimes(ReminderSettings current, List<int> times) async {
    final next = ReminderSettings(
      enabled: current.enabled,
      minutesOfDay: times,
    );
    await (await SharedPreferences.getInstance()).setStringList(
      _timesKey,
      times.map((t) => '$t').toList(),
    );
    await _schedule(next);
    state = AsyncData(next);
  }
}
