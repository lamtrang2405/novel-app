import 'package:flutter/material.dart';
import '../../../core/theme/hush_colors.dart';
import '../models/hush_story.dart';

class HushStoryDetailSheet extends StatelessWidget {
  final HushStory story;
  final VoidCallback onPlay;
  final void Function(int episodeIndex) onPlayEpisode;

  const HushStoryDetailSheet({
    super.key,
    required this.story,
    required this.onPlay,
    required this.onPlayEpisode,
  });

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    final currentIndex = story.episodes.indexWhere((e) => e.isCurrent);
    final playLabel = currentIndex >= 0
        ? 'Continue Ep ${currentIndex + 1}'
        : 'Play Episode 1';

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.88,
      decoration: const BoxDecoration(
        color: HushColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 34,
            height: 4,
            decoration: BoxDecoration(
              color: HushColors.t3.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 290,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: story.background,
                        ),
                      ),
                      Positioned(
                        top: safeTop + 8,
                        left: 14,
                        child: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                                HushColors.bg,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: story.tags.map((t) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    t,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HushColors.t2),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              story.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              story.meta,
                              style: TextStyle(fontSize: 13, color: HushColors.t2),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: HushColors.emerald,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  story.liveCount,
                                  style: TextStyle(fontSize: 11, color: HushColors.t2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    onPlayEpisode(currentIndex >= 0 ? currentIndex : 0);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: HushColors.grad,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          playLabel,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _DetailActionButton(icon: Icons.bookmark_outline_rounded),
                            const SizedBox(width: 8),
                            _DetailActionButton(icon: Icons.share_outlined),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          story.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: HushColors.t2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Episodes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: HushColors.t1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...story.episodes.asMap().entries.map((e) {
                          final i = e.key;
                          final ep = e.value;
                          final isCurrent = ep.isCurrent;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                onPlayEpisode(i);
                                onPlay();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: isCurrent ? HushColors.blush : HushColors.bgCard,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: isCurrent
                                          ? const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 14)
                                          : Text(
                                              '${i + 1}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: HushColors.t2,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ep.title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: HushColors.t1,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            isCurrent ? 'Playing now' : 'Ep ${i + 1}',
                                            style: TextStyle(fontSize: 12, color: HushColors.t3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      ep.duration,
                                      style: TextStyle(fontSize: 13, color: HushColors.t3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  final IconData icon;

  const _DetailActionButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HushColors.bgCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: HushColors.brd),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: HushColors.t2),
        ),
      ),
    );
  }
}
