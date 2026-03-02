import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/novel_model.dart';
import '../../shared/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;
  final Set<NovelGenre> _selected = {};

  static const _pages = [
    _PageData(
      title: 'DRAMA\nTHAT HITS\nDIFFERENT',
      subtitle: 'Thousands of addictive stories updated daily. Romance, betrayal, obsession — all in one app.',
      emoji: '🔥',
      tag: 'YOUR NEXT OBSESSION',
      primaryColor: AppColors.primary,
      accentColor: AppColors.accent,
    ),
    _PageData(
      title: 'LISTEN\nLIKE YOU\'RE\nINSIDE IT',
      subtitle: 'Every chapter narrated with professional audio. Feel the drama, don\'t just read it.',
      emoji: '🎧',
      tag: 'IMMERSIVE AUDIO',
      primaryColor: AppColors.accent,
      accentColor: AppColors.cyan,
    ),
    _PageData(
      title: 'UNLOCK\nYOUR\nSTORY',
      subtitle: 'Track every chapter, bookmark your faves, and pick up right where you left off.',
      emoji: '✨',
      tag: 'MADE FOR YOU',
      primaryColor: AppColors.cyan,
      accentColor: AppColors.primary,
    ),
  ];

  bool get _isGenrePage => _page == _pages.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background glow
          _BackgroundGlow(page: _page, total: _pages.length),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button top right
                if (!_isGenrePage)
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _finish,
                      child: Text(
                        'SKIP',
                        style: AppTextStyles.labelSmall(color: AppColors.textHint),
                      ),
                    ),
                  ),
                if (_isGenrePage) const SizedBox(height: 48),

                // Page content
                Expanded(
                  child: _isGenrePage
                      ? _GenrePicker(
                          selected: _selected,
                          onToggle: (g) => setState(() {
                            _selected.contains(g)
                                ? _selected.remove(g)
                                : _selected.add(g);
                          }),
                        )
                      : _OnboardPage(data: _pages[_page], key: ValueKey(_page)),
                ),

                // Bottom controls
                _BottomControls(
                  page: _page,
                  total: _pages.length,
                  isLast: _isGenrePage,
                  onNext: _next,
                  onFinish: _finish,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _next() => setState(() => _page++);
  void _finish() => context.go('/home');
}

// ── Background glow that changes per page ─────────────────────────────────────
class _BackgroundGlow extends StatelessWidget {
  final int page;
  final int total;

  const _BackgroundGlow({required this.page, required this.total});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.cyan,
      AppColors.primary,
    ];
    final color = colors[page.clamp(0, colors.length - 1)];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(color: AppColors.bgDeep),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single onboard page ───────────────────────────────────────────────────────
class _OnboardPage extends StatelessWidget {
  final _PageData data;

  const _OnboardPage({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji + tag row
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(data.emoji, style: const TextStyle(fontSize: 36))
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.elasticOut),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: data.primaryColor.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  data.tag,
                  style: AppTextStyles.labelSmall(color: data.primaryColor),
                ),
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 300.ms),
            ],
          ),
          const SizedBox(height: 24),

          // Big bold title
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [data.primaryColor, data.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              data.title,
              style: AppTextStyles.displayLarge(color: Colors.white),
              softWrap: true,
            ),
          )
              .animate(delay: 150.ms)
              .fadeIn(duration: 500.ms)
              .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 20),

          // Subtitle
          Text(
            data.subtitle,
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          )
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: 32),

          // Decorative neon line
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [data.primaryColor, data.accentColor],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: data.primaryColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 300.ms)
              .slideX(begin: -0.2, end: 0),
        ],
      ),
    );
  }
}

// ── Genre picker ─────────────────────────────────────────────────────────────
class _GenrePicker extends StatelessWidget {
  final Set<NovelGenre> selected;
  final void Function(NovelGenre) onToggle;

  const _GenrePicker({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT\'S YOUR\nDRAMA TYPE?',
            style: AppTextStyles.displayMedium(color: Colors.white),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 6),
          Text(
            'Pick all that speak to your soul',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
          )
              .animate(delay: 100.ms)
              .fadeIn(),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: NovelGenre.values.asMap().entries.map((e) {
                  final genre = e.value;
                  final isSelected = selected.contains(genre);
                  return GestureDetector(
                    onTap: () => onToggle(genre),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? AppColors.primaryGradient
                            : null,
                        color: isSelected ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? AppColors.neonPinkGlow(blur: 12)
                            : [],
                      ),
                      child: Text(
                        genre.label,
                        style: AppTextStyles.labelLarge(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ).animate(delay: (e.key * 50).ms).fadeIn(duration: 300.ms);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom controls ───────────────────────────────────────────────────────────
class _BottomControls extends StatelessWidget {
  final int page;
  final int total;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const _BottomControls({
    required this.page,
    required this.total,
    required this.isLast,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        children: [
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total + 1, (i) {
              final isActive = i == page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 24 : 6,
                height: 6,
                decoration: BoxDecoration(
                  gradient: isActive ? AppColors.primaryGradient : null,
                  color: isActive ? null : Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: isActive ? AppColors.neonPinkGlow(blur: 8) : [],
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // CTA button
          isLast
              ? GradientButton(
                  label: '✦  START YOUR STORY',
                  onTap: onFinish,
                  height: 56,
                )
              : Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: page < total - 1 ? 'NEXT  →' : 'ALMOST THERE  →',
                        onTap: onNext,
                        height: 54,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────
class _PageData {
  final String title;
  final String subtitle;
  final String emoji;
  final String tag;
  final Color primaryColor;
  final Color accentColor;

  const _PageData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.tag,
    required this.primaryColor,
    required this.accentColor,
  });
}
