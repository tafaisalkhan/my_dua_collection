import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ads/ad_service.dart';
import '../../features/settings/presentation/controllers/ad_entitlement_controller.dart';
import 'ad_banner.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: Column(
      children: [
        const AppBannerAd(),
        Expanded(child: navigationShell),
      ],
    ),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppBannerAd(),
        NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            final switchingToHome =
                index == 0 && navigationShell.currentIndex != 0;
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
            if (switchingToHome) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  AdService.instance.showNoAdsPopupIfNeeded(
                    context,
                    isAdFreePurchased: ref.read(adsRemovedProvider),
                  );
                }
              });
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle),
              label: 'Add',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ],
    ),
  );
}
