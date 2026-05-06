import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Provider<ThemeData> themeProvider = Provider<ThemeData>(
  (Ref ref) => ThemeData.light(useMaterial3: true),
);

class MaterialTheme {
  late final TextTheme textTheme;

  MaterialTheme(BuildContext context) {
    textTheme = createTextTheme(context);
  }

  static ColorScheme lightScheme() => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff4f5b92),
    surfaceTint: Color(0xff4f5b92),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffdde1ff),
    onPrimaryContainer: Color(0xff374379),
    secondary: Color(0xff5a5d72),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffdfe1f9),
    onSecondaryContainer: Color(0xff424659),
    tertiary: Color(0xff3f5f90),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffd6e3ff),
    onTertiaryContainer: Color(0xff264777),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xfffbf8ff),
    onSurface: Color(0xff1b1b21),
    onSurfaceVariant: Color(0xff45464f),
    outline: Color(0xff767680),
    outlineVariant: Color(0xffc6c5d0),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2f3036),
    inversePrimary: Color(0xffb8c4ff),
    primaryFixed: Color(0xffdde1ff),
    onPrimaryFixed: Color(0xff07164b),
    primaryFixedDim: Color(0xffb8c4ff),
    onPrimaryFixedVariant: Color(0xff374379),
    secondaryFixed: Color(0xffdfe1f9),
    onSecondaryFixed: Color(0xff171b2c),
    secondaryFixedDim: Color(0xffc2c5dd),
    onSecondaryFixedVariant: Color(0xff424659),
    tertiaryFixed: Color(0xffd6e3ff),
    onTertiaryFixed: Color(0xff001b3d),
    tertiaryFixedDim: Color(0xffa8c8ff),
    onTertiaryFixedVariant: Color(0xff264777),
    surfaceDim: Color(0xffdbd9e0),
    surfaceBright: Color(0xfffbf8ff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff5f2fa),
    surfaceContainer: Color(0xffefedf4),
    surfaceContainerHigh: Color(0xffe9e7ef),
    surfaceContainerHighest: Color(0xffe3e1e9),
  );

  ThemeData light() => theme(lightScheme());

  static ColorScheme darkScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffb8c4ff),
    surfaceTint: Color(0xffb8c4ff),
    onPrimary: Color(0xff202c61),
    primaryContainer: Color(0xff374379),
    onPrimaryContainer: Color(0xffdde1ff),
    secondary: Color(0xffc2c5dd),
    onSecondary: Color(0xff2c2f42),
    secondaryContainer: Color(0xff424659),
    onSecondaryContainer: Color(0xffdfe1f9),
    tertiary: Color(0xffa8c8ff),
    onTertiary: Color(0xff07305f),
    tertiaryContainer: Color(0xff264777),
    onTertiaryContainer: Color(0xffd6e3ff),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff121318),
    onSurface: Color(0xffe3e1e9),
    onSurfaceVariant: Color(0xffc6c5d0),
    outline: Color(0xff90909a),
    outlineVariant: Color(0xff45464f),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe3e1e9),
    inversePrimary: Color(0xff4f5b92),
    primaryFixed: Color(0xffdde1ff),
    onPrimaryFixed: Color(0xff07164b),
    primaryFixedDim: Color(0xffb8c4ff),
    onPrimaryFixedVariant: Color(0xff374379),
    secondaryFixed: Color(0xffdfe1f9),
    onSecondaryFixed: Color(0xff171b2c),
    secondaryFixedDim: Color(0xffc2c5dd),
    onSecondaryFixedVariant: Color(0xff424659),
    tertiaryFixed: Color(0xffd6e3ff),
    onTertiaryFixed: Color(0xff001b3d),
    tertiaryFixedDim: Color(0xffa8c8ff),
    onTertiaryFixedVariant: Color(0xff264777),
    surfaceDim: Color(0xff121318),
    surfaceBright: Color(0xff38393f),
    surfaceContainerLowest: Color(0xff0d0e13),
    surfaceContainerLow: Color(0xff1b1b21),
    surfaceContainer: Color(0xff1f1f25),
    surfaceContainerHigh: Color(0xff292a2f),
    surfaceContainerHighest: Color(0xff34343a),
  );

  ThemeData dark() => theme(darkScheme());

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
