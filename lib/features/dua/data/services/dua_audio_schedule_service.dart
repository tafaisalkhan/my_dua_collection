import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DuaAudioScheduleService {
  static const _channel = MethodChannel('favorite_dua/audio_schedule');

  static Future<void> schedule({
    required String id,
    required String title,
    String? audioPath,
    required int hour,
    required int minute,
    int repeats = 3,
    String mode = 'notification',
    String category = '',
    String duaText = '',
  }) async {
    await _channel.invokeMethod('schedule', {
      'id': id,
      'title': title,
      'audioPath': audioPath,
      'hour': hour,
      'minute': minute,
      'repeats': repeats,
      'mode': mode,
      'category': category,
      'duaText': duaText,
    });
  }

  static Future<bool> requestExactTiming() async {
    return await _channel.invokeMethod<bool>('requestExactTiming') ?? false;
  }

  static Future<void> requestNotificationPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> cancel(String id) async {
    await _channel.invokeMethod('cancel', {'id': id});
  }
}
