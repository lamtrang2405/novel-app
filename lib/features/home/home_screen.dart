import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/models/novel_model.dart';
import '../../shared/providers/novels_provider.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/widgets/novel_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _featuredController = PageController(viewportFraction: 0.88);
  int _featuredPage = 0;

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final featured = ref.watch(featuredNovelsProvider);
    final hot = ref.watch(hotNovelsProvider);
    final newNovels = ref.watch(newNovelsProvider);
    final allNovels = ref.watch(novelsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, user.name),
          SliverToBoxAdapter(
            child: _buildFeaturedSection(context, featured),
          ),
          SliverToBoxAdapter(
            child: _buildHorizontalShelf(context, '🔥 ON FIRE', hot),
          ),
          SliverToBoxAdapter(
            child: _buildHorizontalShelf(context, '✨ JUST DROPPED', newNovels),
          ),
          SliverToBoxAdapter(
            child: _buildAllStoriesSection(context, allNovels),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────
  Widget _buildSliverAppBar(BuildContext context, String name) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.bgDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hey ${name.isNotEmpty ? name.split(' ').first : 'Babe'} 👋',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
          ),
          ShaderMask(
            shaderCallback: (r) =>
                AppColors.primaryGradient.createShader(r),
            child: Text(
              AppConstants.appName.toUpperCase(),
              style: AppTextStyles.displaySmall(color: Colors.white),
            ),
          ),
        ],
      ),
      actions: [
        _VipBadge(onTap: () => context.go('/subscription')),
        const SizedBox(width: 12),
      ],
    );
  }

  // ── Featured carousel ─────────────────────────────────────────────────────
  Widget _buildFeaturedSection(BuildContext context, List<Novel> novels) {
    if (novels.isEmpty) return const SizedBox.shrink();

    final h = MediaQuery.of(context).size.width * 0.62;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: _SectionLabel(label: 'FEATURED'),
        ),
        SizedBox(
          height: h.clamp(220.0, 340.0),
          child: PageView.builder(
            controller: _featuredController,
            itemCount: novels.length,
            onPageChanged: (i) => setState(() => _featuredPage = i),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _FeaturedCard(
                  novel: novels[i],
                  isActive: _featuredPage == i,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _featuredPage,
            count: novels.length,
            effect: ExpandingDotsEffect(
              dotWidth: 6,
              dotHeight: 6,
              expansionFactor: 4,
              activeDotColor: AppColors.primary,
              dotColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Horizontal shelf ──────────────────────────────────────────────────────
  Widget _buildHorizontalShelf(
      BuildContext context, String label, List<Novel> novels) {
    if (novels.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              _SectionLabel(label: label),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/discover'),
                child: Text(
                  'SEE ALL',
                  style: AppTextStyles.labelSmall(
                      color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: novels.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 120,
                  child: NovelCard(novel: novels[i]),
                ),
              )
                  .animate(delay: (i * 60).ms)
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: 0.1, end: 0);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── All stories section ────────────────────────────────────────────────────
  Widget _buildAllStoriesSection(BuildContext context, List<Novel> novels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: _SectionLabel(label: 'ALL STORIES'),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: novels.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: NovelCardWide(novel: novels[i]),
            )
                .animate(delay: (i * 40).ms)
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.05, end: 0);
          },
        ),
      ],
    );
  }
}

// ── VIP badge ─────────────────────────────────────────────────────────────────
class _VipBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _VipBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.neonPinkGlow(blur: 10),
        ),
        child: Text(
          '✦ VIP',
          style: AppTextStyles.labelSmall(color: Colors.white),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.sectionTitle(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

// ── Featured card ─────────────────────────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  final Novel novel;
  final bool isActive;

  const _FeaturedCard({required this.novel, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/novel/${novel.id}'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.diagonal3Values(
          isActive ? 1.0 : 0.95,
          isActive ? 1.0 : 0.95,
          1.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cover image
                CachedNetworkImage(
                  imageUrl: novel.coverUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, err) => Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.dramaticGradient,
                    ),
                  ),
                ),
                // Gradient overlay
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.coverOverlay,
                  ),
                ),
                // Top badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: _FeaturedBadge(novel: novel),
                ),
                // Bottom info
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _GenrePill(label: novel.genreLabel),
                      const SizedBox(height: 6),
                      Text(
                        novel.title.toUpperCase(),
                        style: AppTextStyles.titleLarge(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.gold, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            novel.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall(
                                color: AppColors.gold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '· ${novel.viewCountLabel}',
                            style: AppTextStyles.bodySmall(
                                color: Colors.white54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  final Novel novel;

  const _FeaturedBadge({required this.novel});

  @override
  Widget build(BuildContext context) {
    if (novel.isHot) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppColors.neonPinkGlow(blur: 10),
        ),
        child: Text(
          '🔥 HOT',
          style: AppTextStyles.labelSmall(color: Colors.white),
        ),
      );
    }
    if (novel.isNew) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: AppColors.cyanGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '✨ NEW',
          style: AppTextStyles.labelSmall(color: Colors.white),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _GenrePill extends StatelessWidget {
  final String label;

  const _GenrePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelSmall(color: Colors.white),
      ),
    );
  }
}
