import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';
import '../constants/storage_constants.dart';

class BackupService {
  final Ref ref;

  BackupService(this.ref);

  /// Exports the entire SQLite database and media attachments into a single backup binary (.bin) file.
  Future<File?> exportBackup() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final rootDir = Directory(p.join(docDir.path, StorageConstants.root));

      if (!rootDir.existsSync()) {
        debugPrint('Backup error: Root directory does not exist');
        return null;
      }

      final archive = Archive();
      final files = rootDir.listSync(recursive: true);

      for (final entity in files) {
        if (entity is File) {
          final relativePath = p.relative(entity.path, from: docDir.path);
          final bytes = await entity.readAsBytes();
          archive.addFile(ArchiveFile(relativePath, bytes.length, bytes));
        }
      }

      final encoder = ZipEncoder();
      final compressedBytes = encoder.encode(archive);

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-');
      final backupFile = File(
        p.join(tempDir.path, 'favorite_dua_backup_$timestamp.bin'),
      );

      await backupFile.writeAsBytes(compressedBytes);
      return backupFile;
    } catch (e, st) {
      debugPrint('Backup export error: $e\n$st');
      rethrow;
    }
  }

  /// Saves the backup file directly to the user-accessible public Downloads folder.
  Future<File?> saveBackupToDownloads() async {
    final backupFile = await exportBackup();
    if (backupFile == null) return null;

    Directory? targetDir;
    if (Platform.isAndroid) {
      final pubDownload = Directory('/storage/emulated/0/Download');
      if (pubDownload.existsSync()) {
        targetDir = pubDownload;
      }
    }
    targetDir ??= await getDownloadsDirectory() ?? await getExternalStorageDirectory();
    if (targetDir == null) return backupFile;

    final fileName = p.basename(backupFile.path);
    final destFile = File(p.join(targetDir.path, fileName));
    await backupFile.copy(destFile.path);
    return destFile;
  }

  /// Exports and triggers the system share dialog for the backup file.
  Future<bool> shareBackup() async {
    final file = await saveBackupToDownloads() ?? await exportBackup();
    if (file == null || !file.existsSync()) return false;
    final result = await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/octet-stream')],
      text: 'Favorite Dua Backup (Database & Voice Audio)',
    );
    return result.status == ShareResultStatus.success;
  }

  /// Prompts user to pick a backup file (.bin or .zip) and restores database + media attachments.
  Future<bool> restoreBackupFromFile() async {
    try {
      final picked = await FilePicker.pickFiles(
        type: FileType.any,
      );

      if (picked.isEmpty) return false;
      final selectedPath = picked.first.path;
      if (selectedPath == null) return false;

      final backupFile = File(selectedPath);
      if (!backupFile.existsSync()) return false;

      final bytes = await backupFile.readAsBytes();
      final decoder = ZipDecoder();
      final archive = decoder.decodeBytes(bytes);

      if (archive.isEmpty) {
        throw Exception('Selected backup file is empty or invalid.');
      }

      final docDir = await getApplicationDocumentsDirectory();
      final rootDir = Directory(p.join(docDir.path, StorageConstants.root));

      // 1. Close current database connection before overwriting
      final db = ref.read(appDatabaseProvider);
      await db.close();

      // 2. Extract restored files over existing files
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(p.join(docDir.path, filename));
          await outFile.parent.create(recursive: true);
          await outFile.writeAsBytes(data);
        } else {
          await Directory(p.join(docDir.path, filename)).create(recursive: true);
        }
      }

      // 3. Re-anchor device-specific absolute paths in restored SQLite database
      final sqlitePath = p.join(
        rootDir.path,
        StorageConstants.database,
        'favorite_dua.sqlite',
      );

      if (File(sqlitePath).existsSync()) {
        await _reanchorDevicePaths(sqlitePath, docDir.path);
        await db.syncBinaryFilesToDevice();
      }

      return true;
    } catch (e, st) {
      debugPrint('Backup restore error: $e\n$st');
      rethrow;
    }
  }

  /// Fixes absolute file paths stored in database to match the new phone's application documents path.
  Future<void> _reanchorDevicePaths(String sqlitePath, String newDocPath) async {
    try {
      final db = ref.read(appDatabaseProvider);
      
      // Update Duas image paths
      final allDuas = await db.select(db.duas).get();
      for (final dua in allDuas) {
        if (dua.imagePath != null && dua.imagePath!.contains('/${StorageConstants.root}/')) {
          final relPath = dua.imagePath!.substring(
            dua.imagePath!.indexOf('/${StorageConstants.root}/') + 1,
          );
          final newPath = p.join(newDocPath, relPath);
          await (db.update(db.duas)..where((t) => t.id.equals(dua.id))).write(
            DuasCompanion(imagePath: Value(newPath)),
          );
        }
      }

      // Update Dua Attachments
      final allAttachments = await db.select(db.duaAttachments).get();
      for (final att in allAttachments) {
        if (att.value.contains('/${StorageConstants.root}/')) {
          final relPath = att.value.substring(
            att.value.indexOf('/${StorageConstants.root}/') + 1,
          );
          final newPath = p.join(newDocPath, relPath);
          await (db.update(db.duaAttachments)..where((t) => t.id.equals(att.id))).write(
            DuaAttachmentsCompanion(value: Value(newPath)),
          );
        }
      }

      // Update Recordings
      final allRecordings = await db.select(db.recordings).get();
      for (final rec in allRecordings) {
        if (rec.audioPath.contains('/${StorageConstants.root}/')) {
          final relPath = rec.audioPath.substring(
            rec.audioPath.indexOf('/${StorageConstants.root}/') + 1,
          );
          final newPath = p.join(newDocPath, relPath);
          await (db.update(db.recordings)..where((t) => t.id.equals(rec.id))).write(
            RecordingsCompanion(audioPath: Value(newPath)),
          );
        }
      }
    } catch (e) {
      debugPrint('Error re-anchoring database device paths: $e');
    }
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref);
});
