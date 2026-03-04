import 'package:flutter/material.dart';

/// Hush — Your Secret Escape. Design system for intimate audio.
class HushColors {
  HushColors._();

  static const Color bg = Color(0xFF070D10);
  static const Color bgUp = Color(0xFF0C1418);
  static const Color bgCard = Color(0x08FFFFFF);
  static const Color bgHover = Color(0x0FFFFFFF);
  static const Color bgGlass = Color(0x0AFFFFFF);

  static const Color blush = Color(0xFFF472B6);
  static const Color blushDim = Color(0x1FF472B6);
  static const Color blushGlow = Color(0x4DF472B6);
  static const Color teal = Color(0xFF06B6D4);
  static const Color tealDim = Color(0x1F06B6D4);
  static const Color violet = Color(0xFF7C3AED);
  static const Color amber = Color(0xFFFBBF24);
  static const Color emerald = Color(0xFF10B981);

  static const LinearGradient grad = LinearGradient(
    colors: [Color(0xFFF472B6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradSoft = LinearGradient(
    colors: [Color(0x59F472B6), Color(0x597C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color t1 = Color(0xFFFFFFFF);
  static const Color t2 = Color(0xFF8E949A);
  static const Color t3 = Color(0xFF4A5058);

  static const Color brd = Color(0x0DFFFFFF);
  static const Color brdLt = Color(0x17FFFFFF);
}
