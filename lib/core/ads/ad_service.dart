import 'dart:async';
import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();
  static final instance = AdService._();

  static const androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const removeAdsProductId = 'remove_ads';

  final _random = Random();
  InterstitialAd? _interstitial;
  Timer? _firstInterstitialTimer;
  bool _loading = false;
  bool _showing = false;
  bool _adsEnabled = true;
  bool _firstInterstitialShown = false;
  int _interactions = 0;
  int _nextAt = 5;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _nextAt = _random.nextBool() ? 5 : 6;
    _load();
    _firstInterstitialTimer = Timer(const Duration(minutes: 3), () {
      if (_adsEnabled) _showInterstitial();
    });
  }

  void setAdsEnabled(bool enabled) {
    _adsEnabled = enabled;
    if (!enabled) {
      _firstInterstitialTimer?.cancel();
      _interstitial?.dispose();
      _interstitial = null;
    }
  }

  void recordInteraction({required bool adsEnabled}) {
    setAdsEnabled(adsEnabled);
    if (!adsEnabled || _showing || !_firstInterstitialShown) return;
    _interactions++;
    if (_interactions < _nextAt) return;
    _interactions = 0;
    _nextAt = _random.nextBool() ? 5 : 6;
    _showInterstitial();
  }

  void _showInterstitial() {
    if (!_adsEnabled || _showing) return;
    final ad = _interstitial;
    if (ad == null) {
      _load();
      return;
    }
    _interstitial = null;
    _showing = true;
    _firstInterstitialShown = true;
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
    if (!_adsEnabled || _loading || _interstitial != null) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: androidTestInterstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          if (_adsEnabled) {
            _interstitial = ad;
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (_) {
          _loading = false;
        },
      ),
    );
  }
}
