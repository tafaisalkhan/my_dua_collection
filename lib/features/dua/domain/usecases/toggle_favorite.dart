import '../repositories/dua_repository.dart';

class ToggleFavorite {
  const ToggleFavorite(this.repository);
  final DuaRepository repository;
  Future<void> call(String id) => repository.toggleFavorite(id);
}
