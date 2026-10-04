import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/pages/chat.dart';
import 'package:aura_app/pages/feed.dart';
import 'package:aura_app/pages/login.dart';
import 'package:aura_app/pages/profile/profile.dart';
import 'package:aura_app/pages/profile/settings.dart';
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

const RouteDescriptor settingsRoute = RouteDescriptor(
  path: '/profile/settings',
  name: 'profile-settings',
  page: SettingsPage(),
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

final Provider<bool> animationsEnabledProvider = Provider<bool>(
  (Ref ref) => ref.watch(
    storageProvider.select(
      (AsyncValue<Storage> storage) =>
          storage.value?.settings.animations ?? true,
    ),
  ),
);

final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final AsyncValue<AuthService> authAsync = ref.watch(authProvider);
  final AuthService? auth = authAsync.value;

  return GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      feedRoute.toRoute(ref, auth),
      chatRoute.toRoute(ref, auth),
      profileRoute.toRoute(ref, auth),
      settingsRoute.toRoute(ref, auth),
      loginRoute.toRoute(ref, null),
      signupRoute.toRoute(ref, null),
    ],
  );
});

Page<void> Function(BuildContext context, GoRouterState state) buildPage(
  Widget page,
  Ref ref,
) => (BuildContext context, GoRouterState state) {
  final bool animations = ref.read(animationsEnabledProvider);

  if (!animations) {
    return NoTransitionPage<void>(key: state.pageKey, child: page);
  }

  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: page,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) => FadeTransition(opacity: animation, child: child),
  );
};

String? Function(BuildContext context, GoRouterState state) buildRedirect(
  AuthService? auth,
) => (BuildContext context, GoRouterState state) {
  if (auth == null || !auth.isValid()) {
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

  GoRoute toRoute(Ref ref, AuthService? auth) => GoRoute(
    path: path,
    name: name,
    pageBuilder: buildPage(page, ref),
    redirect: auth == null ? null : buildRedirect(auth),
  );
}
