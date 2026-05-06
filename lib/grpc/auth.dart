import 'dart:convert';

import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_dart/aura_dart.dart';
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

  UserProfile get profile {
    if (state == null) {
      throw Exception('User not authenticated');
    }

    return state!.profile;
  }

  AuthService(this._client, this._storage, this.state);

  static Future<AuthService> init(Ref ref) async {
    final Storage storage = await ref.read(storageProvider.future);
    final AuraClient client = ref.read(auraClientProvider);

    final AuthService authService = AuthService(client, storage, storage.auth);

    if (!authService.isValid()) {
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
    final AuthUserResponse response = await _client.userService().authUser(
      AuthUserRequest(userId: userId, password: password),
    );

    if (response.hasError()) {
      throw ServiceException(response.error);
    } else {
      final GetUserResponse userResponse = await _client.userService().getUser(
        GetUserRequest(userId: userId),
        options: CallOptions(
          metadata: <String, String>{'Authorization': response.token},
        ),
      );

      if (userResponse.hasError()) {
        throw ServiceException(userResponse.error);
      }

      state = AuthState(token: response.token, profile: userResponse.user);

      _storage.auth = state;
      await _storage.save();
    }
  }

  Future<void> logout() async {
    state = null;
    _storage.auth = null;

    await _storage.save();
  }

  CallOptions? buildOptions() => state == null
      ? null
      : CallOptions(metadata: <String, String>{'Authorization': state!.token});
}

class AuthState {
  late String token;
  late UserProfile profile;

  AuthState({required this.token, required this.profile});

  AuthState.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;
    token = map['token'] as String;
    profile = UserProfile.fromJson(map['profile'] as String);
  }

  String toJson() => jsonEncode(<String, String>{
    'token': token,
    'profile': profile.writeToJson(),
  });
}
