import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final adsRemovedProvider = NotifierProvider<AdsRemovedController, bool>(
  AdsRemovedController.new,
);

final shouldShowAdsProvider = Provider<bool>(
  (ref) => !ref.watch(adsRemovedProvider),
);

class AdsRemovedController extends Notifier<bool> {
  static const productId = 'remove_ads';
  static const _key = 'remove_ads_entitlement';

  @override
  bool build() {
    unawaited(_load());
    return false;
  }

  Future<void> _load() async {
    state = (await SharedPreferences.getInstance()).getBool(_key) ?? false;
  }
}
