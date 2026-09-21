abstract interface class AudioRecorderService {
  Future<void> start(String outputPath);
  Future<String?> stop();
  Future<void> cancel();
}
