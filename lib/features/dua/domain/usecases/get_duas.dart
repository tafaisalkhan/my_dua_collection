import '../entities/dua.dart';
import '../repositories/dua_repository.dart';

class GetDuas {
  const GetDuas(this.repository);
  final DuaRepository repository;
  Stream<List<Dua>> call() => repository.watchAll();
}
