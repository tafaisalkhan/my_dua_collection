import '../repositories/dua_repository.dart';

class DeleteDua {
  const DeleteDua(this.repository);
  final DuaRepository repository;
  Future<void> call(String id) => repository.delete(id);
}
