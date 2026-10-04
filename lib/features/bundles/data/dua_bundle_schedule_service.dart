import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuaBundleConfig {
  const DuaBundleConfig({
    required this.id,
    required this.name,
    required this.duaIds,
    required this.hour,
    required this.minute,
    required this.frequency,
    required this.weekday,
    required this.dayOfMonth,
    required this.duaRepeats,
  });

  final String id;
  final String name;
  final List<String> duaIds;
  final int hour, minute, weekday, dayOfMonth;
  final String frequency;
  final Map<String, int> duaRepeats;

  Map<String, dynamic> toJson() => {
    'id': id,
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
        id: json['id'] as String? ?? 'primary_dua_bundle',
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
  static const _bundlesKey = 'all_dua_bundles_v2';
  static const _legacyKey = 'primary_dua_bundle';

  /// Loads all scheduled Dua bundles safely.
  static Future<List<DuaBundleConfig>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_bundlesKey);
    if (rawList != null && rawList.isNotEmpty) {
      return rawList
          .map((item) => DuaBundleConfig.fromJson(jsonDecode(item) as Map<String, dynamic>))
          .toList();
    }
    // Safe migration check for legacy single bundle
    final legacyRaw = prefs.getString(_legacyKey);
    if (legacyRaw != null) {
      try {
        final single = DuaBundleConfig.fromJson(jsonDecode(legacyRaw) as Map<String, dynamic>);
        await prefs.setStringList(_bundlesKey, [jsonEncode(single.toJson())]);
        await prefs.remove(_legacyKey);
        return [single];
      } catch (e) {
        debugPrint('Legacy bundle migration error: $e');
      }
    }
    return const [];
  }

  /// Saves or updates a specific Dua bundle and schedules its Android alarm.
  static Future<void> save({
    required DuaBundleConfig config,
    required List<String> titles,
    required List<String> audioPaths,
    required List<int> repeats,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadAll();
    final updatedList = current.where((b) => b.id != config.id).toList()..add(config);

    final rawList = updatedList.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_bundlesKey, rawList);

    if (audioPaths.isNotEmpty) {
      await _channel.invokeMethod('scheduleBundle', {
        'id': config.id,
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
  }

  /// Cancels and deletes a Dua bundle schedule by ID.
  static Future<void> cancel(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadAll();
    final updatedList = current.where((b) => b.id != id).toList();

    final rawList = updatedList.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_bundlesKey, rawList);

    await _channel.invokeMethod('cancelBundle', {'id': id});
  }
}
