import 'package:drift/drift.dart';

class LibraryItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get kind => text()();
  TextColumn get filePath => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get textContent => text().nullable()();
  TextColumn get ocrText => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
