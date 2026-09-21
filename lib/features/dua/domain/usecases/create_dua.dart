import '../entities/dua.dart';
import '../repositories/dua_repository.dart';

class CreateDua {
  const CreateDua(this.repository);
  final DuaRepository repository;
  Future<void> call(Dua dua) => repository.create(dua);
}
