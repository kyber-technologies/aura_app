import 'dart:convert';

import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_dart/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

final FutureProvider<ResourceManager> resourceProvider =
    FutureProvider<ResourceManager>(
      (Ref ref) async => await ResourceManager.init(ref),
    );

class ResourceManager {
  final Storage _storage;
  final AuraClient _client;
  final AuthService _auth;

  ResourceManager(this._storage, this._client, this._auth);

  static Future<ResourceManager> init(Ref ref) async {
    final Storage storage = await ref.read(storageProvider.future);
    final AuraClient client = await ref.read(auraClientProvider.future);
    final AuthService auth = await ref.watch(authProvider.future);

    return ResourceManager(storage, client, auth);
  }

  Future<Resource> fetch(ResourceId id) async {
    final String key = buildKey(id);
    Resource? resource = await _read(key);

    if (resource == null) {
      resource = await _request(id);
      await _write(key, resource);
    }

    return resource;
  }

  Future<Resource?> _read(String key) async {
    final String? data = await _storage.storage.read(key: key);

    if (data == null) {
      return null;
    }

    return Resource.fromJson(data);
  }

  Future<void> _write(String key, Resource resource) async {
    await _storage.storage.write(key: key, value: resource.toJson());
  }

  Future<Resource> _request(ResourceId id) async {
    final Stream<DownloadResponse> stream = _client.resourceService.download(
      DownloadRequest(
        resourceId: ResourceId(
          namespace: ResourceNamespace(userIcon: Empty()),
          key: _auth.user.userId,
        ),
      ),
      options: _auth.buildOptions(),
    );

    late Uint8List data;
    late ResourceMeta meta;
    int offset = 0;

    await for (final DownloadResponse response in stream) {
      if (response.hasMeta()) {
        meta = response.meta;
        data = Uint8List(response.meta.size);
        continue;
      }

      final List<int> chunk = response.data;

      data.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    return Resource(meta, data);
  }

  static String buildKey(ResourceId id) => 'resource:$id';
}

class Resource {
  final ResourceMeta meta;
  final Uint8List data;

  Resource(this.meta, this.data);

  String toJson() {
    final String metaJson = meta.writeToJson();

    return json.encode(<String, dynamic>{
      'meta': metaJson,
      'data': data.toList(),
    });
  }

  static Resource fromJson(String jsonString) {
    final Map<String, dynamic> map =
        json.decode(jsonString) as Map<String, dynamic>;

    final ResourceMeta meta = ResourceMeta.fromJson(map['meta'] as String);
    final Uint8List data = Uint8List.fromList(
      (map['data'] as List<dynamic>).cast(),
    );

    return Resource(meta, data);
  }
}
