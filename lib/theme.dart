import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff415e91),
    surfaceTint: Color(0xff415e91),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffd7e3ff),
    onPrimaryContainer: Color(0xff284777),
    secondary: Color(0xff4d5c92),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffdce1ff),
    onSecondaryContainer: Color(0xff354479),
    tertiary: Color(0xff3c6090),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffd4e3ff),
    onTertiaryContainer: Color(0xff224876),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xfff9f9ff),
    onSurface: Color(0xff191c20),
    onSurfaceVariant: Color(0xff44474e),
    outline: Color(0xff74777f),
    outlineVariant: Color(0xffc4c6d0),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2e3036),
    inversePrimary: Color(0xffaac7ff),
    primaryFixed: Color(0xffd7e3ff),
    onPrimaryFixed: Color(0xff001b3e),
    primaryFixedDim: Color(0xffaac7ff),
    onPrimaryFixedVariant: Color(0xff284777),
    secondaryFixed: Color(0xffdce1ff),
    onSecondaryFixed: Color(0xff03174b),
    secondaryFixedDim: Color(0xffb6c4ff),
    onSecondaryFixedVariant: Color(0xff354479),
    tertiaryFixed: Color(0xffd4e3ff),
    onTertiaryFixed: Color(0xff001c3a),
    tertiaryFixedDim: Color(0xffa5c8ff),
    onTertiaryFixedVariant: Color(0xff224876),
    surfaceDim: Color(0xffd9d9e0),
    surfaceBright: Color(0xfff9f9ff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff3f3fa),
    surfaceContainer: Color(0xffededf4),
    surfaceContainerHigh: Color(0xffe7e8ee),
    surfaceContainerHighest: Color(0xffe2e2e9),
  );

  ThemeData light() => theme(lightScheme());

  static ColorScheme lightMediumContrastScheme() => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff143665),
    surfaceTint: Color(0xff415e91),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xff506da0),
    onPrimaryContainer: Color(0xffffffff),
    secondary: Color(0xff233367),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xff5c6aa2),
    onSecondaryContainer: Color(0xffffffff),
    tertiary: Color(0xff0a3764),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff4b6e9f),
    onTertiaryContainer: Color(0xffffffff),
    error: Color(0xff740006),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffcf2c27),
    onErrorContainer: Color(0xffffffff),
    surface: Color(0xfff9f9ff),
    onSurface: Color(0xff0f1116),
    onSurfaceVariant: Color(0xff33363e),
    outline: Color(0xff4f525a),
    outlineVariant: Color(0xff6a6d75),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2e3036),
    inversePrimary: Color(0xffaac7ff),
    primaryFixed: Color(0xff506da0),
    onPrimaryFixed: Color(0xffffffff),
    primaryFixedDim: Color(0xff375586),
    onPrimaryFixedVariant: Color(0xffffffff),
    secondaryFixed: Color(0xff5c6aa2),
    onSecondaryFixed: Color(0xffffffff),
    secondaryFixedDim: Color(0xff435288),
    onSecondaryFixedVariant: Color(0xffffffff),
    tertiaryFixed: Color(0xff4b6e9f),
    onTertiaryFixed: Color(0xffffffff),
    tertiaryFixedDim: Color(0xff325685),
    onTertiaryFixedVariant: Color(0xffffffff),
    surfaceDim: Color(0xffc5c6cd),
    surfaceBright: Color(0xfff9f9ff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff3f3fa),
    surfaceContainer: Color(0xffe7e8ee),
    surfaceContainerHigh: Color(0xffdcdce3),
    surfaceContainerHighest: Color(0xffd1d1d8),
  );

  ThemeData lightMediumContrast() => theme(lightMediumContrastScheme());

  static ColorScheme lightHighContrastScheme() => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff042b5b),
    surfaceTint: Color(0xff415e91),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xff2b497a),
    onPrimaryContainer: Color(0xffffffff),
    secondary: Color(0xff18295c),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xff37467b),
    onSecondaryContainer: Color(0xffffffff),
    tertiary: Color(0xff002c57),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff254a79),
    onTertiaryContainer: Color(0xffffffff),
    error: Color(0xff600004),
    onError: Color(0xffffffff),
    errorContainer: Color(0xff98000a),
    onErrorContainer: Color(0xffffffff),
    surface: Color(0xfff9f9ff),
    onSurface: Color(0xff000000),
    onSurfaceVariant: Color(0xff000000),
    outline: Color(0xff292c33),
    outlineVariant: Color(0xff464951),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2e3036),
    inversePrimary: Color(0xffaac7ff),
    primaryFixed: Color(0xff2b497a),
    onPrimaryFixed: Color(0xffffffff),
    primaryFixedDim: Color(0xff0f3262),
    onPrimaryFixedVariant: Color(0xffffffff),
    secondaryFixed: Color(0xff37467b),
    onSecondaryFixed: Color(0xffffffff),
    secondaryFixedDim: Color(0xff1f2f63),
    onSecondaryFixedVariant: Color(0xffffffff),
    tertiaryFixed: Color(0xff254a79),
    onTertiaryFixed: Color(0xffffffff),
    tertiaryFixedDim: Color(0xff043361),
    onTertiaryFixedVariant: Color(0xffffffff),
    surfaceDim: Color(0xffb8b8bf),
    surfaceBright: Color(0xfff9f9ff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff0f0f7),
    surfaceContainer: Color(0xffe2e2e9),
    surfaceContainerHigh: Color(0xffd4d4db),
    surfaceContainerHighest: Color(0xffc5c6cd),
  );

  ThemeData lightHighContrast() => theme(lightHighContrastScheme());

  static ColorScheme darkScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffaac7ff),
    surfaceTint: Color(0xffaac7ff),
    onPrimary: Color(0xff0b305f),
    primaryContainer: Color(0xff284777),
    onPrimaryContainer: Color(0xffd7e3ff),
    secondary: Color(0xffb6c4ff),
    onSecondary: Color(0xff1d2d61),
    secondaryContainer: Color(0xff354479),
    onSecondaryContainer: Color(0xffdce1ff),
    tertiary: Color(0xffa5c8ff),
    onTertiary: Color(0xff00315e),
    tertiaryContainer: Color(0xff224876),
    onTertiaryContainer: Color(0xffd4e3ff),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff111318),
    onSurface: Color(0xffe2e2e9),
    onSurfaceVariant: Color(0xffc4c6d0),
    outline: Color(0xff8e9099),
    outlineVariant: Color(0xff44474e),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe2e2e9),
    inversePrimary: Color(0xff415e91),
    primaryFixed: Color(0xffd7e3ff),
    onPrimaryFixed: Color(0xff001b3e),
    primaryFixedDim: Color(0xffaac7ff),
    onPrimaryFixedVariant: Color(0xff284777),
    secondaryFixed: Color(0xffdce1ff),
    onSecondaryFixed: Color(0xff03174b),
    secondaryFixedDim: Color(0xffb6c4ff),
    onSecondaryFixedVariant: Color(0xff354479),
    tertiaryFixed: Color(0xffd4e3ff),
    onTertiaryFixed: Color(0xff001c3a),
    tertiaryFixedDim: Color(0xffa5c8ff),
    onTertiaryFixedVariant: Color(0xff224876),
    surfaceDim: Color(0xff111318),
    surfaceBright: Color(0xff37393e),
    surfaceContainerLowest: Color(0xff0c0e13),
    surfaceContainerLow: Color(0xff191c20),
    surfaceContainer: Color(0xff1e2025),
    surfaceContainerHigh: Color(0xff282a2f),
    surfaceContainerHighest: Color(0xff33353a),
  );

  ThemeData dark() => theme(darkScheme());

  static ColorScheme darkMediumContrastScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffcdddff),
    surfaceTint: Color(0xffaac7ff),
    onPrimary: Color(0xff002551),
    primaryContainer: Color(0xff7491c7),
    onPrimaryContainer: Color(0xff000000),
    secondary: Color(0xffd4dbff),
    onSecondary: Color(0xff102255),
    secondaryContainer: Color(0xff7f8ec8),
    onSecondaryContainer: Color(0xff000000),
    tertiary: Color(0xffcaddff),
    onTertiary: Color(0xff00264c),
    tertiaryContainer: Color(0xff7092c5),
    onTertiaryContainer: Color(0xff000000),
    error: Color(0xffffd2cc),
    onError: Color(0xff540003),
    errorContainer: Color(0xffff5449),
    onErrorContainer: Color(0xff000000),
    surface: Color(0xff111318),
    onSurface: Color(0xffffffff),
    onSurfaceVariant: Color(0xffdadce6),
    outline: Color(0xffafb1bb),
    outlineVariant: Color(0xff8e9099),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe2e2e9),
    inversePrimary: Color(0xff294879),
    primaryFixed: Color(0xffd7e3ff),
    onPrimaryFixed: Color(0xff00112b),
    primaryFixedDim: Color(0xffaac7ff),
    onPrimaryFixedVariant: Color(0xff143665),
    secondaryFixed: Color(0xffdce1ff),
    onSecondaryFixed: Color(0xff000d38),
    secondaryFixedDim: Color(0xffb6c4ff),
    onSecondaryFixedVariant: Color(0xff233367),
    tertiaryFixed: Color(0xffd4e3ff),
    onTertiaryFixed: Color(0xff001128),
    tertiaryFixedDim: Color(0xffa5c8ff),
    onTertiaryFixedVariant: Color(0xff0a3764),
    surfaceDim: Color(0xff111318),
    surfaceBright: Color(0xff43444a),
    surfaceContainerLowest: Color(0xff06070c),
    surfaceContainerLow: Color(0xff1b1e22),
    surfaceContainer: Color(0xff26282d),
    surfaceContainerHigh: Color(0xff313238),
    surfaceContainerHighest: Color(0xff3c3e43),
  );

  ThemeData darkMediumContrast() => theme(darkMediumContrastScheme());

  static ColorScheme darkHighContrastScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffebf0ff),
    surfaceTint: Color(0xffaac7ff),
    onPrimary: Color(0xff000000),
    primaryContainer: Color(0xffa6c3fc),
    onPrimaryContainer: Color(0xff000b20),
    secondary: Color(0xffeeefff),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xffb1c0fd),
    onSecondaryContainer: Color(0xff00082a),
    tertiary: Color(0xffeaf0ff),
    onTertiary: Color(0xff000000),
    tertiaryContainer: Color(0xffa2c4fb),
    onTertiaryContainer: Color(0xff000b1e),
    error: Color(0xffffece9),
    onError: Color(0xff000000),
    errorContainer: Color(0xffffaea4),
    onErrorContainer: Color(0xff220001),
    surface: Color(0xff111318),
    onSurface: Color(0xffffffff),
    onSurfaceVariant: Color(0xffffffff),
    outline: Color(0xffeeeff9),
    outlineVariant: Color(0xffc0c2cc),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe2e2e9),
    inversePrimary: Color(0xff294879),
    primaryFixed: Color(0xffd7e3ff),
    onPrimaryFixed: Color(0xff000000),
    primaryFixedDim: Color(0xffaac7ff),
    onPrimaryFixedVariant: Color(0xff00112b),
    secondaryFixed: Color(0xffdce1ff),
    onSecondaryFixed: Color(0xff000000),
    secondaryFixedDim: Color(0xffb6c4ff),
    onSecondaryFixedVariant: Color(0xff000d38),
    tertiaryFixed: Color(0xffd4e3ff),
    onTertiaryFixed: Color(0xff000000),
    tertiaryFixedDim: Color(0xffa5c8ff),
    onTertiaryFixedVariant: Color(0xff001128),
    surfaceDim: Color(0xff111318),
    surfaceBright: Color(0xff4e5056),
    surfaceContainerLowest: Color(0xff000000),
    surfaceContainerLow: Color(0xff1e2025),
    surfaceContainer: Color(0xff2e3036),
    surfaceContainerHigh: Color(0xff393b41),
    surfaceContainerHighest: Color(0xff45474c),
  );

  ThemeData darkHighContrast() => theme(darkHighContrastScheme());

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => <ExtendedColor>[];
}

class ExtendedColor {
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

TextTheme createTextTheme(BuildContext context) {
  final TextTheme baseTextTheme = Theme.of(context).textTheme;

  final TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    'Raleway',
    baseTextTheme,
  );

  final TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    'Quicksand',
    baseTextTheme,
  );

  final TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );

  return textTheme;
}
