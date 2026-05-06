import 'package:aura_app/ext.dart';
import 'package:aura_app/info.dart';
import 'package:aura_app/localizations.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await initLogger();
  await initInfo();

  logger.i('Launching ${packageInfo.appName} v${packageInfo.version}...');

  runApp(const ProviderScope(child: App()));
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = ref.watch(themeProvider);
    final Future<GoRouter> routerFut = ref.watch(routerProvider.future);

    return FutureBuilder<GoRouter>(
      future: routerFut,
      builder: (BuildContext context, AsyncSnapshot<GoRouter> snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Aura Error',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}').error(context),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final GoRouter router = snapshot.data!;

          return MaterialApp.router(
            title: 'Aura',
            theme: theme,
            debugShowCheckedModeBanner: false,
            routerConfig: RouterConfig<RouteMatchList>(
              routerDelegate: router.routerDelegate,
              routeInformationParser: router.routeInformationParser,
              routeInformationProvider: router.routeInformationProvider,
              backButtonDispatcher: router.backButtonDispatcher,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        } else {
          return MaterialApp(
            title: 'Loading Aura',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const Scaffold(
              body: Center(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Flexible(child: LinearProgressIndicator()),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
