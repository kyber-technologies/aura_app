import 'package:aura_app/localizations.dart';
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
