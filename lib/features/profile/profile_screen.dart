import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context, user.name, user.email, user.hasActiveSubscription),
          SliverToBoxAdapter(
            child: _buildStatsRow(
              user.totalChaptersRead,
              user.totalReadingMinutes,
              user.bookmarkedNovels.length,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildVIPBanner(context, user.hasActiveSubscription),
          ),
          SliverToBoxAdapter(
            child: _buildMenu(context, ref, user.coins),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(
      BuildContext context, String name, String email, bool isVIP) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.bgCard,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.dramaticGradient,
          ),
          child: Stack(
            children: [
              // Background orbs
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow:
                                  AppColors.neonPinkGlow(blur: 16),
                            ),
                            child: Center(
                              child: Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : '?',
                                style: AppTextStyles.displaySmall(
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          if (isVIP)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.bgCard, width: 2),
                              ),
                              child: const Icon(
                                  Icons.workspace_premium,
                                  size: 12,
                                  color: Colors.white),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: AppTextStyles.titleLarge(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email.isEmpty ? 'Guest Reader' : email,
                        style: AppTextStyles.bodySmall(
                            color: Colors.white.withValues(alpha: 0.6)),
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

  // ── Stats row ────────────────────────────────────────────────────────────────
  Widget _buildStatsRow(int chapters, int minutes, int bookmarks) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            icon: Icons.menu_book_rounded,
            value: '$chapters',
            label: 'CHAPTERS',
          ),
          _VertDivider(),
          _StatItem(
            icon: Icons.access_time_rounded,
            value: '${(minutes / 60).round()}h',
            label: 'READ TIME',
          ),
          _VertDivider(),
          _StatItem(
            icon: Icons.bookmark_rounded,
            value: '$bookmarks',
            label: 'SAVED',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // ── VIP banner ───────────────────────────────────────────────────────────────
  Widget _buildVIPBanner(BuildContext context, bool isVIP) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: isVIP ? null : () => context.push('/subscription'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient:
                isVIP ? AppColors.goldGradient : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isVIP
                ? [
                    BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.35),
                        blurRadius: 14)
                  ]
                : AppColors.neonPinkGlow(blur: 14),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVIP ? 'VIP MEMBER ✨' : 'UPGRADE TO VIP',
                      style:
                          AppTextStyles.titleSmall(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isVIP
                          ? 'Unlimited chapters + audio enabled'
                          : 'Unlock all chapters + audio narration',
                      style: AppTextStyles.bodySmall(
                          color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              if (!isVIP)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'GET VIP',
                    style: AppTextStyles.labelSmall(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // ── Menu ─────────────────────────────────────────────────────────────────────
  Widget _buildMenu(BuildContext context, WidgetRef ref, int coins) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('ACCOUNT'),
          _MenuCard(
            children: [
              _MenuItem(
                icon: Icons.monetization_on_rounded,
                iconColor: AppColors.gold,
                label: 'Coin Wallet',
                trailing: _CoinBadge(coins: coins),
                onTap: () => context.push('/wallet'),
              ),
              const _CardDivider(),
              _MenuItem(
                icon: Icons.workspace_premium_rounded,
                iconColor: AppColors.primary,
                label: 'VIP Subscription',
                onTap: () => context.push('/subscription'),
              ),
              const _CardDivider(),
              _MenuItem(
                icon: Icons.collections_bookmark_rounded,
                iconColor: AppColors.accent,
                label: 'My Library',
                onTap: () => context.go('/library'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionLabel('PREFERENCES'),
          _MenuCard(
            children: [
              _MenuItem(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.primary,
                label: 'Notifications',
                onTap: () {},
              ),
              const _CardDivider(),
              _MenuItem(
                icon: Icons.language_outlined,
                iconColor: AppColors.cyan,
                label: 'Language',
                trailing: _TrailingText(text: 'English'),
                onTap: () {},
              ),
              const _CardDivider(),
              _MenuItem(
                icon: Icons.dark_mode_outlined,
                iconColor: AppColors.accent,
                label: 'App Theme',
                trailing: _TrailingText(text: 'Dark'),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionLabel('SUPPORT'),
          _MenuCard(
            children: [
              _MenuItem(
                icon: Icons.help_outline_rounded,
                iconColor: AppColors.primary,
                label: 'Help & Support',
                onTap: () {},
              ),
              const _CardDivider(),
              _MenuItem(
                icon: Icons.star_rate_rounded,
                iconColor: AppColors.gold,
                label: 'Rate the App',
                onTap: () {},
              ),
              const _CardDivider(),
              _MenuItem(
                icon: Icons.privacy_tip_outlined,
                iconColor: AppColors.textSecondary,
                label: 'Privacy Policy',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MenuCard(
            children: [
              _MenuItem(
                icon: Icons.logout_rounded,
                iconColor: AppColors.error,
                label: 'Sign Out',
                labelColor: AppColors.error,
                showChevron: false,
                onTap: () => context.go('/auth'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'DramaVerse v1.0.0',
              style: AppTextStyles.bodySmall(color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleLarge(color: AppColors.textPrimary)),
        Text(label, style: AppTextStyles.labelSmall(color: AppColors.textHint)),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 40,
        color: Colors.white.withValues(alpha: 0.08),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: AppTextStyles.labelSmall(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(children: children),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showChevron;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.trailing,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyLarge(
                    color: labelColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
              ?trailing,
              if (showChevron) ...[
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.textHint),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 66),
      child: Divider(
        height: 1,
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final int coins;
  const _CoinBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '🪙 $coins',
        style: AppTextStyles.labelSmall(color: Colors.white),
      ),
    );
  }
}

class _TrailingText extends StatelessWidget {
  final String text;
  const _TrailingText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodySmall(color: AppColors.textHint),
    );
  }
}
