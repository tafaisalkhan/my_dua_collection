import 'package:drift/drift.dart';

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
