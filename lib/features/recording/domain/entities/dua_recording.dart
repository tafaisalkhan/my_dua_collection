class DuaRecording {
  const DuaRecording({
    required this.id,
    required this.duaId,
    required this.audioPath,
    required this.durationMs,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id, duaId, audioPath;
  final int durationMs;
  final DateTime createdAt, updatedAt;
}
