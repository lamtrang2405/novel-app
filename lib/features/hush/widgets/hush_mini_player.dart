import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/hush_colors.dart';
import '../providers/hush_player_provider.dart';
import 'hush_player_panel.dart';

class HushMiniPlayer extends ConsumerWidget {
  const HushMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hushPlayerProvider);
    final story = state.story;
    if (story == null) return const SizedBox.shrink();

    final ep = state.currentEpisode;
    final subtitle = ep != null
        ? 'Ep ${state.episodeIndex + 1} • ${ep.title}'
        : '';

    return GestureDetector(
      onTap: () => _openFullPlayer(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        height: 60,
        decoration: BoxDecoration(
          color: HushColors.bgUp,
          border: Border.all(color: HushColors.brdLt),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 28,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth * state.progress,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: HushColors.grad,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: story.background,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          story.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: HushColors.t1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 11, color: HushColors.t2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(hushPlayerProvider.notifier).togglePlayPause();
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: HushColors.grad,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: HushColors.blushGlow,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => const HushPlayerPanel(),
    );
  }
}
