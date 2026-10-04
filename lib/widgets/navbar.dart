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
      } else if (routeName == chatRoute.name) {
        return 1;
      } else if (routeName == profileRoute.name ||
          routeName == settingsRoute.name) {
        return 2;
      } else {
        return 0;
      }
    });

    return NavigationBar(
      selectedIndex: selected,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.signpost),
          label: 'Feed',
          tooltip: 'Go to your Feed',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat),
          label: 'Chat',
          tooltip: 'Open Chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profile',
          tooltip: 'Open Profile',
        ),
      ],

      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            context.goNamed(feedRoute.name);
          case 1:
            context.goNamed(chatRoute.name);
          case 2:
            context.goNamed(profileRoute.name);
          default:
            logger.e('Invalid destination: $index');
        }
      },
    );
  }
}
