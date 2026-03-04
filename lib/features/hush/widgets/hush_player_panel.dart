import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/hush_colors.dart';
import '../providers/hush_player_provider.dart';

class HushPlayerPanel extends ConsumerStatefulWidget {
  const HushPlayerPanel({super.key});

  @override
  ConsumerState<HushPlayerPanel> createState() => _HushPlayerPanelState();
}

class _HushPlayerPanelState extends ConsumerState<HushPlayerPanel> {
  Timer? _waveTimer;

  @override
  void initState() {
    super.initState();
    _startWaveAnimation();
  }

  void _startWaveAnimation() {
    _waveTimer?.cancel();
    _waveTimer = Timer.periodic(const Duration(milliseconds: 130), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _waveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hushPlayerProvider);
    final story = state.story;
    if (story == null) {
      Navigator.of(context).pop();
      return const SizedBox.shrink();
    }

    final ep = state.currentEpisode;
    final durationSec = 22 * 60 + 30; // mock total seconds
    final currentSec = (durationSec * state.progress).floor();
    final currentStr = '${currentSec ~/ 60}:${(currentSec % 60).toString().padLeft(2, '0')}';
    const totalStr = '22:30';

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      decoration: BoxDecoration(
        color: HushColors.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: story.playerBackground,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: HushColors.t1, size: 32),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Text(
                            'NOW PLAYING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: HushColors.t2,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_horiz_rounded, color: HushColors.t2, size: 24),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Container(
                        width: 290,
                        height: 290,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: story.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 60,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: HushColors.blushDim,
                              blurRadius: 90,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(40, (i) {
                                  final rnd = (math.Random(i + (state.progress * 100).toInt()).nextDouble() * 50 + 4);
                                  return Container(
                                    width: 3,
                                    height: state.isPlaying ? rnd : 4,
                                    margin: const EdgeInsets.symmetric(horizontal: 1),
                                    decoration: BoxDecoration(
                                      gradient: HushColors.grad,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          story.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: HushColors.t1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.artist,
                          style: TextStyle(fontSize: 14, color: HushColors.t2),
                        ),
                        if (ep != null)
                          Text(
                            'Episode ${state.episodeIndex + 1} • ${ep.title}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: HushColors.blush,
                            ),
                          ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTapDown: (d) {
                            final box = context.findRenderObject() as RenderBox?;
                            if (box == null) return;
                            final local = box.globalToLocal(d.globalPosition);
                            final w = context.size?.width ?? 1;
                            final p = (local.dx / w).clamp(0.0, 1.0);
                            ref.read(hushPlayerProvider.notifier).seek(p);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.07),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, c) {
                                    return Stack(
                                      children: [
                                        SizedBox(
                                          width: c.maxWidth * state.progress,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: HushColors.grad,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentStr,
                                    style: TextStyle(fontSize: 12, color: HushColors.t3, fontFeatures: [const FontFeature.tabularFigures()]),
                                  ),
                                  Text(
                                    totalStr,
                                    style: TextStyle(fontSize: 12, color: HushColors.t3, fontFeatures: [const FontFeature.tabularFigures()]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _PlayerIconButton(icon: Icons.bedtime_outlined, label: 'Sleep', onTap: () {}),
                            const SizedBox(width: 24),
                            _PlayerIconButton(
                              icon: Icons.speed_rounded,
                              label: '${state.speed}x',
                              onTap: () => ref.read(hushPlayerProvider.notifier).cycleSpeed(),
                            ),
                            const SizedBox(width: 24),
                            _PlayerIconButton(icon: Icons.favorite_border_rounded, label: 'Like', onTap: () {}),
                            const SizedBox(width: 24),
                            _PlayerIconButton(icon: Icons.bookmark_outline_rounded, label: 'Save', onTap: () {}),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.skip_previous_rounded, color: HushColors.t2, size: 28),
                              onPressed: () => ref.read(hushPlayerProvider.notifier).previousEpisode(),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => ref.read(hushPlayerProvider.notifier).togglePlayPause(),
                              child: Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  gradient: HushColors.grad,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: HushColors.blushGlow,
                                      blurRadius: 28,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.skip_next_rounded, color: HushColors.t2, size: 28),
                              onPressed: () => ref.read(hushPlayerProvider.notifier).nextEpisode(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
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
}

class _PlayerIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PlayerIconButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: HushColors.t2),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: HushColors.t3, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
