import 'dart:io';

import 'package:aura_app/ext/widgets.dart';
import 'package:aura_app/info.dart';
import 'package:aura_app/localizations.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/router.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_app/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await initLogger();
  await initInfo();

  logger.i('Launching ${packageInfo.appName} v${packageInfo.version}...');

  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    await windowManager.ensureInitialized();

    const WindowOptions windowOptions = WindowOptions(
      size: Size(1100, 680),
      minimumSize: Size(400, 300),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Aura',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const ProviderScope(child: App()));
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = useMemoized(() => createTextTheme(context));
    final GoRouter router = ref.watch(routerProvider);
    final Future<bool> darkThemeFut = ref.watch(
      storageProvider.selectAsync(
        (Storage storage) => storage.settings.darkMode,
      ),
    );

    return FutureBuilder<bool>(
      future: darkThemeFut,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return ScreenUtilPlusInit(
            minTextAdapt: true,
            autoRebuild: false,
            child: MaterialApp(
              title: 'Aura Error',
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}').error(context),
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final bool darkMode = snapshot.data!;

          return ScreenUtilPlusInit(
            minTextAdapt: true,
            autoRebuild: false,
            child: MaterialApp.router(
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
            ),
          );
        } else {
          return const ScreenUtilPlusInit(
            minTextAdapt: true,
            autoRebuild: false,
            child: MaterialApp(
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
            ),
          );
        }
      },
    );
  }
}
