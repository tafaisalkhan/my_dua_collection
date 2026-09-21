import '../entities/dua.dart';

abstract interface class DuaRepository {
  Stream<List<Dua>> watchAll();
  Stream<List<Dua>> watchByCategory(String name);
  Future<Dua?> getById(String id);
  Future<void> create(Dua d);
  Future<void> update(Dua d);
  Future<void> delete(String id);
  Future<void> toggleFavorite(String id);
  Future<List<Dua>> search(String q);
}
