import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fontScaleProvider = NotifierProvider<FontScaleController, double>(
  FontScaleController.new,
);

class FontScaleController extends Notifier<double> {
  static const _key = 'app_font_scale';

  @override
  double build() {
    unawaited(_load());
    return 0.9;
  }

  Future<void> _load() async {
    try {
      final value = (await SharedPreferences.getInstance()).getDouble(_key);
      if (value != null && ref.mounted) state = value.clamp(0.9, 1.35);
    } catch (_) {
      // Keep the small default when preferences are unavailable.
    }
  }

  Future<void> setScale(double value) async {
    state = value.clamp(0.9, 1.35);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_key, state);
    } catch (_) {
      // The selected size still applies for the current session.
    }
  }
}
