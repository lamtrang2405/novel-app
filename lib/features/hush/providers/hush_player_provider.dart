import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hush_story.dart';
import '../data/hush_data.dart';

class HushPlaybackState {
  final HushStory? story;
  final int episodeIndex;
  final bool isPlaying;
  final double progress; // 0..1
  final double speed;

  const HushPlaybackState({
    this.story,
    this.episodeIndex = 0,
    this.isPlaying = false,
    this.progress = 0.0,
    this.speed = 1.0,
  });

  HushEpisode? get currentEpisode =>
      story != null && episodeIndex < story!.episodes.length
          ? story!.episodes[episodeIndex]
          : null;

  HushPlaybackState copyWith({
    HushStory? story,
    int? episodeIndex,
    bool? isPlaying,
    double? progress,
    double? speed,
  }) {
    return HushPlaybackState(
      story: story ?? this.story,
      episodeIndex: episodeIndex ?? this.episodeIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      progress: progress ?? this.progress,
      speed: speed ?? this.speed,
    );
  }
}

class HushPlayerNotifier extends StateNotifier<HushPlaybackState> {
  Timer? _progressTimer;

  HushPlayerNotifier() : super(const HushPlaybackState());

  void playStory(HushStory story, [int episodeIndex = 0]) {
    state = HushPlaybackState(
      story: story,
      episodeIndex: episodeIndex.clamp(0, story.episodes.length - 1),
      isPlaying: true,
      progress: 0.0,
      speed: state.speed,
    );
    _startProgressSimulation();
  }

  void togglePlayPause() {
    if (state.story == null) return;
    if (state.isPlaying) {
      _progressTimer?.cancel();
      state = state.copyWith(isPlaying: false);
    } else {
      state = state.copyWith(isPlaying: true);
      _startProgressSimulation();
    }
  }

  void _startProgressSimulation() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!state.isPlaying || state.story == null) return;
      double next = state.progress + 0.002;
      if (next >= 1.0) {
        next = 0.0;
        _progressTimer?.cancel();
      }
      state = state.copyWith(progress: next.clamp(0.0, 1.0));
    });
  }

  void seek(double progress) {
    state = state.copyWith(progress: progress.clamp(0.0, 1.0));
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  static const List<double> speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  void cycleSpeed() {
    final idx = speeds.indexOf(state.speed);
    final next = speeds[(idx + 1) % speeds.length];
    state = state.copyWith(speed: next);
  }

  void nextEpisode() {
    if (state.story == null) return;
    final eps = state.story!.episodes;
    if (state.episodeIndex < eps.length - 1) {
      playStory(state.story!, state.episodeIndex + 1);
    }
  }

  void previousEpisode() {
    if (state.story == null) return;
    if (state.episodeIndex > 0) {
      playStory(state.story!, state.episodeIndex - 1);
    }
  }

  void close() {
    _progressTimer?.cancel();
    state = const HushPlaybackState();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }
}

final hushPlayerProvider =
    StateNotifierProvider<HushPlayerNotifier, HushPlaybackState>((ref) {
  return HushPlayerNotifier();
});

class HushResumeItem {
  final HushStory story;
  final int episodeIndex;
  const HushResumeItem(this.story, this.episodeIndex);
}

/// Resume items for "Pick up where you left"
final hushResumeItemsProvider = Provider<List<HushResumeItem>>((ref) {
  return [
    HushResumeItem(getHushStoryById('neighbor')!, 2),
    HushResumeItem(getHushStoryById('professor')!, 0),
    HushResumeItem(getHushStoryById('barista')!, 5),
  ];
});
