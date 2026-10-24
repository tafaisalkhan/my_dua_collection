import 'package:just_audio/just_audio.dart';

/// Keeps in-app audio exclusive so two Dua voices can never overlap.
class AudioPlaybackCoordinator {
  AudioPlaybackCoordinator._();

  static final instance = AudioPlaybackCoordinator._();

  final Set<AudioPlayer> _players = <AudioPlayer>{};

  void register(AudioPlayer player) => _players.add(player);

  void unregister(AudioPlayer player) => _players.remove(player);

  Future<void> stopOthers(AudioPlayer current) async {
    register(current);
    for (final player in List<AudioPlayer>.of(_players)) {
      if (!identical(player, current)) {
        try {
          await player.stop();
        } catch (_) {
          _players.remove(player);
        }
      }
    }
  }

  Future<void> stopAll() async {
    for (final player in List<AudioPlayer>.of(_players)) {
      try {
        await player.stop();
      } catch (_) {
        _players.remove(player);
      }
    }
  }
}
