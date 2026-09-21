import 'package:drift/drift.dart';
import 'duas_table.dart';

class Recordings extends Table {
  TextColumn get id => text()();
  TextColumn get duaId =>
      text().references(Duas, #id, onDelete: KeyAction.cascade)();
  TextColumn get audioPath => text()();
  IntColumn get durationMs => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
