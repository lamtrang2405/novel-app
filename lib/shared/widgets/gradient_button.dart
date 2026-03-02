import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final double height;
  final LinearGradient? gradient;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52,
    this.gradient,
    this.borderRadius = 14,
    this.boxShadow,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.gradient ?? AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.boxShadow ??
                AppColors.neonPinkGlow(blur: 18, spread: 1),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTextStyles.labelLarge(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;

  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: label,
      onTap: onTap,
      height: height,
      gradient: AppColors.goldGradient,
      boxShadow: [
        BoxShadow(
          color: AppColors.gold.withValues(alpha: 0.4),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
