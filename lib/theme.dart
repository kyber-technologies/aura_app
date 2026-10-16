import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff3B5BDB),
    surfaceTint: Color(0xff3B5BDB),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffD6E4FF),
    onPrimaryContainer: Color(0xff001C3B),
    secondary: Color(0xff5C5C96),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffE2E0FF),
    onSecondaryContainer: Color(0xff18154F),
    tertiary: Color(0xff794C9E),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffF2DAFF),
    onTertiaryContainer: Color(0xff2D004C),
    error: Color(0xffBA1A1A),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffFFDAD6),
    onErrorContainer: Color(0xff93000A),
    surface: Color(0xffF8F9FE),
    onSurface: Color(0xff1A1B22),
    onSurfaceVariant: Color(0xff444750),
    outline: Color(0xff747783),
    outlineVariant: Color(0xffC4C6D4),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2F3038),
    inversePrimary: Color(0xffADC6FF),
    primaryFixed: Color(0xffD6E4FF),
    onPrimaryFixed: Color(0xff001C3B),
    primaryFixedDim: Color(0xffADC6FF),
    onPrimaryFixedVariant: Color(0xff1D4277),
    secondaryFixed: Color(0xffE2E0FF),
    onSecondaryFixed: Color(0xff18154F),
    secondaryFixedDim: Color(0xffC2C1EC),
    onSecondaryFixedVariant: Color(0xff44437D),
    tertiaryFixed: Color(0xffF2DAFF),
    onTertiaryFixed: Color(0xff2D004C),
    tertiaryFixedDim: Color(0xffE8B6FF),
    onTertiaryFixedVariant: Color(0xff5F3383),
    surfaceDim: Color(0xffD8D9E2),
    surfaceBright: Color(0xffF8F9FE),
    surfaceContainerLowest: Color(0xffFFFFFF),
    surfaceContainerLow: Color(0xffF2F3FB),
    surfaceContainer: Color(0xffECEEF5),
    surfaceContainerHigh: Color(0xffE6E8F0),
    surfaceContainerHighest: Color(0xffE0E2EA),
  );

  ThemeData light() => theme(lightScheme());

  static ColorScheme darkScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffADC6FF),
    surfaceTint: Color(0xffADC6FF),
    onPrimary: Color(0xff002E63),
    primaryContainer: Color(0xff1D4277),
    onPrimaryContainer: Color(0xffD6E4FF),
    secondary: Color(0xffC2C1EC),
    onSecondary: Color(0xff2D2C64),
    secondaryContainer: Color(0xff44437D),
    onSecondaryContainer: Color(0xffE2E0FF),
    tertiary: Color(0xffE8B6FF),
    onTertiary: Color(0xff481B6C),
    tertiaryContainer: Color(0xff5F3383),
    onTertiaryContainer: Color(0xffF2DAFF),
    error: Color(0xffFFB4AB),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000A),
    onErrorContainer: Color(0xffFFDAD6),
    surface: Color(0xff111318),
    onSurface: Color(0xffE2E2EC),
    onSurfaceVariant: Color(0xffC4C6D4),
    outline: Color(0xff8E909D),
    outlineVariant: Color(0xff444750),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffE2E2EC),
    inversePrimary: Color(0xff3B5BDB),
    primaryFixed: Color(0xffD6E4FF),
    onPrimaryFixed: Color(0xff001C3B),
    primaryFixedDim: Color(0xffADC6FF),
    onPrimaryFixedVariant: Color(0xff1D4277),
    secondaryFixed: Color(0xffE2E0FF),
    onSecondaryFixed: Color(0xff18154F),
    secondaryFixedDim: Color(0xffC2C1EC),
    onSecondaryFixedVariant: Color(0xff44437D),
    tertiaryFixed: Color(0xffF2DAFF),
    onTertiaryFixed: Color(0xff2D004C),
    tertiaryFixedDim: Color(0xffE8B6FF),
    onTertiaryFixedVariant: Color(0xff5F3383),
    surfaceDim: Color(0xff111318),
    surfaceBright: Color(0xff373940),
    surfaceContainerLowest: Color(0xff0C0E13),
    surfaceContainerLow: Color(0xff191B22),
    surfaceContainer: Color(0xff1D2026),
    surfaceContainerHigh: Color(0xff272A31),
    surfaceContainerHighest: Color(0xff32353C),
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
  final TextTheme baseTextTheme = Typography.material2021().black;

  final TextTheme bodyTextTheme = GoogleFonts.ralewayTextTheme(baseTextTheme);

  final TextTheme displayTextTheme = GoogleFonts.quicksandTextTheme(
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
