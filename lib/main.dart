import 'package:aura_app/ext.dart';
import 'package:aura_app/info.dart';
import 'package:aura_app/localizations.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final TextTheme textTheme = useMemoized(() => createTextTheme(context));
    final Future<GoRouter> routerFut = ref.watch(routerProvider.future);
    final Future<bool> darkThemeFut = ref.watch(
      storageProvider.future.select(
        (Future<Storage> fut) =>
            fut.then((Storage storage) => storage.settings.darkMode),
      ),
    );

    return FutureBuilder<(GoRouter, bool)>(
      future: routerFut.join(darkThemeFut),
      builder:
          (BuildContext context, AsyncSnapshot<(GoRouter, bool)> snapshot) {
            if (snapshot.hasError) {
              return MaterialApp(
                title: 'Aura Error',
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}').error(context),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              final GoRouter router = snapshot.data!.$1;
              final bool darkMode = snapshot.data!.$2;

              return MaterialApp.router(
                title: 'Aura',
                theme: darkMode
                    ? MaterialTheme(textTheme).dark()
                    : MaterialTheme(textTheme).light(),
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
              return const MaterialApp(
                title: 'Loading Aura',
                debugShowCheckedModeBanner: false,
                home: Scaffold(
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
