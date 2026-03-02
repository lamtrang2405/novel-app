import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/novel_model.dart';
import '../../shared/providers/novels_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/providers/audio_provider.dart';
import '../../shared/widgets/gradient_button.dart';

class NovelDetailScreen extends ConsumerStatefulWidget {
  final String novelId;

  const NovelDetailScreen({super.key, required this.novelId});

  @override
  ConsumerState<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends ConsumerState<NovelDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final novel = ref.watch(novelByIdProvider(widget.novelId));
    if (novel == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroAppBar(context, novel),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(context, novel),
                  const SizedBox(height: 16),
                  _buildStatsRow(novel),
                  const SizedBox(height: 20),
                  _buildActionButtons(context, novel),
                  const SizedBox(height: 24),
                  _buildSynopsis(novel),
                  const SizedBox(height: 24),
                  _buildTagsRow(novel),
                  const SizedBox(height: 28),
                  _buildChapterHeader(novel),
                ],
              ),
            ),
          ),
          _buildChapterList(context, novel),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  // ── Hero app bar ──────────────────────────────────────────────────────────
  Widget _buildHeroAppBar(BuildContext context, Novel novel) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.bgDark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 16),
        ),
      ),
      actions: [
        _BookmarkButton(novelId: novel.id),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: novel.coverUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, err) => Container(
                  decoration: const BoxDecoration(
                      gradient: AppColors.dramaticGradient)),
            ),
            // Deep gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Color(0xCC000000),
                    AppColors.bgDark,
                  ],
                  stops: [0.0, 0.65, 1.0],
                ),
              ),
            ),
            // Genre badge bottom-left
            Positioned(
              bottom: 16,
              left: 20,
              child: _GenrePill(genre: novel.genreLabel),
            ),
            // Hot badge
            if (novel.isHot)
              Positioned(
                top: MediaQuery.of(context).padding.top + 56,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: AppColors.neonPinkGlow(blur: 12),
                  ),
                  child: Text(
                    '🔥 TRENDING',
                    style: AppTextStyles.labelSmall(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Title section ─────────────────────────────────────────────────────────
  Widget _buildTitleSection(BuildContext context, Novel novel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          novel.title.toUpperCase(),
          style: AppTextStyles.displaySmall(color: AppColors.textPrimary),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.person_outline_rounded,
                size: 14, color: AppColors.textHint),
            const SizedBox(width: 4),
            Text(
              novel.authorName,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow(Novel novel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoStat(
            value: novel.rating.toStringAsFixed(1),
            label: 'RATING',
            icon: '⭐',
            color: AppColors.gold,
          ),
          _VertDivider(),
          _InfoStat(
            value: novel.viewCountLabel,
            label: 'READS',
            icon: '👁',
            color: AppColors.cyan,
          ),
          _VertDivider(),
          _InfoStat(
            value: '${novel.chapters.length}',
            label: 'CHAPTERS',
            icon: '📖',
            color: AppColors.primary,
          ),
          _VertDivider(),
          _InfoStat(
            value: novel.status == NovelStatus.completed
                ? 'DONE'
                : novel.status == NovelStatus.ongoing
                    ? 'LIVE'
                    : 'PAUSE',
            label: 'STATUS',
            icon: novel.status == NovelStatus.completed
                ? '✅'
                : novel.status == NovelStatus.ongoing
                    ? '🔴'
                    : '⏸',
            color: novel.status == NovelStatus.completed
                ? AppColors.success
                : novel.status == NovelStatus.ongoing
                    ? AppColors.primary
                    : AppColors.warning,
          ),
        ],
      ),
    );
  }

  // ── Action buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons(BuildContext context, Novel novel) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GradientButton(
            label: 'READ  →',
            onTap: () => context.go('/novel/${novel.id}/chapter/0'),
            height: 50,
            icon: const Icon(Icons.menu_book_rounded,
                color: Colors.white, size: 16),
          ),
        ),
        if (novel.hasAudio) ...[
          const SizedBox(width: 10),
          Expanded(
            child: _ListenButton(
              onTap: () {
                ref
                    .read(audioPlayerProvider.notifier)
                    .loadNovel(novel, novel.chapters.first);
                context.go('/audio-player');
              },
            ),
          ),
        ],
      ],
    );
  }

  // ── Synopsis ──────────────────────────────────────────────────────────────
  Widget _buildSynopsis(Novel novel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'SYNOPSIS'),
        const SizedBox(height: 10),
        AnimatedCrossFade(
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          firstChild: Text(
            novel.synopsis,
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            novel.synopsis,
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (r) =>
                    AppColors.primaryGradient.createShader(r),
                child: Text(
                  _expanded ? 'SHOW LESS ↑' : 'READ MORE ↓',
                  style: AppTextStyles.labelSmall(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Tags row ──────────────────────────────────────────────────────────────
  Widget _buildTagsRow(Novel novel) {
    const tags = ['Romance', 'Drama', 'Mystery', 'Thriller'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '#$tag',
            style: AppTextStyles.labelSmall(color: AppColors.accentLight),
          ),
        );
      }).toList(),
    );
  }

  // ── Chapter header ────────────────────────────────────────────────────────
  Widget _buildChapterHeader(Novel novel) {
    return Row(
      children: [
        _SectionLabel(label: 'CHAPTERS'),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${novel.chapters.length} total',
            style: AppTextStyles.bodySmall(color: AppColors.textHint),
          ),
        ),
      ],
    );
  }

  // ── Chapter list ─────────────────────────────────────────────────────────
  Widget _buildChapterList(BuildContext context, Novel novel) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final chapter = novel.chapters[i];
          final isFree = i < AppConstants.freeChaptersPerNovel;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: _ChapterTile(
              chapter: chapter,
              index: i,
              isFree: isFree,
              onTap: () => _handleChapterTap(context, novel, i, isFree),
            ),
          )
              .animate(delay: (i * 30).ms)
              .fadeIn(duration: 250.ms)
              .slideX(begin: 0.05, end: 0);
        },
        childCount: novel.chapters.length,
      ),
    );
  }

  void _handleChapterTap(
      BuildContext context, Novel novel, int index, bool isFree) {
    final user = ref.read(userProvider);
    if (isFree || user.hasActiveSubscription) {
      context.go('/novel/${novel.id}/chapter/$index');
    } else {
      _showUnlockDialog(context, novel, index);
    }
  }

  void _showUnlockDialog(BuildContext context, Novel novel, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCardAlt,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _UnlockSheet(
        novel: novel,
        chapterIndex: index,
        onUnlock: () {
          Navigator.pop(ctx);
          context.go('/novel/${novel.id}/chapter/$index');
        },
      ),
    );
  }
}

