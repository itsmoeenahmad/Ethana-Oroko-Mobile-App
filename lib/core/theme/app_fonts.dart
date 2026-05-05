/// Bundled [Poppins](https://fonts.google.com/specimen/Poppins) static fonts.
/// Files in `assets/fonts/`: Regular (400), Medium (500), SemiBold (600).
/// Weights match DESIGN.html — see `DESIGN.html`.
class AppFonts {
  AppFonts._();

  /// Must match `family` in [pubspec.yaml] `flutter:` `fonts:`.
  static const String poppinsFamily = 'Poppins';

  /// Asset paths (for documentation / tooling; Flutter resolves via pubspec).
  static const String poppinsRegularFile = 'assets/fonts/Poppins-Regular.ttf';
  static const String poppinsMediumFile = 'assets/fonts/Poppins-Medium.ttf';
  static const String poppinsSemiBoldFile = 'assets/fonts/Poppins-SemiBold.ttf';
}
