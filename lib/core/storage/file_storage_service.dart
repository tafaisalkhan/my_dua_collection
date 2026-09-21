abstract interface class FileStorageService {
  Future<String> saveImage(String duaId, String sourcePath);
  Future<String> recordingPath(String duaId, String recordingId);
  Future<void> deleteDuaFiles(String duaId);
}
