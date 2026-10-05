import 'package:aura_app/localizations.dart';
import 'package:aura_app/widgets/copyable.dart';
import 'package:aura_dart/user.dart';
import 'package:flutter/material.dart';

extension LocalizeExt on BuildContext {
  AppLocalizations get l10n {
    final AppLocalizations? locales = AppLocalizations.of(this);

    if (locales == null) {
      throw Exception('Invalid locales selected');
    }

    return locales;
  }
}

extension TextExt on Text {
  Text copyWithStyle({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) => Text(
    data ?? '',
    key: key,
    style: style?.copyWith(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    semanticsIdentifier: semanticsIdentifier,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );

  Text headlineSmall(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.headlineSmall,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text headline(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.headlineMedium,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text headlineLarge(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.headlineLarge,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text bodySmall(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.bodySmall,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text body(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.bodyMedium,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text bodyLarge(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.bodyLarge,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text displaySmall(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.displaySmall,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text display(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.displayMedium,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text displayLarge(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.displayLarge,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text labelSmall(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.labelSmall,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text label(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.labelMedium,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text labelLarge(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.labelLarge,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text titleSmall(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.titleSmall,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text title(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.titleMedium,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text titleLarge(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: theme.textTheme.titleLarge,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text error(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(
        color: theme.colorScheme.error,
      ),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

extension WidgetExt on Widget {
  SelectionArea selectable() => SelectionArea(child: this);

  CopyableText copyable(String text) =>
      CopyableText(textToCopy: text, child: this);
}

extension UserSettingsExt on UserSettings {
  bool isDirty({
    List<String>? resetAlgoTags,
    bool? allowInvites,
    double? algoLikeWeight,
    double? algoDislikeWeight,
    double? algoCommentWeight,
    double? algoTimeDecay,
    bool? notifyInvite,
    bool? notifyMessage,
    bool? notifyComment,
  }) =>
      this.resetAlgoTags != resetAlgoTags ||
      this.allowInvites != allowInvites ||
      this.algoLikeWeight != algoLikeWeight ||
      this.algoDislikeWeight != algoDislikeWeight ||
      this.algoCommentWeight != algoCommentWeight ||
      this.algoTimeDecay != algoTimeDecay ||
      this.notifyInvite != notifyInvite ||
      this.notifyMessage != notifyMessage ||
      this.notifyComment != notifyComment;

  UserSettings update({
    List<String>? resetAlgoTags,
    bool? allowInvites,
    double? algoLikeWeight,
    double? algoDislikeWeight,
    double? algoCommentWeight,
    double? algoTimeDecay,
    bool? notifyInvite,
    bool? notifyMessage,
    bool? notifyComment,
  }) => UserSettings(
    resetAlgoTags: resetAlgoTags ?? this.resetAlgoTags,
    allowInvites: allowInvites ?? this.allowInvites,
    algoLikeWeight: algoLikeWeight ?? this.algoLikeWeight,
    algoDislikeWeight: algoDislikeWeight ?? this.algoDislikeWeight,
    algoCommentWeight: algoCommentWeight ?? this.algoCommentWeight,
    algoTimeDecay: algoTimeDecay ?? this.algoTimeDecay,
    notifyInvite: notifyInvite ?? this.notifyInvite,
    notifyMessage: notifyMessage ?? this.notifyMessage,
    notifyComment: notifyComment ?? this.notifyComment,
  );
}
