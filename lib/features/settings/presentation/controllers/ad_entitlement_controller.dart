import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoveAdsPurchaseState {
  const RemoveAdsPurchaseState({
    this.entitled = false,
    this.storeAvailable = false,
    this.loading = true,
    this.purchasePending = false,
    this.product,
    this.message,
  });

  final bool entitled;
  final bool storeAvailable;
  final bool loading;
  final bool purchasePending;
  final ProductDetails? product;
  final String? message;

  RemoveAdsPurchaseState copyWith({
    bool? entitled,
    bool? storeAvailable,
    bool? loading,
    bool? purchasePending,
    ProductDetails? product,
    String? message,
    bool clearMessage = false,
  }) => RemoveAdsPurchaseState(
    entitled: entitled ?? this.entitled,
    storeAvailable: storeAvailable ?? this.storeAvailable,
    loading: loading ?? this.loading,
    purchasePending: purchasePending ?? this.purchasePending,
    product: product ?? this.product,
    message: clearMessage ? null : message ?? this.message,
  );
}

final removeAdsPurchaseProvider =
    NotifierProvider<RemoveAdsPurchaseController, RemoveAdsPurchaseState>(
      RemoveAdsPurchaseController.new,
    );

final adsRemovedProvider = Provider<bool>(
  (ref) => ref.watch(removeAdsPurchaseProvider).entitled,
);

final shouldShowAdsProvider = Provider<bool>(
  (ref) => !ref.watch(adsRemovedProvider),
);

class RemoveAdsPurchaseController extends Notifier<RemoveAdsPurchaseState> {
  static const productId = 'remove_ads';
  static const _entitlementKey = 'remove_ads_entitlement';

  final _billing = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  RemoveAdsPurchaseState build() {
    _purchaseSubscription = _billing.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        state = state.copyWith(
          loading: false,
          purchasePending: false,
          message: 'Google Play purchase error: $error',
        );
      },
    );
    ref.onDispose(() => _purchaseSubscription?.cancel());
    unawaited(_initialize());
    return const RemoveAdsPurchaseState();
  }

  Future<void> _initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final entitled = preferences.getBool(_entitlementKey) ?? false;
    final available = await _billing.isAvailable();
    if (!available) {
      state = state.copyWith(
        entitled: entitled,
        storeAvailable: false,
        loading: false,
        message: 'Google Play Billing is unavailable on this installation.',
      );
      return;
    }

    final response = await _billing.queryProductDetails({productId});
    if (response.error != null) {
      state = state.copyWith(
        entitled: entitled,
        storeAvailable: true,
        loading: false,
        message: response.error!.message,
      );
      return;
    }
    final product = response.productDetails
        .where((item) => item.id == productId)
        .firstOrNull;
    state = state.copyWith(
      entitled: entitled,
      storeAvailable: true,
      loading: false,
      product: product,
      message: product == null
          ? 'The remove_ads product is not available for this Google Play account or app build.'
          : null,
      clearMessage: product != null,
    );
  }

  Future<void> buy() async {
    final product = state.product;
    if (state.entitled || state.purchasePending) return;
    if (product == null) {
      state = state.copyWith(
        message:
            'Remove Ads is not available. Install the app from a Google Play testing track and use a licensed tester account.',
      );
      return;
    }
    state = state.copyWith(purchasePending: true, clearMessage: true);
    final started = await _billing.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    if (!started) {
      state = state.copyWith(
        purchasePending: false,
        message: 'Google Play could not start the purchase.',
      );
    }
  }

  Future<void> restore() async {
    if (state.purchasePending) return;
    state = state.copyWith(purchasePending: true, clearMessage: true);
    try {
      await _billing.restorePurchases();
    } catch (error) {
      state = state.copyWith(
        purchasePending: false,
        message: 'Could not restore purchases: $error',
      );
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != productId) continue;
      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(purchasePending: true, clearMessage: true);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _grantEntitlement();
          state = state.copyWith(
            entitled: true,
            purchasePending: false,
            message: purchase.status == PurchaseStatus.restored
                ? 'Remove Ads purchase restored.'
                : 'Purchase complete. Ads are now removed.',
          );
        case PurchaseStatus.error:
          state = state.copyWith(
            purchasePending: false,
            message: purchase.error?.message ?? 'Purchase failed.',
          );
        case PurchaseStatus.canceled:
          state = state.copyWith(
            purchasePending: false,
            message: 'Purchase canceled.',
          );
      }
      if (purchase.pendingCompletePurchase) {
        await _billing.completePurchase(purchase);
      }
    }
  }

  Future<void> _grantEntitlement() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_entitlementKey, true);
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }
}
