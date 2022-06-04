import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AppAudioHandler> initAudioHandler() {
  return AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.failfast.channel.player',
      androidNotificationChannelName: 'asmixer',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AppAudioHandler extends BaseAudioHandler {
  final _playlist = ConcatenatingAudioSource(children: []);
  final _player = AudioPlayer();

  AppAudioHandler() {
    _listenForCurrentSongIndexChanges();
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Future<void> play() async => _player.play();

  // {
  //   if (_player.audioSource == null) {
  //     _player.setAudioSource(_playlist);
  //   }
  //   _player.play();
  // }

  @override
  Future<void> pause() async => _player.pause();

  @override
  Future<void> stop() async {
    //TODO: check if all those actions are necessary
    _player.stop();
    _playlist.clear();
    queue.value.clear();
    _player.setAudioSource(_playlist);
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
    _player.play();
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList()); // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);

    //hack for lib bug in currentIndexStream
    if (_playlist.length == mediaItems.length) {
      mediaItem.add(queue.value[0]);
    }
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      File(mediaItem.extras!['path']).uri,
      tag: mediaItem,
    );
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }
}
