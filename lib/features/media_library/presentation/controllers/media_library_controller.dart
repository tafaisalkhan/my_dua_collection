import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/database/app_database.dart';
import '../../data/media_library_repository.dart';

final mediaRepositoryProvider = Provider(
  (ref) => MediaLibraryRepository(ref.watch(appDatabaseProvider)),
);
final mediaSearchProvider = StateProvider<String>((ref) => '');
final mediaKindProvider = StateProvider<String>((ref) => 'all');
final mediaItemsProvider = StreamProvider<List<LibraryItem>>(
  (ref) => ref
      .watch(mediaRepositoryProvider)
      .watch(ref.watch(mediaSearchProvider), ref.watch(mediaKindProvider)),
);
final mediaItemProvider = FutureProvider.family<LibraryItem?, String>(
  (ref, id) => ref.watch(mediaRepositoryProvider).get(id),
);
