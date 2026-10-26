import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Keeps a saved YouTube attachment in the Dua view with local playback controls.
class InlineYoutubePlayer extends StatefulWidget {
  const InlineYoutubePlayer({super.key, required this.url});

  final String url;

  @override
  State<InlineYoutubePlayer> createState() => _InlineYoutubePlayerState();
}

class _InlineYoutubePlayerState extends State<InlineYoutubePlayer> {
  WebViewController? _controller;
  bool _playing = false;
  bool _loaded = false;
  bool _error = false;

  static String? _videoId(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null || !['http', 'https'].contains(uri.scheme)) return null;
    final host = uri.host.toLowerCase();
    String? id;
    if (host == 'youtu.be' || host.endsWith('.youtu.be')) {
      id = uri.pathSegments.firstOrNull;
    } else if (host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com')) {
      if (uri.path == '/watch') {
        id = uri.queryParameters['v'];
      } else if (uri.pathSegments.length >= 2 &&
          ['shorts', 'live', 'embed', 'v'].contains(uri.pathSegments.first)) {
        id = uri.pathSegments[1];
      }
    }
    return id != null && RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(id)
        ? id
        : null;
  }

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void didUpdateWidget(covariant InlineYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _playing = false;
      _loaded = false;
      _error = false;
      _loadVideo();
    }
  }

  void _loadVideo() {
    final id = _videoId(widget.url);
    if (id == null) {
      _controller = null;
      return;
    }
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF101411))
      ..addJavaScriptChannel(
        'PlayerState',
        onMessageReceived: (message) {
          if (!mounted) return;
          setState(() {
            switch (message.message) {
              case 'ready':
                _loaded = true;
              case 'playing':
                _playing = true;
              case 'paused':
                _playing = false;
              case 'error':
                _error = true;
            }
          });
        },
      );
    _controller = controller;
    controller.loadHtmlString('''
<!doctype html>
<html><head><meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<style>html,body,#player{margin:0;width:100%;height:100%;background:#101411;overflow:hidden}</style>
</head><body><div id="player"></div>
<script src="https://www.youtube.com/iframe_api"></script>
<script>
  var player;
  function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
      videoId: '$id',
      width: '100%', height: '100%',
      playerVars: { playsinline: 1, rel: 0, modestbranding: 1 },
      events: {
        onReady: function() { PlayerState.postMessage('ready'); },
        onError: function() { PlayerState.postMessage('error'); },
        onStateChange: function(event) {
          if (event.data === YT.PlayerState.PLAYING) PlayerState.postMessage('playing');
          if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) PlayerState.postMessage('paused');
        }
      }
    });
  }
  function control(action) {
    if (!player || !player.getCurrentTime) return;
    if (action === 'play') player.playVideo();
    if (action === 'pause') player.pauseVideo();
    if (action === 'back') player.seekTo(Math.max(0, player.getCurrentTime() - 10), true);
    if (action === 'forward') player.seekTo(player.getCurrentTime() + 10, true);
  }
</script></body></html>
''', baseUrl: 'https://www.youtube.com');
  }

  Future<void> _control(String action) async {
    final controller = _controller;
    if (controller == null || !_loaded) return;
    try {
      await controller.runJavaScript("control('$action');");
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video controls are not ready yet.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final controller = _controller;
    if (controller == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('This YouTube link cannot be embedded.'),
      );
    }
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (!_loaded && !_error)
                  const Center(child: CircularProgressIndicator()),
                if (_error)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'This video does not allow in-app playback.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Back 10 seconds',
              onPressed: _loaded ? () => _control('back') : null,
              icon: const Icon(Icons.replay_10_rounded),
              color: colors.primary,
            ),
            IconButton.filledTonal(
              tooltip: _playing ? 'Pause video' : 'Play video',
              onPressed: _loaded
                  ? () => _control(_playing ? 'pause' : 'play')
                  : null,
              icon: Icon(
                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
            IconButton(
              tooltip: 'Forward 10 seconds',
              onPressed: _loaded ? () => _control('forward') : null,
              icon: const Icon(Icons.forward_10_rounded),
              color: colors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
