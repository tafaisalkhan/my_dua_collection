// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/notifications/local_notification_service.dart';
import '../../../../core/notifications/notification_service.dart';

class ReminderSettings {
  const ReminderSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
  });
  final bool enabled;
  final int hour;
  final int minute;
  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );
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
  static const _hourKey = 'daily_reminder_hour';
  static const _minuteKey = 'daily_reminder_minute';

  @override
  Future<ReminderSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey) ?? 8,
      minute: prefs.getInt(_minuteKey) ?? 0,
    );
  }

  Future<bool> setEnabled(bool enabled) async {
    final current = state.value ?? await future;
    final service = ref.read(notificationServiceProvider);
    if (enabled && !await service.requestPermission()) return false;
    final next = current.copyWith(enabled: enabled);
    state = AsyncData(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
    if (enabled) {
      await service.scheduleDaily(hour: next.hour, minute: next.minute);
    } else {
      await service.cancelDaily();
    }
    return true;
  }

  Future<void> setTime(int hour, int minute) async {
    final current = state.value ?? await future;
    final next = current.copyWith(hour: hour, minute: minute);
    state = AsyncData(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
    if (next.enabled)
      await ref
          .read(notificationServiceProvider)
          .scheduleDaily(hour: hour, minute: minute);
  }
}
