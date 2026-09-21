import '../entities/dua_recording.dart';

abstract interface class RecordingRepository {
  Stream<List<DuaRecording>> watchForDua(String duaId);
  Future<void> save(DuaRecording recording);
  Future<void> delete(String id);
}
