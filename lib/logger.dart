import 'dart:io';

import 'package:aura_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

late final Logger logger;

Future<void> initLogger() async {
  const String level = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: kDebugMode ? 'debug' : 'info',
  );

  final String logDir = joinPaths(
    (await getApplicationDocumentsDirectory()).path,
    <String>['aura', 'logs'],
  );
  await Directory(logDir).create(recursive: true);

  logger = Logger(
    filter: ProductionFilter(),
    printer: HybridPrinter(
      SimplePrinter(),
      error: PrettyPrinter(),
      fatal: PrettyPrinter(),
    ),
    output: await _buildOutput(logDir),
    level: _parseLevel(level),
  );

  logger.i('Logger initialized!');

  if (!kIsWeb) {
    logger.i('Writing logs to $logDir');
  }
}

Level _parseLevel(String level) {
  switch (level.toLowerCase()) {
    case 'trace':
      return Level.trace;
    case 'debug':
      return Level.debug;
    case 'info':
      return Level.info;
    case 'warn':
      return Level.warning;
    case 'error':
      return Level.error;
    case 'fatal':
      return Level.fatal;
    case 'off':
      return Level.off;
    default:
      return kDebugMode ? Level.debug : Level.info;
  }
}

Future<LogOutput> _buildOutput(String logDir) async {
  if (kIsWeb) {
    return ConsoleOutput();
  }

  return MultiOutput(<LogOutput>[
    AdvancedFileOutput(
      path: logDir,
      writeImmediately: <Level>[Level.error, Level.fatal],
    ),
    ConsoleOutput(),
  ]);
}
