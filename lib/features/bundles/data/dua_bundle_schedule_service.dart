import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuaBundleConfig {
  const DuaBundleConfig({
    required this.name,
    required this.duaIds,
    required this.hour,
    required this.minute,
    required this.frequency,
    required this.weekday,
    required this.dayOfMonth,
    required this.duaRepeats,
  });

  final String name;
  final List<String> duaIds;
  final int hour, minute, weekday, dayOfMonth;
  final String frequency;
  final Map<String, int> duaRepeats;

  Map<String, dynamic> toJson() => {
    'name': name,
    'duaIds': duaIds,
    'hour': hour,
    'minute': minute,
    'frequency': frequency,
    'weekday': weekday,
    'dayOfMonth': dayOfMonth,
    'duaRepeats': duaRepeats,
  };

  factory DuaBundleConfig.fromJson(Map<String, dynamic> json) =>
      DuaBundleConfig(
        name: json['name'] as String? ?? 'My Dua Bundle',
        duaIds: (json['duaIds'] as List<dynamic>? ?? const []).cast<String>(),
        hour: json['hour'] as int? ?? 8,
        minute: json['minute'] as int? ?? 0,
        frequency: json['frequency'] as String? ?? 'daily',
        weekday: json['weekday'] as int? ?? 1,
        dayOfMonth: json['dayOfMonth'] as int? ?? 1,
        duaRepeats: (json['duaRepeats'] as Map<String, dynamic>? ?? const {})
            .map((key, value) => MapEntry(key, value as int)),
      );
}

class DuaBundleScheduleService {
  static const _channel = MethodChannel('favorite_dua/audio_schedule');
  static const _prefsKey = 'primary_dua_bundle';

  static Future<DuaBundleConfig?> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(_prefsKey);
    if (raw == null) return null;
    return DuaBundleConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> save({
    required DuaBundleConfig config,
    required List<String> titles,
    required List<String> audioPaths,
    required List<int> repeats,
  }) async {
    await (await SharedPreferences.getInstance()).setString(
      _prefsKey,
      jsonEncode(config.toJson()),
    );
    await _channel.invokeMethod('scheduleBundle', {
      'id': 'primary_dua_bundle',
      'name': config.name,
      'titles': titles,
      'audioPaths': audioPaths,
      'repeats': repeats,
      'hour': config.hour,
      'minute': config.minute,
      'frequency': config.frequency,
      'weekday': config.weekday,
      'dayOfMonth': config.dayOfMonth,
    });
  }

  static Future<void> cancel() async {
    await (await SharedPreferences.getInstance()).remove(_prefsKey);
    await _channel.invokeMethod('cancelBundle', {'id': 'primary_dua_bundle'});
  }
}
