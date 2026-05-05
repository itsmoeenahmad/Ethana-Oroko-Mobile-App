import 'package:flutter/material.dart';

/// Etana Oroko palette — extracted from `DESIGN.html`.
class AppColors {
  AppColors._();

  // --- Brand Blue (from Tailwind config in DESIGN.html) ---
  /// brand-50 (`#eff6ff`) — lightest tint, subtle backgrounds.
  static const Color brand50 = Color(0xFFEFF6FF);

  /// brand-100 (`#dbeafe`) — light blue backgrounds, hover states.
  static const Color brand100 = Color(0xFFDBEAFE);

  /// brand-500 (`#3b82f6`) — primary blue, icons, highlights.
  static const Color brand500 = Color(0xFF3B82F6);

  /// brand-600 (`#2563eb`) — main brand, buttons, links, active states.
  static const Color brand600 = Color(0xFF2563EB);

  /// brand-700 (`#1d4ed8`) — hover/pressed state for brand elements.
  static const Color brand700 = Color(0xFF1D4ED8);

  /// brand-900 (`#1e3a8a`) — deep blue, dark accents.
  static const Color brand900 = Color(0xFF1E3A8A);

  /// Primary — main brand color used for buttons, links, selected states.
  static const Color primary = brand600;

  // --- Surfaces (from Tailwind slate scale) ---
  /// Scaffold / page background — slate-50 (`#f8fafc`).
  static const Color background = Color(0xFFF8FAFC);

  /// Outer background — slate-200 (`#e2e8f0`).
  static const Color backgroundAlt = Color(0xFFE2E8F0);

  /// Cards, inputs, panels — white (`#ffffff`).
  static const Color surface = Color(0xFFFFFFFF);

  /// App bar / sticky header with blur — white/80%.
  static const Color surfaceTranslucent = Color(0xCCFFFFFF);

  // --- Text (from Tailwind slate scale) ---
  /// Primary text — slate-900 (`#0f172a`).
  static const Color textPrimary = Color(0xFF0F172A);

  /// Secondary text — slate-500 (`#64748b`).
  static const Color textSecondary = Color(0xFF64748B);

  /// Tertiary / hints / placeholders — slate-400 (`#94a3b8`).
  static const Color textTertiary = Color(0xFF94A3B8);

  /// Muted label text — slate-600 (`#475569`).
  static const Color textLabel = Color(0xFF475569);

  // --- Borders / Dividers ---
  /// Default borders — slate-200 (`#e2e8f0`).
  static const Color border = Color(0xFFE2E8F0);

  /// Subtle dividers — slate-100 (`#f1f5f9`).
  static const Color borderLight = Color(0xFFF1F5F9);

  /// Input border on hover — slate-300 (`#cbd5e1`).
  static const Color borderMedium = Color(0xFFCBD5E1);

  // --- Semantic ---
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  /// Error border — red-300 (`#fca5a5`).
  static const Color errorBorder = Color(0xFFFCA5A5);

  /// Error icon — red-400 (`#f87171`).
  static const Color errorIcon = Color(0xFFF87171);

  /// Error text — red-500 (`#ef4444`).
  static const Color errorText = Color(0xFFEF4444);

  // --- Avatar / initials backgrounds (from DESIGN.html post cards) ---
  /// Teal — e.g. "ME" avatar.
  static const Color avatarTeal = Color(0xFFCCFBF1);
  static const Color avatarTealText = Color(0xFF0D9488);

  /// Blue — e.g. "JA" avatar.
  static const Color avatarBlue = Color(0xFFDBEAFE);
  static const Color avatarBlueText = Color(0xFF2563EB);

  /// Indigo — e.g. "JD" avatar.
  static const Color avatarIndigo = Color(0xFFE0E7FF);
  static const Color avatarIndigoText = Color(0xFF4F46E5);

  /// Orange — e.g. "SO" avatar.
  static const Color avatarOrange = Color(0xFFFFEDD5);
  static const Color avatarOrangeText = Color(0xFFEA580C);

  // --- Base ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  /// Scrim / overlays — ring-white/10.
  static const Color overlayLight = Color(0x1AFFFFFF);

  /// Dark overlay.
  static const Color overlayDark = Color(0x80000000);

  // --- Navigation ---
  static const Color navActive = primary;
  static const Color navInactive = textSecondary;

  // --- Dark theme (stub for future) ---
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