// ── Chapter tile ─────────────────────────────────────────────────────────────
class _ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final int index;
  final bool isFree;
  final VoidCallback onTap;

  const _ChapterTile({
    required this.chapter,
    required this.index,
    required this.isFree,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFree
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Chapter number
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient:
                    isFree ? AppColors.primaryGradient : null,
                color: isFree ? null : AppColors.bgCardAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.titleSmall(
                    color: isFree ? Colors.white : AppColors.textHint,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: AppTextStyles.titleSmall(
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${chapter.readingMinutes} min read',
                    style: AppTextStyles.bodySmall(
                        color: AppColors.textHint),
                  ),
                ],
              ),
            ),

            // Badge
            if (isFree)
              _FreeBadge()
            else
              _CoinBadge(cost: AppConstants.chapterCoinCost),
          ],
        ),
      ),
    );
  }
}

class _FreeBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.cyanGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'FREE',
        style: AppTextStyles.labelSmall(color: Colors.white),
      ),
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final int cost;

  const _CoinBadge({required this.cost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCardAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 3),
          Text(
            '$cost',
            style: AppTextStyles.labelSmall(color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}

// ── Unlock sheet ──────────────────────────────────────────────────────────────
class _UnlockSheet extends ConsumerWidget {
  final Novel novel;
  final int chapterIndex;
  final VoidCallback onUnlock;

  const _UnlockSheet({
    required this.novel,
    required this.chapterIndex,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final canAfford = user.coins >= AppConstants.chapterCoinCost;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('🔒', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              'UNLOCK CHAPTER ${chapterIndex + 1}',
              style: AppTextStyles.displaySmall(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You need ${AppConstants.chapterCoinCost} coins to unlock this chapter.',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  'Your balance: ${user.coins} coins',
                  style: AppTextStyles.titleSmall(
                    color: canAfford
                        ? AppColors.gold
                        : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (canAfford)
              GradientButton(
                label: '🪙  UNLOCK FOR ${AppConstants.chapterCoinCost} COINS',
                onTap: () {
                  final success = ref
                      .read(userProvider.notifier)
                      .unlockChapter(
                        novel.id,
                        chapterIndex,
                        AppConstants.chapterCoinCost,
                      );
                  if (success) onUnlock();
                },
              )
            else
              Column(
                children: [
                  GradientButton(
                    label: 'GET MORE COINS  →',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/wallet');
                    },
                    gradient: AppColors.goldGradient,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/subscription');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppColors.accent),
                      foregroundColor: AppColors.accentLight,
                    ),
                    child: Text(
                      '✦  GET VIP — UNLOCK ALL',
                      style: AppTextStyles.labelLarge(color: AppColors.accentLight),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────
class _InfoStat extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  final Color color;

  const _InfoStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleSmall(color: color),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall(color: AppColors.textHint),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.sectionTitle(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _GenrePill extends StatelessWidget {
  final String genre;

  const _GenrePill({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.neonPinkGlow(blur: 10),
      ),
      child: Text(
        genre.toUpperCase(),
        style: AppTextStyles.labelSmall(color: Colors.white),
      ),
    );
  }
}

class _BookmarkButton extends ConsumerWidget {
  final String novelId;

  const _BookmarkButton({required this.novelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isBookmarkedProvider(novelId));

    return GestureDetector(
      onTap: () =>
          ref.read(userProvider.notifier).toggleBookmark(novelId),
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_outline_rounded,
          color: isBookmarked ? AppColors.primary : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _ListenButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ListenButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.headphones_rounded,
                color: AppColors.accentLight, size: 18),
            const SizedBox(width: 6),
            Text(
              'LISTEN',
              style: AppTextStyles.labelLarge(color: AppColors.accentLight),
            ),
          ],
        ),
      ),
    );
  }
}
