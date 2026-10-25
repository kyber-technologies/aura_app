import 'dart:async';
import 'dart:convert';

import 'package:aura_app/chat.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/notifications.dart';
import 'package:aura_app/info.dart';
import 'package:aura_dart/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';

final UserSettings defaultUserSettings = UserSettings(
  resetAlgoTags: <String>[],
  allowInvites: true,
  algoLikeWeight: 0.65,
  algoDislikeWeight: 0.5,
  algoCommentWeight: 0.8,
  algoTimeDecay: 0.55,
);

final AsyncNotifierProvider<StorageNotifier, Storage> storageProvider =
    AsyncNotifierProvider<StorageNotifier, Storage>(StorageNotifier.new);

class StorageNotifier extends AsyncNotifier<Storage> {
  @override
  Future<Storage> build() async => await Storage.load();

  Future<void> updateSettings(void Function(Settings settings) update) async {
    final Storage currentStorage = await future;

    update(currentStorage.settings);

    await currentStorage.save();

    ref.invalidateSelf();
    await future;
  }
}

class Storage {
  final Lock _lock = Lock();
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accountName: 'aura',
      label: packageInfo.packageName,
      description: 'Aura Secure Storage',
    ),
    aOptions: AndroidOptions(
      storageNamespace: packageInfo.appName,
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

  late Settings settings;
  late ChatStorage chatStorage;
  late NotificationStorage notificationStorage;

  AuthState? auth;

  static Future<Storage> load() async {
    final Storage storage = Storage();

    // Load Settings
    {
      final String? json = await storage._storage.read(key: 'settings');

      if (json == null) {
        final Settings defaultValue = Settings.defaultValue();

        await storage._storage.write(
          key: 'settings',
          value: jsonEncode(defaultValue.toJson()),
        );

        storage.settings = defaultValue;
      } else {
        storage.settings = Settings.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
      }
    }

    // Load Chats
    {
      final String? json = await storage._storage.read(key: 'chats');

      if (json == null) {
        final ChatStorage defaultValue = ChatStorage.defaultValue();

        await storage._storage.write(
          key: 'chats',
          value: jsonEncode(defaultValue.toJson()),
        );

        storage.chatStorage = defaultValue;
      } else {
        storage.chatStorage = ChatStorage.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
      }
    }

    // Load Notifications
    {
      final String? json = await storage._storage.read(key: 'notifications');

      if (json == null) {
        final NotificationStorage defaultValue =
            NotificationStorage.defaultValue();

        await storage._storage.write(
          key: 'notifications',
          value: jsonEncode(defaultValue.toJson()),
        );

        storage.notificationStorage = defaultValue;
      } else {
        storage.notificationStorage = NotificationStorage.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
      }
    }

    // Load Auth State
    {
      final String? json = await storage._storage.read(key: 'auth');

      if (json != null) {
        storage.auth = AuthState.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
      }
    }

    return storage;
  }

  Future<void> save() async {
    await lock((FlutterSecureStorage storage) async {
      // Save Settings
      await storage.write(
        key: 'settings',
        value: jsonEncode(settings.toJson()),
      );

      // Save Chats
      await storage.write(
        key: 'chats',
        value: jsonEncode(chatStorage.toJson()),
      );

      // Save Notifications
      await storage.write(
        key: 'notifications',
        value: jsonEncode(notificationStorage.toJson()),
      );

      // Save Auth State
      if (auth != null) {
        await storage.write(key: 'auth', value: jsonEncode(auth!.toJson()));
      } else {
        await storage.delete(key: 'auth');
      }
    });
  }

  Future<T> lock<T>(
    FutureOr<T> Function(FlutterSecureStorage storage) future,
  ) => _lock.synchronized(() async => await future(_storage));
}

class Settings {
  bool darkMode;
  bool animations;

  static Settings defaultValue() => Settings(darkMode: false, animations: true);

  Settings({required this.darkMode, required this.animations});

  static Settings fromJson(Map<String, dynamic> json) => Settings(
    darkMode: bool.parse(json['darkMode']! as String),
    animations: bool.parse(json['animations']! as String),
  );

  Map<String, dynamic> toJson() => <String, String>{
    'darkMode': darkMode.toString(),
    'animations': animations.toString(),
  };

  bool isDirty({bool? darkMode, bool? animations}) =>
      this.darkMode != (darkMode ?? this.darkMode) ||
      this.animations != (animations ?? this.animations);
}
