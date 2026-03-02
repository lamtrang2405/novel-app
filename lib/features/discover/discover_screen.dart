import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/novel_model.dart';
import '../../shared/providers/novels_provider.dart';
import '../../shared/widgets/novel_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final selectedGenre = ref.watch(selectedGenreProvider);
    final filtered = ref.watch(filteredNovelsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, query),
            // Genre filter
            _buildGenreFilter(selectedGenre),
            const SizedBox(height: 8),
            // Content
            Expanded(
              child: _isSearching && query.isNotEmpty
                  ? _buildSearchResults(searchResults)
                  : _buildGenreGrid(filtered),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String query) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isSearching
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: _isSearching
                        ? AppColors.primary
                        : AppColors.textHint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTextStyles.bodyMedium(
                          color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search dramas, authors...',
                        hintStyle: AppTextStyles.bodyMedium(
                            color: AppColors.textHint),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (v) {
                        setState(() => _isSearching = v.isNotEmpty);
                        ref.read(searchQueryProvider.notifier).state = v;
                      },
                    ),
                  ),
                  if (_isSearching)
                    GestureDetector(
                      onTap: () {
                        setState(() => _isSearching = false);
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textHint,
                        size: 16,
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

  Widget _buildGenreFilter(NovelGenre? selected) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _GenreChip(
            label: 'ALL',
            isSelected: selected == null,
            onTap: () =>
                ref.read(selectedGenreProvider.notifier).state = null,
          ),
          const SizedBox(width: 8),
          ...NovelGenre.values.map((genre) {
            final isSelected = selected == genre;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _GenreChip(
                label: genre.label.toUpperCase(),
                isSelected: isSelected,
                onTap: () =>
                    ref.read(selectedGenreProvider.notifier).state =
                        isSelected ? null : genre,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Novel> results) {
    if (results.isEmpty) {
      return _EmptyState(
        emoji: '🔍',
        title: 'NO RESULTS',
        subtitle: 'Try a different keyword',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      physics: const BouncingScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: NovelCardWide(novel: results[i]),
      )
          .animate(delay: (i * 40).ms)
          .fadeIn(duration: 250.ms),
    );
  }

  Widget _buildGenreGrid(List<Novel> novels) {
    if (novels.isEmpty) {
      return _EmptyState(
        emoji: '📚',
        title: 'NOTHING YET',
        subtitle: 'Check back soon for new stories',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 10,
        childAspectRatio: 0.55,
      ),
      itemCount: novels.length,
      itemBuilder: (context, i) =>
          NovelCard(novel: novels[i])
              .animate(delay: (i * 30).ms)
              .fadeIn(duration: 250.ms),
    );
  }
}

// ── Genre chip ────────────────────────────────────────────────────────────────
class _GenreChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
          boxShadow: isSelected ? AppColors.neonPinkGlow(blur: 10) : [],
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.emoji,
    required this.title,
    required this.subtitle,
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
          Text(
            title,
            style: AppTextStyles.displaySmall(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
