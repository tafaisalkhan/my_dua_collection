abstract interface class BackupService {
  Future<String> createBackup();
  Future<void> restoreBackup(String path);
}
