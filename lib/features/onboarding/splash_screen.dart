import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Glow orbs background ─────────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(
              size: 280,
              color: AppColors.accent,
              opacity: 0.18,
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _GlowOrb(
              size: 300,
              color: AppColors.primary,
              opacity: 0.2,
            ),
          ),
          Positioned(
            top: size.height * 0.4,
            left: size.width * 0.3,
            child: _GlowOrb(
              size: 180,
              color: AppColors.cyan,
              opacity: 0.12,
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo mark
                _LogoMark(pulseController: _pulseController),
                const SizedBox(height: 28),

                // App name — dramatic display
                Text(
                  AppConstants.appName.toUpperCase(),
                  style: AppTextStyles.displayLarge(color: Colors.white),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                const SizedBox(height: 8),

                // Tagline with neon accent
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 1.5,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          AppConstants.appTagline.toUpperCase(),
                          style: AppTextStyles.labelSmall(
                              color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 1.5,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 72),

                // Loading dots
                _LoadingDots()
                    .animate(delay: 1000.ms)
                    .fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Logo mark ─────────────────────────────────────────────────────────────────
class _LogoMark extends StatelessWidget {
  final AnimationController pulseController;

  const _LogoMark({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glow = 20.0 + pulseController.value * 30;
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.5),
                blurRadius: glow,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: glow * 1.5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(
            Icons.play_circle_rounded,
            size: 52,
            color: Colors.white,
          ),
        );
      },
    )
        .animate()
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.0, 1.0),
          duration: 700.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 400.ms);
  }
}

// ── Glow orb background element ───────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowOrb(
      {required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

// ── Animated loading dots ─────────────────────────────────────────────────────
class _LoadingDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
        )
            .animate(delay: (i * 150).ms, onPlay: (c) => c.repeat())
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.2, 1.2),
              duration: 600.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.2, 1.2),
              end: const Offset(0.5, 0.5),
              duration: 600.ms,
              curve: Curves.easeInOut,
            );
      }),
    );
  }
}
