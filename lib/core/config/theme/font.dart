part of 'typography.dart';

FontWeight get _light => FontWeight.w300;

FontWeight get _regular => FontWeight.normal;

FontWeight get _medium => FontWeight.w500;

FontWeight get _semiBold => FontWeight.w600;

FontWeight get _bold => FontWeight.bold;

FontWeight get _extraBold => FontWeight.w800;

extension FamilyUtils on TextStyle? {
  TextStyle? get xb => this?.copyWith(fontWeight: _extraBold);

  TextStyle? get b => this?.copyWith(fontWeight: _bold);

  TextStyle? get sb => this?.copyWith(fontWeight: _semiBold);

  TextStyle? get r => this?.copyWith(fontWeight: _regular);

  TextStyle? get m => this?.copyWith(fontWeight: _medium);

  TextStyle? get l => this?.copyWith(fontWeight: _light);

  TextStyle? get s48 => this?.copyWith(fontSize: _FontSize.font48Size);

  TextStyle? get s42 => this?.copyWith(fontSize: _FontSize.font42Size);

  TextStyle? get s40 => this?.copyWith(fontSize: _FontSize.font40Size);

  TextStyle? get s35 => this?.copyWith(fontSize: _FontSize.font35Size);

  TextStyle? get s34 => this?.copyWith(fontSize: _FontSize.font34Size);

  TextStyle? get s30 => this?.copyWith(fontSize: _FontSize.font30Size);

  TextStyle? get s38 => this?.copyWith(fontSize: _FontSize.font38Size);

  TextStyle? get s26 => this?.copyWith(fontSize: _FontSize.font26Size);

  TextStyle? get s32 => this?.copyWith(fontSize: _FontSize.font32Size);

  TextStyle? get s28 => this?.copyWith(fontSize: _FontSize.font28Size);

  TextStyle? get s27 => this?.copyWith(fontSize: _FontSize.font27Size);

  TextStyle? get s25 => this?.copyWith(fontSize: _FontSize.font25Size);

  TextStyle? get s23 => this?.copyWith(fontSize: _FontSize.font23Size);

  TextStyle? get s21 => this?.copyWith(fontSize: _FontSize.font21Size);

  TextStyle? get s20 => this?.copyWith(fontSize: _FontSize.font20Size);

  TextStyle? get s18 => this?.copyWith(fontSize: _FontSize.font18Size);

  TextStyle? get s17 => this?.copyWith(fontSize: _FontSize.font17Size);

  TextStyle? get s15 => this?.copyWith(fontSize: _FontSize.font15Size);

  TextStyle? get s13 => this?.copyWith(fontSize: _FontSize.font13Size);

  TextStyle? get s14 => this?.copyWith(fontSize: _FontSize.font14Size);

  TextStyle? get s10 => this?.copyWith(fontSize: _FontSize.font10Size);

  TextStyle? get s9 => this?.copyWith(fontSize: _FontSize.font9Size);

  TextStyle? withColor(Color? color) => this?.copyWith(color: color);
}

abstract class _FontSize {
  static double get displayLarge => _displayLargeFontSize.sp;
  static const double _displayLargeFontSize = 57;

  static double get displayMedium => _displayMediumFontSize.sp;
  static const double _displayMediumFontSize = 45;

  static double get font42Size => _font42Size.sp;
  static const double _font42Size = 42;

  static double get displaySmall => _displaySmallFontSize.sp;
  static const double _displaySmallFontSize = 36;
  static double get headlineLarge => _headlineLargeSize.sp;
  static const double _headlineLargeSize = 32;

  static double get headlineMedium => _headlineMediumFontSize.sp;
  static const double _headlineMediumFontSize = 28;

  static double get headlineSmall => _headlineSmallFontSize.sp;
  static const double _headlineSmallFontSize = 24;

  static double get titleLarge => _titleLargeFontSize.sp;
  static const double _titleLargeFontSize = 22;

  static double get titleMedium => _titleMediumFontSize.sp;
  static const double _titleMediumFontSize = 16;

  static double get titleSmall => _titleSmallFontSize.sp;
  static const double _titleSmallFontSize = 14;

  static double get bodyLarge => _bodyLargeSize.sp;
  static const double _bodyLargeSize = 16;

  static double get bodyMedium => _bodyMediumFontSize.sp;
  static const double _bodyMediumFontSize = 14;

  static double get bodySmall => _bodySmallFontSize.sp;
  static const double _bodySmallFontSize = 12;

  static double get labelLarge => _labelLargeFontSize.sp;
  static const double _labelLargeFontSize = 14;

  static double get labelMedium => _labelMediumFontSize.sp;
  static const double _labelMediumFontSize = 12;

  static double get labelSmall => _labelSmallFontSize.sp;
  static const double _labelSmallFontSize = 11;

  static double get font48Size => _font48Size.sp;
  static const double _font48Size = 48;

  static double get font40Size => _font40Size.sp;
  static const double _font40Size = 40;

  static double get font38Size => _font38Size.sp;
  static const double _font38Size = 38;

  static double get font35Size => _font35Size.sp;
  static const double _font35Size = 35;

  static double get font34Size => _font34Size.sp;
  static const double _font34Size = 34;

  static double get font30Size => _font30Size.sp;
  static const double _font30Size = 30;

  static double get font32Size => _font32Size.sp;
  static const double _font32Size = 32;

  static double get font28Size => _font28Size.sp;
  static const double _font28Size = 28;

  static double get font27Size => _font27Size.sp;
  static const double _font27Size = 27;

  static double get font26Size => _font26Size.sp;
  static const double _font26Size = 26;

  static double get font25Size => _font25Size.sp;
  static const double _font25Size = 26;

  static double get font23Size => _font23Size.sp;
  static const double _font23Size = 23;

  static double get font21Size => _font21Size.sp;
  static const double _font21Size = 21;

  static double get font20Size => _font20Size.sp;
  static const double _font20Size = 20;

  static double get font18Size => _font18Size.sp;
  static const double _font18Size = 18;

  static double get font17Size => _font17Size.sp;
  static const double _font17Size = 17;

  static double get font15Size => _font15Size.sp;
  static const double _font15Size = 15;

  static double get font13Size => _font13Size.sp;
  static const double _font13Size = 13;

  static double get font14Size => _font14Size.sp;
  static const double _font14Size = 14;

  static double get font10Size => _font10Size.sp;
  static const double _font10Size = 10;

  static double get font9Size => _font9Size.sp;
  static const double _font9Size = 9;
}
