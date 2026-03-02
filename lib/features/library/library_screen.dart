import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/user_model.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/providers/novels_provider.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final allNovels = ref.watch(novelsProvider);
    final bookmarked =
        allNovels.where((n) => user.bookmarkedNovels.contains(n.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Text(
                    'MY LIBRARY',
                    style: AppTextStyles.displaySmall(
                        color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            // ── Tab bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.neonPinkGlow(blur: 10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textHint,
                  dividerColor: Colors.transparent,
                  labelStyle: AppTextStyles.labelLarge(),
                  unselectedLabelStyle: AppTextStyles.labelLarge(),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 15),
                          const SizedBox(width: 6),
                          const Text('READING'),
                          if (user.readingHistory.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _TabBadge(count: user.readingHistory.length),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bookmark_rounded, size: 15),
                          const SizedBox(width: 6),
                          const Text('SAVED'),
                          if (bookmarked.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _TabBadge(count: bookmarked.length),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Content ──────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReadingList(user.readingHistory),
                  _buildBookmarkGrid(bookmarked),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingList(List<ReadingProgress> history) {
    if (history.isEmpty) {
      return _EmptyState(
        emoji: '📖',
        title: 'NOTHING YET',
        subtitle: 'Start reading a story to track progress here',
        onTap: () => context.go('/home'),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: history.length,
      itemBuilder: (context, i) =>
          _ReadingCard(progress: history[i], index: i),
    );
  }

  Widget _buildBookmarkGrid(List novels) {
    if (novels.isEmpty) {
      return _EmptyState(
        emoji: '🔖',
        title: 'NO SAVES',
        subtitle: 'Tap the bookmark icon on any story to save it',
        onTap: () => context.go('/discover'),
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 10,
        childAspectRatio: 0.54,
      ),
      itemCount: novels.length,
      itemBuilder: (context, i) {
        final novel = novels[i];
        return GestureDetector(
          onTap: () => context.push('/novel/${novel.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: novel.coverUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context, url, error) => Container(
                      decoration: const BoxDecoration(
                          gradient: AppColors.dramaticGradient),
                      child: Center(
                        child: Text(
                          novel.title[0],
                          style: AppTextStyles.displaySmall(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                novel.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(color: AppColors.textPrimary),
              ),
            ],
          ).animate().fadeIn(
                duration: 250.ms,
                delay: (i * 40).ms,
              ),
        );
      },
    );
  }
}

// ── Reading progress card ─────────────────────────────────────────────────────
class _ReadingCard extends ConsumerWidget {
  final ReadingProgress progress;
  final int index;

  const _ReadingCard({required this.progress, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pct = progress.progressPercent.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => context.push('/novel/${progress.novelId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cover
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: progress.coverUrl,
                width: 80,
                height: 115,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 115,
                  decoration: const BoxDecoration(
                      gradient: AppColors.dramaticGradient),
                  child: Center(
                    child: Text(
                      progress.novelTitle.isNotEmpty
                          ? progress.novelTitle[0]
                          : '?',
                      style: AppTextStyles.displaySmall(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.novelTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall(
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chapter ${progress.currentChapter} of ${progress.totalChapters}',
                      style: AppTextStyles.bodySmall(
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),

                    // Progress bar
                    Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: pct,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: AppColors.neonPinkGlow(blur: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(pct * 100).round()}% read',
                          style: AppTextStyles.bodySmall(
                              color: AppColors.primary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:
                                AppColors.neonPinkGlow(blur: 6),
                          ),
                          child: Text(
                            'CONTINUE',
                            style: AppTextStyles.labelSmall(
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 250.ms, delay: (index * 60).ms),
    );
  }
}

// ── Tab badge ─────────────────────────────────────────────────────────────────
class _TabBadge extends StatelessWidget {
  final int count;
  const _TabBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.labelSmall(color: Colors.white),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EmptyState({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 52))
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(title,
              style:
                  AppTextStyles.displaySmall(color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: AppColors.neonPinkGlow(blur: 14),
              ),
              child: Text(
                'BROWSE STORIES',
                style: AppTextStyles.labelLarge(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
