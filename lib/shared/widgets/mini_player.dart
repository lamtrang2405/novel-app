import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/audio_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);

    if (state.currentNovel == null) return const SizedBox.shrink();

    final novel = state.currentNovel!;
    final isPlaying = state.status == AudioStatus.playing;

    return GestureDetector(
      onTap: () => context.go('/audio-player'),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: AppColors.bgCardAlt,
          border: Border(
            top: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Cover
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
              ),
              child: SizedBox(
                width: 62,
                height: 62,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: novel.coverUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                            gradient: AppColors.dramaticGradient),
                      ),
                    ),
                    // Neon left border indicator
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 3,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title and chapter
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    novel.title,
                    style: AppTextStyles.titleSmall(
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isPlaying
                              ? AppColors.primary
                              : AppColors.textHint,
                          shape: BoxShape.circle,
                          boxShadow: isPlaying
                              ? AppColors.neonPinkGlow(blur: 6)
                              : [],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        state.currentChapter?.title ?? 'Chapter',
                        style: AppTextStyles.bodySmall(
                            color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Controls
            _MiniControl(
              icon: Icons.replay_10_rounded,
              onTap: () {
                final p = state.position - const Duration(seconds: 10);
                notifier.seek(p < Duration.zero ? Duration.zero : p);
              },
            ),
            _MiniPlayPause(isPlaying: isPlaying, onTap: () {
              if (isPlaying) {
                notifier.pause();
              } else {
                notifier.play();
              }
            }),
            _MiniControl(
              icon: Icons.forward_10_rounded,
              onTap: () {
                final p = state.position + const Duration(seconds: 10);
                notifier.seek(p > state.duration ? state.duration : p);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _MiniControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniControl({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 20,
      color: AppColors.textSecondary,
      onPressed: onTap,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}

class _MiniPlayPause extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const _MiniPlayPause({required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: AppColors.neonPinkGlow(blur: 12),
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
