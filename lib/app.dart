import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/ads/ad_service.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/font_scale_provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/settings/presentation/controllers/ad_entitlement_controller.dart';
import 'shared/widgets/incoming_share_listener.dart';

class FavoriteDuaApp extends ConsumerWidget {
  const FavoriteDuaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsRemoved = ref.watch(adsRemovedProvider);
    final fontScale = ref.watch(fontScaleProvider);
    AdService.instance.setAdsEnabled(!adsRemoved);
    return MaterialApp.router(
      title: 'Favorite Dua',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(fontScale)),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (_) =>
              AdService.instance.recordInteraction(adsEnabled: !adsRemoved),
          // A Router can briefly provide a null child while the inherited theme
          // tree is rebuilt. Dark/light switching must not force-unwrap it.
          child: IncomingShareListener(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
