import 'package:drift/drift.dart';

class Duas extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get originalText => text()();
  TextColumn get ocrText => text().nullable()();
  TextColumn get translation => text().nullable()();
  TextColumn get transliteration => text().nullable()();
  TextColumn get reference => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get tagsText => text().withDefault(const Constant(''))();
  TextColumn get primaryCategoryId => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get detectedLanguage => text().nullable()();
  BoolColumn get scheduleEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get scheduleHour => integer().nullable()();
  IntColumn get scheduleMinute => integer().nullable()();
  IntColumn get scheduleRepeats => integer().withDefault(const Constant(3))();
  TextColumn get scheduleMode => text().nullable()();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
