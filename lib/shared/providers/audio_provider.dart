import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/novel_model.dart';

enum AudioState { idle, loading, playing, paused }
// Alias for new code using AudioStatus
typedef AudioStatus = AudioState;

class AudioPlayerState {
  final AudioState state;
  final Novel? novel;
  final Chapter? chapter;
  final Duration position;
  final Duration duration;
  final double speed;
  final bool isVisible;

  const AudioPlayerState({
    this.state = AudioState.idle,
    this.novel,
    this.chapter,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.isVisible = false,
  });

  bool get isPlaying => state == AudioState.playing;
  bool get isLoading => state == AudioState.loading;

  // Convenience accessors matching new UI code
  Novel? get currentNovel => novel;
  Chapter? get currentChapter => chapter;
  AudioState get status => state;

  double get progress =>
      duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0.0;

  String get positionLabel => _formatDuration(position);
  String get durationLabel => _formatDuration(duration);

  static String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  AudioPlayerState copyWith({
    AudioState? state,
    Novel? novel,
    Chapter? chapter,
    Duration? position,
    Duration? duration,
    double? speed,
    bool? isVisible,
  }) {
    return AudioPlayerState(
      state: state ?? this.state,
      novel: novel ?? this.novel,
      chapter: chapter ?? this.chapter,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(const AudioPlayerState());

  void loadNovel(Novel novel, Chapter chapter) => loadChapter(novel, chapter);

  void seek(Duration position) => seekTo(position);

  void loadChapter(Novel novel, Chapter chapter) {
    state = state.copyWith(
      novel: novel,
      chapter: chapter,
      state: AudioState.loading,
      position: Duration.zero,
      duration: chapter.audioDuration ?? const Duration(minutes: 10),
      isVisible: true,
    );
    // Simulate load then play
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        state = state.copyWith(state: AudioState.playing);
        _simulateProgress();
      }
    });
  }

  void _simulateProgress() async {
    while (mounted && state.isPlaying) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !state.isPlaying) break;
      final newPos = state.position + Duration(seconds: state.speed.round());
      if (newPos >= state.duration) {
        state = state.copyWith(
          position: state.duration,
          state: AudioState.paused,
        );
        break;
      }
      state = state.copyWith(position: newPos);
    }
  }

  void play() {
    if (state.state == AudioState.paused) {
      state = state.copyWith(state: AudioState.playing);
      _simulateProgress();
    }
  }

  void pause() {
    state = state.copyWith(state: AudioState.paused);
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(Duration position) {
    state = state.copyWith(position: position);
  }

  void seekForward() {
    final newPos = state.position + const Duration(seconds: 15);
    seekTo(newPos > state.duration ? state.duration : newPos);
  }

  void seekBackward() {
    final newPos = state.position - const Duration(seconds: 15);
    seekTo(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  void hide() {
    state = state.copyWith(isVisible: false);
    pause();
  }

  void show() {
    state = state.copyWith(isVisible: true);
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
  (ref) => AudioPlayerNotifier(),
);
