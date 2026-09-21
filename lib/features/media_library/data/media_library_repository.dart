import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';

class MediaLibraryRepository {
  MediaLibraryRepository(this.db);
  final AppDatabase db;

  Stream<List<LibraryItem>> watch(String search, String kind) {
    final q = db.select(db.libraryItems)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    if (kind != 'all') q.where((t) => t.kind.equals(kind));
    if (search.trim().isNotEmpty) {
      final s = search.trim();
      q.where(
        (t) =>
            t.title.contains(s) |
            t.tags.contains(s) |
            t.ocrText.contains(s) |
            t.textContent.contains(s),
      );
    }
    return q.watch();
  }

  Future<LibraryItem?> get(String id) => (db.select(
    db.libraryItems,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> pickFiles() async {
    final result = await FilePicker.pickFiles();
    return importPaths(result.map((f) => f.path).whereType<String>());
  }

  Future<String?> importOne(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) return null;
    final id = const Uuid().v4();
    final ext = p.extension(sourcePath);
    final dir = Directory(
      p.join(
        (await getApplicationDocumentsDirectory()).path,
        'favorite_dua',
        'library',
        id,
      ),
    );
    await dir.create(recursive: true);
    final target = await source.copy(p.join(dir.path, 'original$ext'));
    final mime = lookupMimeType(target.path);
    final now = DateTime.now();
    await db
        .into(db.libraryItems)
        .insert(
          LibraryItemsCompanion.insert(
            id: id,
            title: p.basenameWithoutExtension(sourcePath),
            kind: _kind(mime, ext),
            filePath: Value(target.path),
            mimeType: Value(mime),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }

  Future<int> importPaths(Iterable<String> paths) async {
    var count = 0;
    for (final sourcePath in paths) {
      final source = File(sourcePath);
      if (!await source.exists()) continue;
      final id = const Uuid().v4();
      final ext = p.extension(sourcePath);
      final dir = Directory(
        p.join(
          (await getApplicationDocumentsDirectory()).path,
          'favorite_dua',
          'library',
          id,
        ),
      );
      await dir.create(recursive: true);
      final target = await source.copy(p.join(dir.path, 'original$ext'));
      final mime = lookupMimeType(target.path);
      final now = DateTime.now();
      await db
          .into(db.libraryItems)
          .insert(
            LibraryItemsCompanion.insert(
              id: id,
              title: p.basenameWithoutExtension(sourcePath),
              kind: _kind(mime, ext),
              filePath: Value(target.path),
              mimeType: Value(mime),
              createdAt: now,
              updatedAt: now,
            ),
          );
      count++;
    }
    return count;
  }

  Future<void> addText(String text) async {
    if (text.trim().isEmpty) return;
    final now = DateTime.now();
    await db
        .into(db.libraryItems)
        .insert(
          LibraryItemsCompanion.insert(
            id: const Uuid().v4(),
            title: text.trim().split(RegExp(r'\s+')).take(6).join(' '),
            kind: 'text',
            textContent: Value(text.trim()),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> setTags(String id, String tags) =>
      (db.update(db.libraryItems)..where((t) => t.id.equals(id))).write(
        LibraryItemsCompanion(
          tags: Value(
            tags
                .split(',')
                .map((e) => e.trim().toLowerCase())
                .where((e) => e.isNotEmpty)
                .toSet()
                .join(', '),
          ),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> shareItem(LibraryItem item) async {
    if (item.filePath != null && await File(item.filePath!).exists()) {
      await SharePlus.instance.share(
        ShareParams(
          title: item.title,
          text: item.ocrText,
          files: [XFile(item.filePath!)],
        ),
      );
    } else {
      await SharePlus.instance.share(
        ShareParams(
          title: item.title,
          text: item.textContent ?? item.ocrText ?? item.title,
        ),
      );
    }
  }

  Future<void> deleteItem(LibraryItem item) async {
    await (db.delete(db.libraryItems)..where((t) => t.id.equals(item.id))).go();
    if (item.filePath != null) {
      final dir = File(item.filePath!).parent;
      if (await dir.exists()) await dir.delete(recursive: true);
    }
  }

  String _kind(String? mime, String ext) {
    if (mime?.startsWith('image/') ?? false) return 'image';
    if (mime?.startsWith('video/') ?? false) return 'video';
    if (mime?.startsWith('audio/') ?? false) return 'audio';
    if (mime?.startsWith('text/') ?? false) return 'document';
    if ([
      '.pdf',
      '.doc',
      '.docx',
      '.odt',
      '.rtf',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
    ].contains(ext.toLowerCase()))
      return 'document';
    return 'other';
  }
}
