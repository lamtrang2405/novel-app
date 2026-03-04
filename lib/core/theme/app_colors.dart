import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Core palette (Gen Z dark drama aesthetic) ─────────────────────────────
  static const Color primary = Color(0xFFFF2D78);       // hot neon pink
  static const Color primaryLight = Color(0xFFFF6FA8);
  static const Color primaryDark = Color(0xFFCC0055);

  static const Color accent = Color(0xFFBB3CFF);         // electric purple
  static const Color accentLight = Color(0xFFD580FF);
  static const Color accentDark = Color(0xFF8800CC);

  static const Color cyan = Color(0xFF00E5FF);           // neon cyan
  static const Color cyanDark = Color(0xFF00B0CC);

  static const Color gold = Color(0xFFFFD600);           // bright gold
  static const Color goldLight = Color(0xFFFFEA00);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color bgDeep    = Color(0xFF0A0A0F);      // near black
  static const Color bgDark    = Color(0xFF0F0F1A);      // main dark bg
  static const Color bgCard    = Color(0xFF161625);      // card surface
  static const Color bgCardAlt = Color(0xFF1E1E30);      // elevated card
  static const Color bgGlass   = Color(0x1AFFFFFF);      // glass overlay 10%

  // Light mode (reader fallback)
  static const Color bgLight   = Color(0xFFF5F0FF);      // soft lavender
  static const Color bgSurface = Color(0xFFEDE9FF);

  // Sepia mode
  static const Color bgSepia     = Color(0xFF1A1410);
  static const Color bgCardSepia = Color(0xFF221C14);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF0EEFF);
  static const Color textSecondary = Color(0xFFAA9FC4);
  static const Color textHint      = Color(0xFF6B618A);

  // Light/sepia reader text
  static const Color textPrimaryLight  = Color(0xFF12101F);
  static const Color textSecondaryLight= Color(0xFF3D3560);
  static const Color textPrimarySepia  = Color(0xFFEAE0CC);
  static const Color textSecondarySepia= Color(0xFFAA9880);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error   = Color(0xFFFF1744);

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF2D78), Color(0xFFBB3CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0066FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD600), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── VIP / Subscription (black & gold theme) ───────────────────────────────
  static const Color vipBlack = Color(0xFF0D0D0D);
  static const Color vipGold = Color(0xFFD4AF37);
  static const Color vipGoldLight = Color(0xFFF4E4BC);
  static const LinearGradient vipGoldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static List<BoxShadow> vipGoldGlow({double blur = 20}) => [
    BoxShadow(
      color: vipGold.withValues(alpha: 0.45),
      blurRadius: blur,
    ),
  ];

  static const LinearGradient vipHeroGradient = LinearGradient(
    colors: [Color(0xFF0D0D0D), Color(0xFF1A1810), Color(0xFF252015)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color vipSurface = Color(0xFF1C1C1A);
  static const Color vipText = Color(0xFFF4E4BC);
  static const Color vipTextMuted = Color(0xFFB8A870);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF1A0A2E), Color(0xFF2D0F3D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient dramaticGradient = LinearGradient(
    colors: [Color(0xFF1A0A2E), Color(0xFF3D0066), Color(0xFF660033)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coverOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xF5000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.35, 1.0],
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0x33FF2D78), Color(0x33BB3CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Neon glow shadows ─────────────────────────────────────────────────────
  static List<BoxShadow> neonPinkGlow({double blur = 20, double spread = 0}) => [
    BoxShadow(
      color: primary.withValues(alpha: 0.5),
      blurRadius: blur,
      spreadRadius: spread,
    ),
  ];

  static List<BoxShadow> neonPurpleGlow({double blur = 20}) => [
    BoxShadow(
      color: accent.withValues(alpha: 0.45),
      blurRadius: blur,
    ),
  ];

  static List<BoxShadow> neonCyanGlow({double blur = 16}) => [
    BoxShadow(
      color: cyan.withValues(alpha: 0.4),
      blurRadius: blur,
    ),
  ];
}
