import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/pages/chat.dart';
import 'package:aura_app/pages/feed.dart';
import 'package:aura_app/pages/login.dart';
import 'package:aura_app/pages/profile/profile.dart';
import 'package:aura_app/pages/signup.dart';
import 'package:aura_app/storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const RouteDescriptor feedRoute = RouteDescriptor(
  path: '/',
  name: 'feed',
  page: FeedPage(),
);

const RouteDescriptor chatRoute = RouteDescriptor(
  path: '/chat',
  name: 'chat',
  page: ChatPage(),
);

const RouteDescriptor profileRoute = RouteDescriptor(
  path: '/profile',
  name: 'profile',
  page: ProfilePage(),
);

const RouteDescriptor loginRoute = RouteDescriptor(
  path: '/login',
  name: 'login',
  page: LoginPage(),
);

const RouteDescriptor signupRoute = RouteDescriptor(
  path: '/signup',
  name: 'signup',
  page: SignupPage(),
);

final FutureProvider<GoRouter> routerProvider = FutureProvider<GoRouter>((
  Ref ref,
) async {
  final AuthService auth = await ref.watch(authProvider.future);
  final bool animations = await ref.watch(
    storageProvider.selectAsync(
      (Storage storage) => storage.settings.animations,
    ),
  );

  return GoRouter(
    routes: <GoRoute>[
      feedRoute.toRoute(animations, auth),
      chatRoute.toRoute(animations, auth),
      profileRoute.toRoute(animations, auth),
      loginRoute.toRoute(animations, null),
      signupRoute.toRoute(animations, null),
    ],
    initialLocation: '/',
  );
});

Page<void> Function(BuildContext context, GoRouterState state) buildPage(
  Widget page,
  bool animations,
) =>
    (BuildContext context, GoRouterState state) => animations
    ? MaterialPage<void>(child: page)
    : NoTransitionPage<void>(child: page);

String? Function(BuildContext context, GoRouterState state) buildRedirect(
  AuthService auth,
) => (BuildContext context, GoRouterState state) {
  if (!auth.isValid()) {
    logger.i('Not authenticated. Redirecting to login route...');
    return loginRoute.path;
  }

  return null;
};

@immutable
class RouteDescriptor {
  final String path;
  final String name;
  final Widget page;

  const RouteDescriptor({
    required this.path,
    required this.name,
    required this.page,
  });

  GoRoute toRoute(bool animations, AuthService? auth) => GoRoute(
    path: path,
    name: name,
    pageBuilder: buildPage(page, animations),
    redirect: auth == null ? (_, _) => null : buildRedirect(auth),
  );
}
