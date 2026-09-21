import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/categories/presentation/screens/category_duas_screen.dart';
import '../../features/bundles/presentation/screens/dua_bundle_screen.dart';
import '../../features/attachments/presentation/screens/document_preview_screen.dart';
import '../../features/attachments/presentation/screens/embedded_web_screen.dart';
import '../../features/crop/presentation/screens/image_crop_screen.dart';
import '../../features/dua/presentation/screens/add_dua_screen.dart';
import '../../features/dua/presentation/screens/dua_detail_screen.dart';
import '../../features/dua/presentation/screens/edit_dua_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/incoming_share/presentation/screens/incoming_share_review_screen.dart';
import '../../features/media_library/presentation/screens/media_detail_screen.dart';
import '../../features/ocr/presentation/screens/image_preview_screen.dart';
import '../../features/ocr/presentation/screens/ocr_review_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (c, s, n) => AppScaffold(navigationShell: n),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (c, s) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/add', builder: (c, s) => const AddDuaScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (c, s) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (c, s) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/dua-bundle', builder: (c, s) => const DuaBundleScreen()),
      GoRoute(
        path: '/library/item/:id',
        builder: (c, s) => MediaDetailScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/share-review',
        builder: (c, s) => const IncomingShareReviewScreen(),
      ),
      GoRoute(
        path: '/view/web',
        builder: (c, s) => EmbeddedWebScreen(
          url: s.uri.queryParameters['url'] ?? '',
          title: s.uri.queryParameters['title'] ?? 'Link',
        ),
      ),
      GoRoute(
        path: '/view/document',
        builder: (c, s) => DocumentPreviewScreen(
          path: s.uri.queryParameters['path'] ?? '',
          title: s.uri.queryParameters['title'] ?? 'Document',
        ),
      ),
      GoRoute(
        path: '/category/:name',
        builder: (c, s) => CategoryDuasScreen(
          name: Uri.decodeComponent(s.pathParameters['name']!),
        ),
      ),
      GoRoute(
        path: '/dua/:id',
        builder: (c, s) => DuaDetailScreen(id: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (c, s) =>
                EditDuaScreen(isEditing: true, duaId: s.pathParameters['id']),
          ),
        ],
      ),
      GoRoute(
        path: '/add/manual',
        builder: (c, s) => EditDuaScreen(
          initialText: s.uri.queryParameters['ocrText'],
          initialLink: s.uri.queryParameters['sharedLink'],
          libraryItemId: s.uri.queryParameters['libraryItemId'],
          croppedPath: s.uri.queryParameters['croppedPath'],
        ),
      ),
      GoRoute(
        path: '/add/crop',
        builder: (c, s) =>
            ImageCropScreen(imagePath: s.uri.queryParameters['path'] ?? ''),
      ),
      GoRoute(
        path: '/add/image-preview',
        builder: (c, s) => ImagePreviewScreen(
          source: s.uri.queryParameters['source'] ?? 'gallery',
          imagePath: s.uri.queryParameters['path'],
        ),
      ),
      GoRoute(
        path: '/add/ocr-review',
        builder: (c, s) =>
            OcrReviewScreen(imagePath: s.uri.queryParameters['path'] ?? ''),
      ),
    ],
  ),
);
