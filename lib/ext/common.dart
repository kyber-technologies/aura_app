import 'package:aura_app/localizations.dart';
import 'package:aura_dart/resource.dart';
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

extension ResourceNamespaceExt on ResourceNamespace {
  String display() {
    switch (whichNamespace()) {
      case ResourceNamespace_Namespace.aura:
        return 'aura';
      case ResourceNamespace_Namespace.userIcon:
        return 'user_icon';
      case ResourceNamespace_Namespace.channel:
        return 'channel:$channel';
      case ResourceNamespace_Namespace.post:
        return 'post:$post';
      case ResourceNamespace_Namespace.notSet:
        return 'invalid';
    }
  }
}

extension ResourceIdExt on ResourceId {
  String display() => '$key${namespace.display()}';
}
