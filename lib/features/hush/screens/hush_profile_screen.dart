import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/hush_colors.dart';

class HushProfileScreen extends ConsumerWidget {
  const HushProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: HushColors.bg,
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: HushColors.t1,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: HushColors.grad,
                  boxShadow: [
                    BoxShadow(
                      color: HushColors.blush.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: HushColors.bgUp,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'S',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: HushColors.blush,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sofia Laurent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: HushColors.t1,
                ),
              ),
              Text(
                'DramaVerse • Your Drama. Your Story.',
                style: TextStyle(fontSize: 13, color: HushColors.t2),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(value: '29', label: 'Stories', accent: false),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(value: '74h', label: 'Listened', accent: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(value: '11', label: 'Favorites', accent: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: HushColors.grad,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: HushColors.blush.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'VIP',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Go Premium',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'All voices, exclusive stories, ad-free',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Material(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          onTap: () => context.push('/subscription'),
                          borderRadius: BorderRadius.circular(25),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Text('Upgrade', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionBlock(
                title: 'Preferences',
                items: [
                  _SettingRow(icon: Icons.record_voice_over_outlined, name: 'Voice Preference', value: 'Deep masculine'),
                  _SettingRow(icon: Icons.dark_mode_outlined, name: 'Dark Mode', value: 'Always on', isToggle: true),
                  _SettingRow(icon: Icons.lock_outline, name: 'Privacy Lock', value: 'Require Face ID'),
                ],
              ),
              _SectionBlock(
                title: 'Account',
                items: [
                  _SettingRow(icon: Icons.email_outlined, name: 'Email', value: 'sofia.l@email.com'),
                  _SettingRow(icon: Icons.card_membership_outlined, name: 'Subscription', value: 'Free plan'),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'DramaVerse v1.0 • novel_app',
                  style: TextStyle(fontSize: 12, color: HushColors.t3),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool accent;

  const _StatCard({required this.value, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent ? HushColors.blushDim : HushColors.bgCard,
        border: Border.all(
          color: accent ? HushColors.blush.withValues(alpha: 0.2) : HushColors.brd,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: accent ? HushColors.blush : HushColors.t1,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: HushColors.t2),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SectionBlock({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: HushColors.t3,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: HushColors.bgCard,
              border: Border.all(color: HushColors.brd),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: items),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final String value;
  final bool isToggle;

  const _SettingRow({
    required this.icon,
    required this.name,
    required this.value,
    this.isToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: HushColors.bgCard,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: HushColors.t2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HushColors.t1,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 12, color: HushColors.t3),
                ),
              ],
            ),
          ),
          if (isToggle)
            Container(
              width: 42,
              height: 22,
              decoration: BoxDecoration(
                color: HushColors.blush,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 2),
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
                ),
              ),
            )
          else
            Icon(Icons.chevron_right, size: 20, color: HushColors.t3),
        ],
      ),
    );
  }
}
