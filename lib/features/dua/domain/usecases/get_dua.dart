import '../entities/dua.dart';
import '../repositories/dua_repository.dart';

class GetDua {
  const GetDua(this.repository);
  final DuaRepository repository;
  Future<Dua?> call(String id) => repository.getById(id);
}
