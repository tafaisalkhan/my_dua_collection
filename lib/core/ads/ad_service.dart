import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/widgets/no_ads_popup.dart';
import '../audio/audio_playback_coordinator.dart';

class AdService {
  AdService._();
  static final instance = AdService._();

  static const androidInterstitial =
      String.fromEnvironment('ADMOB_INTERSTITIAL_ID');
  static const androidBanner = String.fromEnvironment('ADMOB_BANNER_ID');
  static const removeAdsProductId = 'remove_ads';

  static const _prefLastOpenDate = 'ad_streak_last_open_date';
  static const _prefStreakDays = 'ad_streak_days';
  static const _prefAdFreeDate = 'ad_free_date';

  final _random = Random();
  InterstitialAd? _interstitial;
  Timer? _firstInterstitialTimer;
  bool _loading = false;
  bool _showing = false;
  bool _adsEnabled = true;
  bool _firstInterstitialShown = false;
  bool _isAdFreeToday = false;
  bool _noFillThisLaunch = false;
  bool _popupShownThisLaunch = false;
  int _streakDays = 0;
  String _adFreeDate = '';
  int _interactions = 0;
  int _nextAt = 5;

  final ValueNotifier<bool> isStreakAdFreeNotifier = ValueNotifier<bool>(false);

  bool get isAdFreeToday => _isAdFreeToday;
  bool get noFillThisLaunch => _noFillThisLaunch;

  static bool isValidAdUnitId(String id) {
    return RegExp(r'^ca-app-pub-\d+/\d+$').hasMatch(id.trim());
  }

  String _dateKey(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$d';
  }

  Future<void> _recordDailyOpenAndCheckStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = _dateKey(now);
    final yesterday = _dateKey(now.subtract(const Duration(days: 1)));
    final tomorrow = _dateKey(now.add(const Duration(days: 1)));

    final lastDate = prefs.getString(_prefLastOpenDate);
    _adFreeDate = prefs.getString(_prefAdFreeDate) ?? '';
    _streakDays = prefs.getInt(_prefStreakDays) ?? 0;

    if (lastDate == today) {
      _isAdFreeToday = _adFreeDate == today;
      isStreakAdFreeNotifier.value = _isAdFreeToday;
      return;
    }

    final int streak = (lastDate == yesterday) ? _streakDays + 1 : 1;

    if (streak >= 3) {
      _adFreeDate = tomorrow;
      _streakDays = 0;
      await prefs.setString(_prefAdFreeDate, tomorrow);
      await prefs.setInt(_prefStreakDays, 0);
    } else {
      _streakDays = streak;
      await prefs.setInt(_prefStreakDays, streak);
    }
    _isAdFreeToday = _adFreeDate == today;
    await prefs.setString(_prefLastOpenDate, today);
    isStreakAdFreeNotifier.value = _isAdFreeToday;
  }

  String streakNotificationSuffix({required bool isRemoveAdsPurchased}) {
    if (isRemoveAdsPurchased) return '';
    final tomorrow = _dateKey(DateTime.now().add(const Duration(days: 1)));
    if (_adFreeDate == tomorrow) {
      return ' Streak complete! Today is 100% Ad-Free!';
    }
    if (_streakDays == 1) {
      return ' Open today (Day 2/3) toward a Free Ad-Free Day!';
    }
    if (_streakDays == 2) {
      return ' 1 more day (Day 3/3) to unlock tomorrow Ad-Free!';
    }
    return '';
  }

  Future<void> initialize() async {
    await _recordDailyOpenAndCheckStreak();
    if (kIsWeb || _isAdFreeToday) return;
    await MobileAds.instance.initialize();
    _nextAt = _random.nextBool() ? 5 : 6;
    _load();
    _firstInterstitialTimer = Timer(const Duration(minutes: 3), () {
      if (_adsEnabled && !_isAdFreeToday && !_noFillThisLaunch) {
        _showInterstitial();
      }
    });
  }

  void markNoFillTodayAndNotify() {
    _noFillThisLaunch = true;
  }

  Future<void> showNoAdsPopupIfNeeded(
    BuildContext context, {
    required bool isAdFreePurchased,
  }) async {
    if (_popupShownThisLaunch) return;

    _popupShownThisLaunch = true;
    final step = _random.nextInt(3);

    if (!context.mounted) return;
    await NoAdsPopup.show(
      context,
      step: step,
      isStreakReward: _isAdFreeToday && !isAdFreePurchased,
      isAdFreePurchased: isAdFreePurchased,
      isNoFill: _noFillThisLaunch,
    );
  }

  void setAdsEnabled(bool enabled) {
    _adsEnabled = enabled;
    if (!enabled || _isAdFreeToday) {
      _firstInterstitialTimer?.cancel();
      _interstitial?.dispose();
      _interstitial = null;
    }
  }

  void recordInteraction({required bool adsEnabled}) {
    setAdsEnabled(adsEnabled);
    if (!adsEnabled ||
        _isAdFreeToday ||
        _noFillThisLaunch ||
        _showing ||
        !_firstInterstitialShown) {
      return;
    }
    _interactions++;
    if (_interactions < _nextAt) return;
    _interactions = 0;
    _nextAt = _random.nextBool() ? 5 : 6;
    _showInterstitial();
  }

  void _showInterstitial() async {
    if (!_adsEnabled || _isAdFreeToday || _noFillThisLaunch || _showing) {
      return;
    }
    final ad = _interstitial;
    if (ad == null) {
      _load();
      return;
    }
    _interstitial = null;
    _showing = true;
    _firstInterstitialShown = true;
    await AudioPlaybackCoordinator.instance.stopAll();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _showing = false;
        _load();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _showing = false;
        _load();
      },
    );
    ad.show();
  }

  void _load() {
    if (kIsWeb ||
        !_adsEnabled ||
        _isAdFreeToday ||
        _noFillThisLaunch ||
        _loading ||
        _interstitial != null ||
        !isValidAdUnitId(androidInterstitial)) {
      return;
    }
    _loading = true;
    InterstitialAd.load(
      adUnitId: androidInterstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          if (_adsEnabled && !_isAdFreeToday) {
            _interstitial = ad;
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (_) {
          _loading = false;
          markNoFillTodayAndNotify();
        },
      ),
    );
  }
}
