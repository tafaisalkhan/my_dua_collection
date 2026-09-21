import 'package:drift/drift.dart';
import 'duas_table.dart';
import 'tags_table.dart';

class DuaTags extends Table {
  TextColumn get duaId =>
      text().references(Duas, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();
  @override
  Set<Column> get primaryKey => {duaId, tagId};
}
