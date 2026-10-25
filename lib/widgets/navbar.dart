import 'package:aura_app/ext/common.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Navbar extends HookConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selected = useMemoized(() {
      final String routeName = GoRouterState.of(context).name ?? '';

      if (routeName == feedRoute.name) {
        return 0;
      } else if (routeName == searchRoute.name) {
        return 1;
      } else if (routeName == notificationsRoute.name) {
        return 2;
      } else if (routeName == chatRoute.name) {
        return 3;
      } else if (routeName == profileRoute.name ||
          routeName == settingsRoute.name ||
          routeName == loginRoute.name ||
          routeName == signupRoute.name) {
        return 4;
      } else {
        return 0;
      }
    });

    return NavigationBar(
      selectedIndex: selected,
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: const Icon(Icons.signpost),
          label: context.l10n.feed,
        ),
        NavigationDestination(
          icon: const Icon(Icons.search),
          label: context.l10n.search,
        ),
        NavigationDestination(
          icon: const Icon(Icons.notifications),
          label: context.l10n.notifications,
        ),
        NavigationDestination(
          icon: const Icon(Icons.chat),
          label: context.l10n.chat,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person),
          label: context.l10n.profile,
        ),
      ],

      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            context.goNamed(feedRoute.name);
          case 1:
            context.goNamed(searchRoute.name);
          case 2:
            context.goNamed(notificationsRoute.name);
          case 3:
            context.goNamed(chatRoute.name);
          case 4:
            context.goNamed(profileRoute.name);
          default:
            logger.e('Invalid destination: $index');
        }
      },
    );
  }
}
