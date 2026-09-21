import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.categories)..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]))
      .watch();
});
