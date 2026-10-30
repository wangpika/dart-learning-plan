import 'dart:async';

enum PlaybackStatus { idle, playing, paused, buffering, completed }

class PlaybackEvent {
  final PlaybackStatus status;
  final Duration position;
  final Duration duration;

  const PlaybackEvent({
    required this.status,
    required this.position,
    required this.duration,
  });

  @override
  String toString() {
    return 'PlaybackEvent('
        'status: $status, '
        'position: ${position.inSeconds}s, '
        'duration: ${duration.inSeconds}s)';
  }
}

typedef PlayerEventCallback = void Function(PlaybackEvent event);

class FakeNativePlayer {
  PlayerEventCallback? onEvent;
  void play() {
    onEvent?.call(
      const PlaybackEvent(
        status: PlaybackStatus.playing,
        position: Duration.zero,
        duration: Duration(seconds: 300),
      ),
    );
  }

  void pause() {
    onEvent?.call(
      const PlaybackEvent(
        status: PlaybackStatus.paused,
        position: Duration(seconds: 30),
        duration: Duration(seconds: 300),
      ),
    );
  }

  void reportBuffering() {
    onEvent?.call(
      const PlaybackEvent(
        status: PlaybackStatus.buffering,
        position: Duration(seconds: 30),
        duration: Duration(seconds: 300),
      ),
    );
  }

  void complete() {
    onEvent?.call(
      const PlaybackEvent(
        status: PlaybackStatus.completed,
        position: Duration(seconds: 300),
        duration: Duration(seconds: 300),
      ),
    );
  }

  void dispose() {
    print('Native player disposed');
  }
}

class PlaybackService {
  final FakeNativePlayer _player;

  late final StreamController<PlaybackEvent> _controller;

  PlaybackService(this._player) {
    // TODO 1: Create a broadcast StreamController.
    _controller = StreamController<PlaybackEvent>.broadcast();
    // TODO 2: Register a callback with the native player.
    // Whenever the player emits an event, add it to the controller.
    _player.onEvent = (event) => _controller.add(event);
  }

  // TODO 3: Expose the Stream, not the controller.
  Stream<PlaybackEvent> get events {
    return _controller.stream;
  }

  void play() {
    _player.play();
  }

  void pause() {
    _player.pause();
  }

  void reportBuffering() {
    _player.reportBuffering();
  }

  void complete() {
    _player.complete();
  }

  // TODO 4: Implement proper cleanup.
  Future<void> dispose() async {
    _player.onEvent = null;
    await _controller.close();
    _player.dispose();
  }
}

Future<void> main() async {
  final player = FakeNativePlayer();
  final service = PlaybackService(player);

  final subscription1 = service.events.listen(
    (event) => print('UI: $event'),
  );

  final subscription2 = service.events.listen(
    (event) => print('Analytics: $event'),
  );

  service.play();
  service.reportBuffering();
  service.pause();
  service.complete();

  await service.dispose();

  await subscription1.cancel();
  await subscription2.cancel();
}
