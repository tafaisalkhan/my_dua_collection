import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

class DuaLocalDataSource {
  const DuaLocalDataSource(this.db);
  final AppDatabase db;
  Stream<List<Dua>> watchAll() => (db.select(
    db.duas,
  )..orderBy([(row) => OrderingTerm.desc(row.createdAt)])).watch();
  Stream<List<Dua>> watchByCategory(String n) {
    final q =
        db.select(db.duas).join([
            innerJoin(
              db.categories,
              db.categories.id.equalsExp(db.duas.primaryCategoryId),
            ),
          ])
          ..where(db.categories.name.equals(n))
          ..orderBy([OrderingTerm.desc(db.duas.createdAt)]);
    return q.watch().map((r) => r.map((x) => x.readTable(db.duas)).toList());
  }

  Future<Dua?> getById(String id) =>
      (db.select(db.duas)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<void> insert(DuasCompanion r) => db.into(db.duas).insert(r);
  Future<void> replace(DuasCompanion r) => db.update(db.duas).write(r);
  Future<void> deleteById(String id) =>
      (db.delete(db.duas)..where((t) => t.id.equals(id))).go();
  Future<void> setFavorite(String id, bool v) => (db.update(
    db.duas,
  )..where((t) => t.id.equals(id))).write(DuasCompanion(isFavorite: Value(v)));
  Future<List<Dua>> search(String q) =>
      (db.select(db.duas)..where(
            (t) =>
                t.title.contains(q) |
                t.originalText.contains(q) |
                t.ocrText.contains(q) |
                t.translation.contains(q) |
                t.transliteration.contains(q) |
                t.reference.contains(q) |
                t.notes.contains(q),
          ))
          .get();
}
