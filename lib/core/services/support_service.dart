import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handles Play Store rating, sharing, in-app updates, and Buy Developer a Coffee IAP.
class SupportService {
  SupportService._();
  static final SupportService instance = SupportService._();

  static const String packageId = 'com.myfavourite.duas';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$packageId';
  static const String coffeeProductId = 'cofee';
  static const String coffeePriceFallback = r'$1.99';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  bool _iapInitialized = false;
  bool _updateCheckedThisSession = false;

  void Function(String message)? _onCoffeePurchased;
  void Function(String error)? _onPurchaseError;
  ProductDetails? _coffeeProduct;

  String get coffeePrice => _coffeeProduct?.price ?? coffeePriceFallback;

  Future<void> initIap({
    void Function(String message)? onCoffeePurchased,
    void Function(String error)? onPurchaseError,
  }) async {
    _onCoffeePurchased = onCoffeePurchased;
    _onPurchaseError = onPurchaseError;

    if (_iapInitialized) return;
    _iapInitialized = true;

    _purchaseSub = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        debugPrint('Coffee IAP stream error: $error');
        _onPurchaseError?.call(error.toString());
      },
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) return;
      final response = await _iap.queryProductDetails({coffeeProductId});
      for (final product in response.productDetails) {
        if (product.id == coffeeProductId) {
          _coffeeProduct = product;
        }
      }
    } catch (e) {
      debugPrint('Failed to load coffee product: $e');
    }
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.productID != coffeeProductId) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          _onCoffeePurchased?.call(
            'Thank you so much for buying me a coffee! Your support keeps this app growing.',
          );
          break;
        case PurchaseStatus.restored:
          break;
        case PurchaseStatus.error:
          _onPurchaseError
              ?.call(purchase.error?.message ?? 'Purchase failed.');
          break;
        case PurchaseStatus.canceled:
          break;
      }

      if (purchase.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(purchase);
        } catch (e) {
          debugPrint('completePurchase error: $e');
        }
      }
    }
  }

  Future<bool> buyCoffee() async {
    try {
      await initIap();
      final available = await _iap.isAvailable();
      if (!available) {
        _onPurchaseError?.call('Store is not available on this device.');
        return false;
      }

      ProductDetails? product = _coffeeProduct;
      if (product == null) {
        final response = await _iap.queryProductDetails({coffeeProductId});
        if (response.productDetails.isNotEmpty) {
          product = response.productDetails.first;
          _coffeeProduct = product;
        }
      }

      if (product == null) {
        _onPurchaseError?.call('Product "$coffeeProductId" is not available yet.');
        return false;
      }

      final param = PurchaseParam(productDetails: product);
      return await _iap.buyConsumable(purchaseParam: param);
    } catch (e) {
      debugPrint('buyCoffee error: $e');
      _onPurchaseError?.call(e.toString());
      return false;
    }
  }

  Future<void> shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Keep your favorite duas organized offline! Download Favorite Dua:\n$playStoreUrl',
        subject: 'Favorite Dua',
      ),
    );
  }

  Future<void> requestInAppReview() async {
    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await openPlayStore();
      }
    } catch (e) {
      debugPrint('requestInAppReview error: $e');
      await openPlayStore();
    }
  }

  Future<void> openPlayStore() async {
    final uri = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> checkForAppUpdate(BuildContext context) async {
    if (_updateCheckedThisSession || kIsWeb || !Platform.isAndroid) return;
    _updateCheckedThisSession = true;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        final result = await InAppUpdate.startFlexibleUpdate();
        if (result == AppUpdateResult.success && context.mounted) {
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('InAppUpdate check skipped/failed: $e');
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
  }
}
