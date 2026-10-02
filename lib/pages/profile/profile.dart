import 'package:aura_app/assets.dart';
import 'package:aura_app/ext.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/info.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/sizer.dart';
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
    final Sizer sizer = useSizer(context);
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
                  Avatar(
                    auth.user.userId,
                    width: sizer.sp(25),
                    height: sizer.sp(25),
                  ),
                  Text(auth.user.username).headlineSmall(context).selectable(),
                  sizer.box(h: 5),
                  Text(
                    '@${auth.user.userId}',
                  ).headlineSmall(context).selectable(),
                  sizer.box(h: 5),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                  ),
                  sizer.box(h: 5),
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
                  sizer.box(h: 20),
                  FilledButton.icon(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Aura',
                        applicationVersion: 'v${packageInfo.version}',
                        applicationIcon: sizer.padding(
                          all: 5,
                          child: Image.asset(
                            iconPath,
                            width: sizer.sp(25),
                            height: sizer.sp(25),
                          ),
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
