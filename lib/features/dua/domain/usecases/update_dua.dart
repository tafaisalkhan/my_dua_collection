import '../entities/dua.dart';
import '../repositories/dua_repository.dart';

class UpdateDua {
  const UpdateDua(this.repository);
  final DuaRepository repository;
  Future<void> call(Dua dua) => repository.update(dua);
}
