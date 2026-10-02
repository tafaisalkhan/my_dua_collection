import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/ads/ad_service.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError caught in bootstrap: ${details.exception}\n${details.stack}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformDispatcher error caught in bootstrap: $error\n$stack');
    return true;
  };

  try {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
  } catch (e) {
    debugPrint('Orientation setup error: $e');
  }

  try {
    await AdService.instance.initialize();
  } catch (e) {
    debugPrint('AdService initialization error (continuing startup): $e');
  }

  runApp(const ProviderScope(child: FavoriteDuaApp()));
}
