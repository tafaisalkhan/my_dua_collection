import 'package:drift/drift.dart';
import 'duas_table.dart';

class DuaAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get duaId =>
      text().references(Duas, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();
  TextColumn get title => text()();
  TextColumn get value => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
