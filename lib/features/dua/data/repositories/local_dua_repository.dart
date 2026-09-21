import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/dua.dart';
import '../../domain/repositories/dua_repository.dart';
import '../datasources/dua_local_datasource.dart';
import '../models/dua_model.dart';

class LocalDuaRepository implements DuaRepository {
  const LocalDuaRepository(this.local);
  final DuaLocalDataSource local;
  db.DuasCompanion _row(Dua d) => db.DuasCompanion(
    id: Value(d.id),
    title: Value(d.title),
    originalText: Value(d.originalText),
    ocrText: Value(d.ocrText),
    translation: Value(d.translation),
    transliteration: Value(d.transliteration),
    reference: Value(d.reference),
    notes: Value(d.notes),
    primaryCategoryId: Value(d.primaryCategoryId),
    imagePath: Value(d.imagePath),
    detectedLanguage: Value(d.detectedLanguage),
    isBuiltIn: Value(d.isBuiltIn),
    isFavorite: Value(d.isFavorite),
    createdAt: Value(d.createdAt),
    updatedAt: Value(d.updatedAt),
  );
  @override
  Stream<List<Dua>> watchAll() =>
      local.watchAll().map((x) => x.map(DuaModel.fromRow).toList());
  @override
  Stream<List<Dua>> watchByCategory(String name) =>
      local.watchByCategory(name).map((x) => x.map(DuaModel.fromRow).toList());
  @override
  Future<Dua?> getById(String id) async {
    final r = await local.getById(id);
    return r == null ? null : DuaModel.fromRow(r);
  }

  @override
  Future<void> create(Dua d) => local.insert(_row(d));
  @override
  Future<void> update(Dua d) => local.replace(_row(d));
  @override
  Future<void> delete(String id) => local.deleteById(id);
  @override
  Future<void> toggleFavorite(String id) async {
    final d = await local.getById(id);
    if (d != null) await local.setFavorite(id, !d.isFavorite);
  }

  @override
  Future<List<Dua>> search(String q) async =>
      (await local.search(q)).map(DuaModel.fromRow).toList();
}
