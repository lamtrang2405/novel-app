import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/providers/audio_provider.dart';
import '../../shared/widgets/mini_player.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFromLocation(location);
    final audioState = ref.watch(audioPlayerProvider);
    final showMini = audioState.currentNovel != null;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      extendBody: true,
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showMini) const MiniPlayer(),
          _GlassNavBar(
            currentIndex: currentIndex,
            onTap: (i) => _onNavTap(context, i),
          ),
        ],
      ),
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/library')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    const routes = ['/home', '/discover', '/library', '/profile'];
    context.go(routes[index]);
  }
}

// ── Glass-style bottom nav ────────────────────────────────────────────────────
class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _GlassNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.explore_rounded, label: 'Discover'),
    _NavItem(icon: Icons.collections_bookmark_rounded, label: 'Library'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom, top: 4),
          child: Row(
            children: _items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isActive = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: _NavItemWidget(
                    item: item,
                    isActive: isActive,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isActive;

  const _NavItemWidget({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 32,
            decoration: isActive
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.accent.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Icon(
              item.icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: AppTextStyles.labelSmall(
              color: isActive ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
