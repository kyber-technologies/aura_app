import 'dart:convert';
import 'dart:typed_data';

import 'package:aura_app/ext/common.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_dart/resource.dart';
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

  Future<void> delete(ResourceId id) async {
    final String key = id.display();
    await _storage.storage.delete(key: key);
  }

  Future<Resource> fetch(ResourceId id) async {
    final String key = id.display();
    Resource? resource = await _read(key);

    if (resource == null) {
      logger.i('Downloading resource ${id.display()}...');
      resource = await _request(id);
      await _write(key, resource);
    } else if (await _hasChanged(id, resource)) {
      logger.i('Resource ${id.display} has changed, re-downloading...');
      resource = await _request(id);
      await _write(key, resource);
    }

    return resource;
  }

  Future<bool> _hasChanged(ResourceId id, Resource resource) async {
    final MetaResponse metaResponse = await _client.resourceService.meta(
      MetaRequest(resourceId: <ResourceId>[id]),
      options: _auth.buildOptions(),
    );

    if (metaResponse.hasError()) {
      throw ServiceException(metaResponse.error);
    }

    final ResourceMeta meta = metaResponse.metas[0];

    return meta.timestamp.seconds != resource.meta.timestamp.seconds;
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

    late ResourceMeta meta;
    final BytesBuilder byteBuilder = BytesBuilder();

    await for (final DownloadResponse response in stream) {
      if (response.hasMeta()) {
        meta = response.meta;
        continue;
      }

      if (response.hasError()) {
        throw ServiceException(response.error);
      }

      byteBuilder.add(response.data);
    }

    return Resource(meta, byteBuilder.takeBytes());
  }
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
