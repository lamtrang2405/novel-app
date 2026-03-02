import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/audio_provider.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  ConsumerState<AudioPlayerScreen> createState() =>
      _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);
    final novel = state.currentNovel;
    if (novel == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isPlaying = state.status == AudioStatus.playing;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Blurred cover background
          _BlurredBackground(coverUrl: novel.coverUrl),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Album art
                        _AlbumArt(
                          coverUrl: novel.coverUrl,
                          isPlaying: isPlaying,
                          pulseController: _pulseController,
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              duration: 600.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: 32),

                        // Track info
                        Text(
                          novel.title.toUpperCase(),
                          style: AppTextStyles.titleLarge(
                              color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                            .animate(delay: 100.ms)
                            .fadeIn(duration: 400.ms),
                        const SizedBox(height: 6),
                        Text(
                          state.currentChapter?.title ?? 'Chapter 1',
                          style: AppTextStyles.bodyMedium(
                              color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        )
                            .animate(delay: 150.ms)
                            .fadeIn(duration: 400.ms),

                        const SizedBox(height: 32),

                        // Progress
                        _ProgressBar(
                          position: state.position,
                          duration: state.duration,
                          onSeek: notifier.seek,
                        )
                            .animate(delay: 200.ms)
                            .fadeIn(duration: 400.ms),

                        const SizedBox(height: 24),

                        // Speed selector
                        _SpeedSelector(
                          currentSpeed: state.speed,
                          onSpeedSelected: notifier.setSpeed,
                        )
                            .animate(delay: 250.ms)
                            .fadeIn(duration: 400.ms),

                        const SizedBox(height: 28),

                        // Main controls
                        _Controls(
                          isPlaying: isPlaying,
                          onPlay: notifier.play,
                          onPause: notifier.pause,
                          onSkipBack: () {
                            final p = state.position - const Duration(seconds: 10);
                            notifier.seek(p < Duration.zero ? Duration.zero : p);
                          },
                          onSkipForward: () {
                            final p = state.position + const Duration(seconds: 30);
                            notifier.seek(p > state.duration ? state.duration : p);
                          },
                          onPrevChapter: () {},
                          onNextChapter: () {},
                        )
                            .animate(delay: 300.ms)
                            .fadeIn(duration: 400.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'NOW PLAYING',
            style: AppTextStyles.labelSmall(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Blurred background ────────────────────────────────────────────────────────
class _BlurredBackground extends StatelessWidget {
  final String coverUrl;

  const _BlurredBackground({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: coverUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            decoration: const BoxDecoration(
                gradient: AppColors.dramaticGradient),
          ),
        ),
        Container(color: AppColors.bgDeep.withValues(alpha: 0.85)),
        // Neon glow overlays
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Album art ─────────────────────────────────────────────────────────────────
class _AlbumArt extends StatelessWidget {
  final String coverUrl;
  final bool isPlaying;
  final AnimationController pulseController;

  const _AlbumArt({
    required this.coverUrl,
    required this.isPlaying,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glowSize = isPlaying ? 20.0 + pulseController.value * 20 : 10.0;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isPlaying ? 0.4 : 0.15),
                blurRadius: glowSize,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: isPlaying ? 0.25 : 0.1),
                blurRadius: glowSize * 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: isPlaying ? 260 : 240,
          height: isPlaying ? 260 : 240,
          child: CachedNetworkImage(
            imageUrl: coverUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              decoration: const BoxDecoration(
                  gradient: AppColors.dramaticGradient),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final void Function(Duration) onSeek;

  const _ProgressBar({
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        // Track
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (v) {
              onSeek(Duration(
                  milliseconds: (v * duration.inMilliseconds).round()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmt(position),
                style: AppTextStyles.bodySmall(color: AppColors.textHint),
              ),
              Text(
                _fmt(duration),
                style: AppTextStyles.bodySmall(color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Speed selector ────────────────────────────────────────────────────────────
class _SpeedSelector extends StatelessWidget {
  final double currentSpeed;
  final void Function(double) onSpeedSelected;

  const _SpeedSelector(
      {required this.currentSpeed, required this.onSpeedSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SPEED  ',
          style: AppTextStyles.labelSmall(color: AppColors.textHint),
        ),
        ...AppConstants.playbackSpeeds.map((s) {
          final isActive = (s - currentSpeed).abs() < 0.01;
          return GestureDetector(
            onTap: () => onSpeedSelected(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                color: isActive ? null : AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive ? AppColors.neonPinkGlow(blur: 8) : [],
              ),
              child: Text(
                '${s}x',
                style: AppTextStyles.labelSmall(
                  color: isActive ? Colors.white : AppColors.textHint,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── Controls ──────────────────────────────────────────────────────────────────
class _Controls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;
  final VoidCallback onPrevChapter;
  final VoidCallback onNextChapter;

  const _Controls({
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
    required this.onSkipBack,
    required this.onSkipForward,
    required this.onPrevChapter,
    required this.onNextChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlBtn(
          icon: Icons.skip_previous_rounded,
          size: 28,
          onTap: onPrevChapter,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        _ControlBtn(
          icon: Icons.replay_10_rounded,
          size: 32,
          onTap: onSkipBack,
          color: AppColors.textPrimary,
        ),
        const SizedBox(width: 16),
        _PlayPauseBtn(
          isPlaying: isPlaying,
          onPlay: onPlay,
          onPause: onPause,
        ),
        const SizedBox(width: 16),
        _ControlBtn(
          icon: Icons.forward_30_rounded,
          size: 32,
          onTap: onSkipForward,
          color: AppColors.textPrimary,
        ),
        const SizedBox(width: 8),
        _ControlBtn(
          icon: Icons.skip_next_rounded,
          size: 28,
          onTap: onNextChapter,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _PlayPauseBtn extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onPause;

  const _PlayPauseBtn({
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
  });

  @override
  State<_PlayPauseBtn> createState() => _PlayPauseBtnState();
}

class _PlayPauseBtnState extends State<_PlayPauseBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (widget.isPlaying) {
          widget.onPause();
        } else {
          widget.onPlay();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppColors.neonPinkGlow(blur: 24, spread: 2),
          ),
          child: Icon(
            widget.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;
  final Color color;

  const _ControlBtn({
    required this.icon,
    required this.size,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}
