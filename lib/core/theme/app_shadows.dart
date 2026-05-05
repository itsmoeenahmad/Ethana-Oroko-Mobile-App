import 'package:flutter/material.dart';

/// Shadows from DESIGN.html (Tailwind shadow-* classes).
class AppShadows {
  AppShadows._();

  /// shadow-sm — subtle elevation for inputs, small cards.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000), // ~5% black
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// shadow — default elevation for cards.
  static const List<BoxShadow> base = [
    BoxShadow(
      color: Color(0x1A000000), // ~10% black
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000), // ~6% black
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  /// shadow-lg — logo container on splash.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ];

  /// shadow-2xl — phone frame / elevated panels.
  static const List<BoxShadow> xl2 = [
    BoxShadow(
      color: Color(0x40000000), // ~25% black
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];

  static const List<BoxShadow> none = [];
}
