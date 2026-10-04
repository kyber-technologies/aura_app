import 'dart:convert';

import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_dart/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FutureProvider<AuthService> authProvider = FutureProvider<AuthService>(
  (Ref ref) async => await AuthService.init(ref),
);

class AuthService {
  late final AuraClient _client;
  late final Storage _storage;
  AuthState? state;

  String get token {
    if (state == null) {
      throw Exception('User not authenticated');
    }

    return state!.token;
  }

  User get user {
    if (state == null) {
      throw Exception('User not authenticated');
    }

    return state!.user;
  }

  AuthService(this._client, this._storage, this.state);

  static Future<AuthService> init(Ref ref) async {
    final Storage storage = await ref.read(storageProvider.future);
    final AuraClient client = await ref.read(auraClientProvider.future);

    final AuthService authService = AuthService(client, storage, storage.auth);

    if (authService.isValid()) {
      await authService.refresh();
    } else {
      authService.state = null;
      storage.auth = null;
    }

    return authService;
  }

  bool isValid() {
    if (state != null) {
      final Map<String, dynamic> claim =
          JWT.decode(state!.token).payload as Map<String, dynamic>;
      return claim['exp'] as int > DateTime.now().millisecondsSinceEpoch / 1000;
    }

    return false;
  }

  Future<void> login({required String userId, required String password}) async {
    final AuthResponse response = await _client.userService.auth(
      AuthRequest(userId: userId, password: password),
    );

    if (response.hasError()) {
      throw ServiceException(response.error);
    } else {
      state = AuthState(token: response.token, user: response.user);

      _storage.auth = state;
      await _storage.save();
    }
  }

  Future<void> logout() async {
    state = null;
    _storage.auth = null;

    await _storage.save();
  }

  Future<void> refresh() async {
    final AuthResponse response = await _client.userService.auth(
      AuthRequest(),
      options: buildOptions(),
    );

    if (response.hasError()) {
      throw ServiceException(response.error);
    } else {
      state = AuthState(token: response.token, user: response.user);
      _storage.auth = state;
      await _storage.save();
    }
  }

  CallOptions? buildOptions() => state == null
      ? null
      : CallOptions(metadata: <String, String>{'Authorization': state!.token});
}

class AuthState {
  String token;
  User user;

  AuthState({required this.token, required this.user});

  static AuthState fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;

    return AuthState(
      token: map['token'] as String,
      user: User.fromJson(map['user'] as String),
    );
  }

  String toJson() =>
      jsonEncode(<String, String>{'token': token, 'user': user.writeToJson()});
}
