import 'package:drift/drift.dart';
import 'duas_table.dart';

class OcrMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get duaId =>
      text().references(Duas, #id, onDelete: KeyAction.cascade)();
  TextColumn get languageCode => text().nullable()();
  RealColumn get confidence => real().nullable()();
  TextColumn get sourceImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
