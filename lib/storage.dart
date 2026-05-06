import 'dart:convert';

import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FutureProvider<Storage> storageProvider = FutureProvider<Storage>(
  (Ref ref) async => await Storage.load(),
);

class Storage {
  final FlutterSecureStorage storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accountName: 'aura',
      label: packageInfo.packageName,
      description: 'Aura Secure Storage',
    ),
    aOptions: AndroidOptions(
      sharedPreferencesName: packageInfo.appName,
      preferencesKeyPrefix: '${packageInfo.packageName}.',
    ),
    webOptions: WebOptions(
      dbName: packageInfo.appName,
      publicKey: 'Miami XO – Bazooka',
    ),
    mOptions: MacOsOptions(
      accountName: packageInfo.appName,
      label: packageInfo.appName,
      description: 'Aura Secure Storage',
    ),
  );

  Settings settings = Settings.defaultValue();
  AuthState? auth;

  static Future<Storage> load() async {
    final Storage storage = Storage();

    // Load settings
    {
      final String? json = await storage.storage.read(key: 'settings');

      if (json == null) {
        final Settings defaultValue = Settings.defaultValue();

        await storage.storage.write(
          key: 'settings',
          value: defaultValue.toJson(),
        );

        storage.settings = defaultValue;
      } else {
        storage.settings = Settings.fromJson(json);
      }
    }

    // Load Auth State
    {
      final String? json = await storage.storage.read(key: 'auth');

      if (json != null) {
        storage.auth = AuthState.fromJson(json);
      }
    }

    return storage;
  }

  Future<void> save() async {
    // Save settings
    await storage.write(key: 'settings', value: settings.toJson());

    // Save auth
    if (auth != null) {
      await storage.write(key: 'auth', value: auth!.toJson());
    } else {
      await storage.delete(key: 'auth');
    }
  }
}

class Settings {
  late bool darkMode;
  late bool animations;

  static Settings defaultValue() => Settings(darkMode: false, animations: true);

  Settings({required this.darkMode, required this.animations});

  Settings.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;
    darkMode = bool.parse(map['darkMode']! as String);
    animations = bool.parse(map['animations']! as String);
  }

  String toJson() => jsonEncode(<String, String>{
    'darkMode': darkMode.toString(),
    'animations': animations.toString(),
  });
}
