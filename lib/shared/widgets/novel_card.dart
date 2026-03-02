import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../models/novel_model.dart';

// ── Vertical card (for shelves) ───────────────────────────────────────────────
class NovelCard extends StatelessWidget {
  final Novel novel;

  const NovelCard({super.key, required this.novel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/novel/${novel.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _CoverWithBadges(novel: novel),
          ),
          const SizedBox(height: 6),
          Text(
            novel.title,
            style: AppTextStyles.titleSmall(color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            novel.authorName,
            style: AppTextStyles.bodySmall(color: AppColors.textHint),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Cover with badges ─────────────────────────────────────────────────────────
class _CoverWithBadges extends StatelessWidget {
  final Novel novel;

  const _CoverWithBadges({required this.novel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover image
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: novel.coverUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, err) => Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.dramaticGradient,
                  ),
                ),
              ),
              // Bottom fade
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // Audio indicator
              if (novel.hasAudio)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.headphones_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Top-left badge
        if (novel.isHot || novel.isNew)
          Positioned(
            top: 6,
            left: 6,
            child: _Badge(novel: novel),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final Novel novel;

  const _Badge({required this.novel});

  @override
  Widget build(BuildContext context) {
    if (novel.isHot) {
      return _BadgeChip(
        label: '🔥',
        gradient: AppColors.primaryGradient,
        glow: AppColors.neonPinkGlow(blur: 8),
      );
    }
    if (novel.isNew) {
      return _BadgeChip(
        label: '✨',
        gradient: AppColors.cyanGradient,
      );
    }
    return const SizedBox.shrink();
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final LinearGradient gradient;
  final List<BoxShadow>? glow;

  const _BadgeChip(
      {required this.label, required this.gradient, this.glow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(6),
        boxShadow: glow,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}

// ── Wide card (for lists) ─────────────────────────────────────────────────────
class NovelCardWide extends StatefulWidget {
  final Novel novel;

  const NovelCardWide({super.key, required this.novel});

  @override
  State<NovelCardWide> createState() => _NovelCardWideState();
}

class _NovelCardWideState extends State<NovelCardWide> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final novel = widget.novel;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.go('/novel/${novel.id}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.diagonal3Values(
          _pressed ? 0.98 : 1.0,
          _pressed ? 0.98 : 1.0,
          1.0,
        ),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              // Cover
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 76,
                  height: 110,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: novel.coverUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, err) => Container(
                          decoration: const BoxDecoration(
                              gradient: AppColors.dramaticGradient),
                        ),
                      ),
                      if (novel.hasAudio)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.headphones_rounded,
                              size: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _GenreTag(novel: novel),
                              const Spacer(),
                              if (novel.isHot || novel.isNew)
                                _SmallBadge(novel: novel),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            novel.title,
                            style: AppTextStyles.titleSmall(
                                color: AppColors.textPrimary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.gold, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            novel.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall(
                                color: AppColors.gold),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${novel.chapters.length} ch',
                            style: AppTextStyles.bodySmall(
                                color: AppColors.textHint),
                          ),
                          const Spacer(),
                          _StatusDot(status: novel.status),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenreTag extends StatelessWidget {
  final Novel novel;

  const _GenreTag({required this.novel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        novel.genreLabel.toUpperCase(),
        style: AppTextStyles.labelSmall(color: AppColors.primary),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final Novel novel;

  const _SmallBadge({required this.novel});

  @override
  Widget build(BuildContext context) {
    if (novel.isHot) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '🔥 HOT',
          style: AppTextStyles.labelSmall(color: Colors.white),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        gradient: AppColors.cyanGradient,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '✨ NEW',
        style: AppTextStyles.labelSmall(color: Colors.white),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final NovelStatus status;

  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case NovelStatus.completed:
        color = AppColors.success;
        label = 'DONE';
      case NovelStatus.ongoing:
        color = AppColors.cyan;
        label = 'LIVE';
      case NovelStatus.hiatus:
        color = AppColors.warning;
        label = 'PAUSE';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.labelSmall(color: color),
        ),
      ],
    );
  }
}
