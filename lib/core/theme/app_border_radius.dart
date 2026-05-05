import 'package:flutter/material.dart';

/// Corner radii from DESIGN.html (Tailwind rounded-* classes).
class AppBorderRadius {
  AppBorderRadius._();

  // --- Raw values ---
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;

  static const double circular = 999;

  // --- Semantic shortcuts ---

  /// Buttons — rounded-2xl (16px) from DESIGN.html.
  static const BorderRadius button = BorderRadius.all(Radius.circular(s16));

  /// Inputs — rounded-2xl (16px) from DESIGN.html.
  static const BorderRadius input = BorderRadius.all(Radius.circular(s16));

  /// Cards — rounded-2xl (16px).
  static const BorderRadius card = BorderRadius.all(Radius.circular(s16));

  /// Logo container — rounded-2xl (16px).
  static const BorderRadius logo = BorderRadius.all(Radius.circular(s16));

  /// Small logo / icon container — rounded-xl (12px).
  static const BorderRadius logoSmall = BorderRadius.all(Radius.circular(s12));

  /// Dialog — rounded-2xl (16px).
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(s20));

  /// Bottom sheet — rounded top 32px.
  static const BorderRadius bottomSheet = BorderRadius.vertical(
    top: Radius.circular(s32),
  );

  /// Phone frame — rounded-[40px] from DESIGN.html.
  static const BorderRadius frame = BorderRadius.all(Radius.circular(s40));

  /// Pills, chips, full-round tags — rounded-full.
  static const BorderRadius pill = BorderRadius.all(Radius.circular(circular));

  /// Comment bubble — rounded-2xl (16px).
  static const BorderRadius commentBubble =
      BorderRadius.all(Radius.circular(s16));

  /// Avatar — fully circular.
  static const BorderRadius avatar =
      BorderRadius.all(Radius.circular(circular));

  /// Chip — fully circular.
  static const BorderRadius chip =
      BorderRadius.all(Radius.circular(circular));
}
