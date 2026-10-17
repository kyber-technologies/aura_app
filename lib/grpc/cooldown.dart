import 'package:aura_app/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Provider<CooldownProvider> cooldownProvider = Provider<CooldownProvider>(
  (Ref ref) => CooldownProvider(),
);

class CooldownProvider {
  final Map<Action, DateTime> _entries = <Action, DateTime>{};

  CooldownProvider();

  bool onCooldown(Action action) {
    final DateTime? lastUse = _entries[action];

    if (lastUse != null) {
      final bool cd = lastUse.add(action.cooldown).isAfter(DateTime.now());

      if(cd) {
        logger.i('$action on cooldown!');
      }

      return cd;
    } else {
      _entries[action] = DateTime.now();

      return false;
    }
  }
}

enum Action {
  resourceMeta;

  Duration get cooldown {
    switch (this) {
      case Action.resourceMeta:
        return const Duration(seconds: 5);
    }
  }
}
