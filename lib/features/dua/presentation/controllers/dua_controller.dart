import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart' hide Dua;
import '../../data/datasources/dua_local_datasource.dart';
import '../../data/repositories/local_dua_repository.dart';
import '../../domain/entities/dua.dart';
import '../../domain/repositories/dua_repository.dart';

final duaLocalDatasourceProvider = Provider(
  (r) => DuaLocalDataSource(r.watch(appDatabaseProvider)),
);
final duaRepositoryProvider = Provider<DuaRepository>(
  (r) => LocalDuaRepository(r.watch(duaLocalDatasourceProvider)),
);
final duasProvider = StreamProvider<List<Dua>>(
  (r) => r.watch(duaRepositoryProvider).watchAll(),
);
final categoryDuasProvider = StreamProvider.family<List<Dua>, String>(
  (r, n) => r.watch(duaRepositoryProvider).watchByCategory(n),
);
