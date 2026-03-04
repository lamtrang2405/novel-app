import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/hush_colors.dart';
import '../providers/hush_player_provider.dart';
import '../widgets/hush_mini_player.dart';

class HushShell extends ConsumerWidget {
  final Widget child;

  const HushShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final index = _indexFromPath(path);
    final playback = ref.watch(hushPlayerProvider);
    final showMini = playback.story != null;

    return Scaffold(
      backgroundColor: HushColors.bg,
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showMini) const HushMiniPlayer(),
          _HushNavBar(
            currentIndex: index,
            onTap: (i) => _onNavTap(context, i),
          ),
        ],
      ),
    );
  }

  int _indexFromPath(String path) {
    if (path.startsWith('/discover')) return 1;
    if (path.startsWith('/library')) return 2;
    if (path.startsWith('/profile')) return 3;
    return 0;
  }

  void _onNavTap(BuildContext context, int i) {
    const routes = ['/home', '/discover', '/library', '/profile'];
    context.go(routes[i]);
  }
}

class _HushNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _HushNavBar({required this.currentIndex, required this.onTap});

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.explore_rounded, label: 'Explore'),
    (icon: Icons.auto_stories_rounded, label: 'Library'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: 56 + bottom,
      decoration: BoxDecoration(
        color: HushColors.bgUp.withValues(alpha: 0.94),
        border: Border(top: BorderSide(color: HushColors.brd)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom, top: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) {
            final t = _tabs[i];
            final active = currentIndex == i;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      t.icon,
                      size: 22,
                      color: active ? HushColors.blush : HushColors.t3,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: active ? HushColors.blush : HushColors.t3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
