import 'package:aura_app/assets.dart';
import 'package:aura_app/ext/common.dart';
import 'package:aura_app/ext/text.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/info.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/widgets/avatar.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<AuthService> authFut = ref.watch(authProvider.future);

    return Scaffold(
      bottomNavigationBar: const Navbar(),
      body: Loader<AuthService>(
        authFut,
        (BuildContext context, WidgetRef ref, AuthService auth) => Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Avatar(auth.user.userId, width: 100, height: 100),
                  const SizedBox(height: 5),
                  Text(
                    auth.user.username,
                  ).titleLarge(context).copyable(auth.user.username),
                  Text('@${auth.user.userId}')
                      .titleLarge(context)
                      .copyWithStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      )
                      .copyable(auth.user.userId),
                  const SizedBox(height: 15),
                  FilledButton.icon(
                    onPressed: () {
                      context.goNamed(settingsRoute.name);
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(context.l10n.confirmLogout),
                          actions: <Widget>[
                            FilledButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(context.l10n.no),
                            ),
                            FilledButton.tonal(
                              onPressed: () async {
                                await auth.logout();

                                if (context.mounted) {
                                  context
                                    ..pop()
                                    ..goNamed(loginRoute.name);
                                }
                              },
                              child: Text(context.l10n.yes),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out'),
                  ),
                  const SizedBox(height: 30),
                  FilledButton.icon(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Aura',
                        applicationVersion: 'v${packageInfo.version}',
                        applicationIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(iconPath, width: 75, height: 75),
                        ),
                        applicationLegalese:
                            'Copyright (c) Mikail Plotzky 2026 '
                            'All rights reserved.',
                      );
                    },
                    icon: const Icon(Icons.groups),
                    label: const Text('About'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
