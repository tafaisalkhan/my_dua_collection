// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import 'tables/categories_table.dart';
import 'tables/dua_tags_table.dart';
import 'tables/dua_attachments_table.dart';
import 'tables/duas_table.dart';
import 'tables/ocr_metadata_table.dart';
import 'tables/recordings_table.dart';
import 'tables/library_items_table.dart';
import 'tables/tags_table.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Duas,
    Categories,
    Tags,
    DuaTags,
    Recordings,
    OcrMetadata,
    LibraryItems,
    DuaAttachments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  @override
  int get schemaVersion => 5;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, f, t) async {
      if (f < 3) await m.createTable(libraryItems);
      if (f < 4) {
        await m.addColumn(duas, duas.tagsText);
        await m.createTable(duaAttachments);
      }
      if (f < 5) {
        await m.addColumn(duas, duas.scheduleEnabled);
        await m.addColumn(duas, duas.scheduleHour);
        await m.addColumn(duas, duas.scheduleMinute);
        await m.addColumn(duas, duas.scheduleRepeats);
        await m.addColumn(duas, duas.scheduleMode);
      }
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _seed();
    },
  );
  Future<void> _seed() async {
    final now = DateTime.now(), ids = <String, String>{};
    for (var i = 0; i < AppConstants.starterCategories.length; i++) {
      final n = AppConstants.starterCategories[i],
          old = await (select(
            categories,
          )..where((t) => t.name.equals(n))).getSingleOrNull();
      if (old != null) {
        ids[n] = old.id;
      } else {
        final id = const Uuid().v5(
          Uuid.NAMESPACE_URL,
          'favorite-dua/category/$n',
        );
        await into(categories).insert(
          CategoriesCompanion.insert(
            id: id,
            name: n,
            isBuiltIn: const Value(true),
            sortOrder: Value(i),
            createdAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
        ids[n] = id;
      }
    }
    final data = [
      (
        'builtin-morning',
        'Morning Remembrance',
        'Morning',
        'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        'O Allah, by You we enter the morning, by You we enter the evening, by You we live, by You we die, and to You is the resurrection.',
        'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur.',
        'Sunan Abi Dawud 5068',
      ),
      (
        'builtin-evening',
        'Evening Remembrance',
        'Evening',
        'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        'O Allah, by You we enter the evening, by You we live, by You we die, and to You is the resurrection.',
        'Allahumma bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur.',
        'Sunan Abi Dawud 5068',
      ),
      (
        'builtin-after-prayer',
        'Remembrance After Prayer',
        'After Prayer',
        'أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ ذَا الْجَلَالِ وَالْإِكْرَامِ',
        'I seek Allah’s forgiveness (three times). O Allah, You are Peace and from You comes peace. Blessed are You, Possessor of majesty and honour.',
        'Astaghfirullah (three times). Allahumma antas-salamu wa minkas-salam, tabarakta dhal-jalali wal-ikram.',
        'Sahih Muslim 591',
      ),
    ];
    for (final x in data) {
      await into(duas).insert(
        DuasCompanion.insert(
          id: x.$1,
          title: x.$2,
          originalText: x.$4,
          translation: Value(x.$5),
          transliteration: Value(x.$6),
          reference: Value(x.$7),
          primaryCategoryId: Value(ids[x.$3]),
          detectedLanguage: const Value('ar'),
          isBuiltIn: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
    await _seedJsonCatalog(ids, now);
  }

  Future<void> _seedJsonCatalog(
    Map<String, String> categoryIds,
    DateTime now,
  ) async {
    final raw = await rootBundle.loadString('assets/data/builtin_duas.json');
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final entries = root['duas'] as List<dynamic>? ?? const [];
    for (final value in entries) {
      final item = value as Map<String, dynamic>;
      final category = item['category'] as String;
      final categoryId = categoryIds[category];
      if (categoryId == null) continue;
      final titles = item['title'] as Map<String, dynamic>? ?? const {};
      final translations =
          item['translations'] as Map<String, dynamic>? ?? const {};
      await into(duas).insert(
        DuasCompanion.insert(
          id: item['id'] as String,
          title: (titles['en'] as String?) ?? category,
          originalText: item['arabic'] as String,
          translation: Value(translations['en'] as String?),
          transliteration: Value(item['transliteration'] as String?),
          reference: Value(item['reference'] as String?),
          primaryCategoryId: Value(categoryId),
          detectedLanguage: const Value('ar'),
          isBuiltIn: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }
}

LazyDatabase _open() => LazyDatabase(() async {
  final d = Directory(
    p.join(
      (await getApplicationDocumentsDirectory()).path,
      StorageConstants.root,
      StorageConstants.database,
    ),
  );
  await d.create(recursive: true);
  return NativeDatabase.createInBackground(
    File(p.join(d.path, 'favorite_dua.sqlite')),
  );
});
final appDatabaseProvider = Provider<AppDatabase>((r) {
  final d = AppDatabase();
  r.onDispose(d.close);
  return d;
});
