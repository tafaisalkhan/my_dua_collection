abstract interface class AudioPlayerService {
  Future<void> play(String path);
  Future<void> pause();
  Future<void> stop();
}
