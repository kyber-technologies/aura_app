import 'dart:async';
import 'dart:convert';

import 'package:aura_app/chat.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/info.dart';
import 'package:aura_dart/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  final FlutterSecureStorage storage = FlutterSecureStorage(
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
  AuthState? auth;

  static Future<Storage> load() async {
    final Storage storage = Storage();

    // Load Settings
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

    // Load Chats
    {
      final String? json = await storage.storage.read(key: 'chats');

      if (json == null) {
        final ChatStorage defaultValue = ChatStorage.defaultValue();

        await storage.storage.write(key: 'chats', value: defaultValue.toJson());

        storage.chatStorage = defaultValue;
      } else {
        storage.chatStorage = ChatStorage.fromJson(json);
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
    // Save Settings
    await storage.write(key: 'settings', value: settings.toJson());

    // Save Chats
    await storage.write(key: 'chats', value: chatStorage.toJson());

    // Save Auth State
    if (auth != null) {
      await storage.write(key: 'auth', value: auth!.toJson());
    } else {
      await storage.delete(key: 'auth');
    }
  }
}

class ChatStorage {
  Map<String, Chat> chats;

  static ChatStorage defaultValue() => ChatStorage(<String, Chat>{});

  ChatStorage(this.chats);

  static ChatStorage fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;

    final Iterable<MapEntry<String, Chat>> chats = map.entries.map(
      (MapEntry<String, dynamic> entry) => MapEntry<String, Chat>(
        entry.key,
        Chat.fromJson(entry.value as String),
      ),
    );

    return ChatStorage(Map<String, Chat>.fromEntries(chats));
  }

  String toJson() {
    final Map<String, String> map = Map<String, String>.fromEntries(
      chats.entries.map(
        (MapEntry<String, Chat> entry) =>
            MapEntry<String, String>(entry.key, entry.value.toJson()),
      ),
    );

    return jsonEncode(map);
  }
}

class Settings {
  bool darkMode;
  bool animations;

  static Settings defaultValue() => Settings(darkMode: false, animations: true);

  Settings({required this.darkMode, required this.animations});

  static Settings fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;

    return Settings(
      darkMode: bool.parse(map['darkMode']! as String),
      animations: bool.parse(map['animations']! as String),
    );
  }

  String toJson() => jsonEncode(<String, String>{
    'darkMode': darkMode.toString(),
    'animations': animations.toString(),
  });
}
