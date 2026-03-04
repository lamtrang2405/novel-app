import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/novel_model.dart';
import '../../shared/models/reading_settings_model.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/novels_provider.dart';
import '../../shared/providers/reading_settings_provider.dart';
import '../../shared/providers/user_provider.dart';
class ChapterReaderScreen extends ConsumerStatefulWidget {
  final String novelId;
  final int chapterIndex;

  const ChapterReaderScreen({
    super.key,
    required this.novelId,
    required this.chapterIndex,
  });

  @override
  ConsumerState<ChapterReaderScreen> createState() =>
      _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends ConsumerState<ChapterReaderScreen>
    with SingleTickerProviderStateMixin {
  bool _showUI = true;
  late AnimationController _uiAnimController;
  late Animation<double> _uiAnim;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _uiAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );
    _uiAnim = CurvedAnimation(
      parent: _uiAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _uiAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() => _showUI = !_showUI);
    if (_showUI) {
      _uiAnimController.forward();
    } else {
      _uiAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final novel = ref.watch(novelByIdProvider(widget.novelId));
    final isNovelMissing = novel == null;
    final isChapterInvalid = novel != null && (novel.chapters.isEmpty ||
        widget.chapterIndex < 0 ||
        widget.chapterIndex >= novel.chapters.length);
    if (isNovelMissing || isChapterInvalid) {
      return Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isNovelMissing ? Icons.menu_book_outlined : Icons.error_outline,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isNovelMissing ? 'Novel not found' : 'Chapter not found',
                    style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      if (novel != null) {
                        context.go('/novel/${widget.novelId}');
                      } else {
                        context.go('/home');
                      }
                    },
                    child: Text(
                      'Go back',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final chapter = novel.chapters[widget.chapterIndex];
    final user = ref.watch(userProvider);
    final isFree = widget.chapterIndex < AppConstants.freeChaptersPerNovel;
    final canRead = isFree || user.hasActiveSubscription;

    // Paywall — show locked screen if chapter not accessible
    if (!canRead) {
      return _LockedChapterScreen(
        novel: novel,
        chapterIndex: widget.chapterIndex,
      );
    }

    final settings = ref.watch(readingSettingsProvider);
    final bg = _bgColor(settings);
    final textColor = _textColor(settings);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Reading content — tap to toggle UI
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleUI,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    MediaQuery.of(context).padding.top + 80,
                    24,
                    MediaQuery.of(context).padding.bottom + 100,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter number tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'CHAPTER ${widget.chapterIndex + 1}',
                            style: AppTextStyles.labelSmall(
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Chapter title
                        Text(
                          chapter.title,
                          style: AppTextStyles.readerChapterTitle(
                            fontSize: settings.fontSize,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Decorative divider ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _NeonDividerLine(color: AppColors.primary),
                            const SizedBox(width: 10),
                            ShaderMask(
                              shaderCallback: (r) =>
                                  AppColors.primaryGradient.createShader(r),
                              child: const Text(
                                '✦',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _NeonDividerLine(color: AppColors.accent),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Content
                        Text(
                          chapter.content,
                          style: AppTextStyles.readerBody(
                            fontSize: settings.fontSize,
                            color: textColor,
                            height: settings.lineHeight,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // End ornament
                        Center(
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (r) =>
                                    AppColors.primaryGradient.createShader(r),
                                child: const Text(
                                  '✦  ✦  ✦',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'End of Chapter ${widget.chapterIndex + 1}',
                                style: AppTextStyles.bodySmall(
                                    color: textColor.withValues(alpha: 0.4)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Next chapter button
                        if (widget.chapterIndex <
                            novel.chapters.length - 1)
                          _NextChapterBtn(
                            novel: novel,
                            nextIndex: widget.chapterIndex + 1,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Top bar ──────────────────────────────────────────────
          FadeTransition(
            opacity: _uiAnim,
            child: _TopBar(
              novel: novel,
              chapterIndex: widget.chapterIndex,
              onSettingsTap: () => _showReadingSettings(context, settings),
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _uiAnim,
              child: _BottomBar(
                novel: novel,
                chapterIndex: widget.chapterIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _bgColor(ReadingSettings s) {
    switch (s.mode) {
      case ReadingMode.dark:
        return AppColors.bgDark;
      case ReadingMode.sepia:
        return AppColors.bgSepia;
      case ReadingMode.light:
        return AppColors.bgLight;
    }
  }

  Color _textColor(ReadingSettings s) {
    switch (s.mode) {
      case ReadingMode.dark:
        return AppColors.textPrimary;
      case ReadingMode.sepia:
        return AppColors.textPrimarySepia;
      case ReadingMode.light:
        return AppColors.textPrimaryLight;
    }
  }

  void _showReadingSettings(BuildContext context, ReadingSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCardAlt,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SettingsSheet(),
    );
  }
}

// ── Top bar ────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final Novel novel;
  final int chapterIndex;
  final VoidCallback onSettingsTap;

  const _TopBar({
    required this.novel,
    required this.chapterIndex,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bgDark,
            AppColors.bgDark.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  novel.title,
                  style: AppTextStyles.titleSmall(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Chapter ${chapterIndex + 1} of ${novel.chapters.length}',
                  style: AppTextStyles.bodySmall(color: AppColors.textHint),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSettingsTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final Novel novel;
  final int chapterIndex;

  const _BottomBar({required this.novel, required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    final progress = (chapterIndex + 1) / novel.chapters.length;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.bgDark,
            AppColors.bgDark.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          Row(
            children: [
              Text(
                'Ch ${chapterIndex + 1}',
                style: AppTextStyles.bodySmall(color: AppColors.textHint),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 3,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: FractionallySizedBox(
                              widthFactor: progress.clamp(0.0, 1.0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: AppColors.neonPinkGlow(blur: 4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Ch ${novel.chapters.length}',
                style: AppTextStyles.bodySmall(color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Nav buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (chapterIndex > 0)
                _NavBtn(
                  label: '← PREV',
                  onTap: () => context.go(
                      '/novel/${novel.id}/chapter/${chapterIndex - 1}'),
                )
              else
                const SizedBox(width: 80),
              Text(
                '${(progress * 100).toInt()}% done',
                style: AppTextStyles.bodySmall(color: AppColors.textHint),
              ),
              if (chapterIndex < novel.chapters.length - 1)
                _NavBtn(
                  label: 'NEXT →',
                  onTap: () => context.go(
                      '/novel/${novel.id}/chapter/${chapterIndex + 1}'),
                )
              else
                const SizedBox(width: 80),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.neonPinkGlow(blur: 8),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall(color: Colors.white),
        ),
      ),
    );
  }
}

// ── Neon decorative divider ───────────────────────────────────────────────────
class _NeonDividerLine extends StatelessWidget {
  final Color color;

  const _NeonDividerLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, color, Colors.transparent],
        ),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6),
        ],
      ),
    );
  }
}

// ── Next chapter button ───────────────────────────────────────────────────────
class _NextChapterBtn extends StatelessWidget {
  final Novel novel;
  final int nextIndex;

  const _NextChapterBtn({required this.novel, required this.nextIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/novel/${novel.id}/chapter/$nextIndex'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.neonPinkGlow(blur: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NEXT: ${novel.chapters[nextIndex].title.toUpperCase()}',
              style: AppTextStyles.labelLarge(color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 16),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.1, end: 0),
    );
  }
}

// ── Settings sheet ────────────────────────────────────────────────────────────
class _SettingsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readingSettingsProvider);
    final notifier = ref.read(readingSettingsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'READING SETTINGS',
            style: AppTextStyles.sectionTitle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),

          // Font size
          Row(
            children: [
              Text(
                'SIZE',
                style: AppTextStyles.labelSmall(color: AppColors.textHint),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor:
                        Colors.white.withValues(alpha: 0.1),
                    thumbColor: AppColors.primary,
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7),
                    overlayColor:
                        AppColors.primary.withValues(alpha: 0.15),
                  ),
                  child: Slider(
                    min: 14,
                    max: 24,
                    value: settings.fontSize,
                    divisions: 10,
                    onChanged: notifier.setFontSize,
                  ),
                ),
              ),
              Text(
                '${settings.fontSize.round()}',
                style:
                    AppTextStyles.labelSmall(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Line spacing
          Row(
            children: [
              Text(
                'SPACING',
                style: AppTextStyles.labelSmall(color: AppColors.textHint),
              ),
              const SizedBox(width: 12),
              ...[1.5, 1.8, 2.1].map((h) {
                final isActive = (h - settings.lineHeight).abs() < 0.05;
                return GestureDetector(
                  onTap: () => notifier.setLineHeight(h),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient:
                          isActive ? AppColors.primaryGradient : null,
                      color: isActive ? null : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      h == 1.5
                          ? 'TIGHT'
                          : h == 1.8
                              ? 'NORMAL'
                              : 'WIDE',
                      style: AppTextStyles.labelSmall(
                        color: isActive
                            ? Colors.white
                            : AppColors.textHint,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Theme
          Text(
            'THEME',
            style: AppTextStyles.labelSmall(color: AppColors.textHint),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ThemeBtn(
                label: '🌙 DARK',
                mode: ReadingMode.dark,
                currentMode: settings.mode,
                onTap: () => notifier.setMode(ReadingMode.dark),
              ),
              const SizedBox(width: 8),
              _ThemeBtn(
                label: '📜 SEPIA',
                mode: ReadingMode.sepia,
                currentMode: settings.mode,
                onTap: () => notifier.setMode(ReadingMode.sepia),
              ),
              const SizedBox(width: 8),
              _ThemeBtn(
                label: '☀️ LIGHT',
                mode: ReadingMode.light,
                currentMode: settings.mode,
                onTap: () => notifier.setMode(ReadingMode.light),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeBtn extends StatelessWidget {
  final String label;
  final ReadingMode mode;
  final ReadingMode currentMode;
  final VoidCallback onTap;

  const _ThemeBtn({
    required this.label,
    required this.mode,
    required this.currentMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = mode == currentMode;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.primaryGradient : null,
          color: isActive ? null : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              isActive ? AppColors.neonPinkGlow(blur: 10) : [],
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall(
            color: isActive ? Colors.white : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}

// ── Locked chapter paywall screen ─────────────────────────────────────────────
class _LockedChapterScreen extends ConsumerWidget {
  final Novel novel;
  final int chapterIndex;

  const _LockedChapterScreen({
    required this.novel,
    required this.chapterIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Blurred book cover background
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                novel.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, url, err) => const SizedBox.shrink(),
              ),
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(color: AppColors.bgDark.withValues(alpha: 0.85)),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Lock icon with glow
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgCard,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: AppColors.neonPinkGlow(blur: 20),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'CHAPTER ${chapterIndex + 1} LOCKED',
                  style: AppTextStyles.displaySmall(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Subscribe to VIP to unlock all chapters of ${novel.title}.',
                    style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _UnlockBtn(
                    label: '✦  GET VIP — UNLOCK ALL CHAPTERS',
                    onTap: () => context.push('/subscription'),
                    gradient: AppColors.primaryGradient,
                    glow: AppColors.neonPinkGlow(blur: 16),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnlockBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final LinearGradient gradient;
  final List<BoxShadow> glow;

  const _UnlockBtn({
    required this.label,
    required this.onTap,
    required this.gradient,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: glow,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelLarge(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
