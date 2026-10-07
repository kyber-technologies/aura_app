
import 'package:aura_app/localizations.dart';
import 'package:aura_app/widgets/copyable.dart';
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

extension WidgetExt on Widget {
  SelectionArea selectable() => SelectionArea(child: this);

  CopyableText copyable(String text) =>
      CopyableText(textToCopy: text, child: this);
}
