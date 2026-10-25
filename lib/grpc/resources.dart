import 'dart:async';
import 'dart:typed_data';

import 'package:aura_app/ext/common.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/cooldown.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_dart/resource.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lru_cache/lru_cache.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

const int _maxCacheSize = 300;

final FutureProvider<ResourceManager> resourceProvider =
    FutureProvider<ResourceManager>(
      (Ref ref) async => await ResourceManager.init(ref),
    );

class ResourceManager {
  final AuraClient _client;
  final AuthService _auth;
  final CooldownProvider _cooldowns;
  final LruCache<ResourceId, Resource> _cache = LruCache<ResourceId, Resource>(
    _maxCacheSize,
  );

  ResourceManager(this._client, this._auth, this._cooldowns);

  static Future<ResourceManager> init(Ref ref) async {
    final AuraClient client = await ref.read(auraClientProvider.future);
    final AuthService auth = await ref.watch(authProvider.future);
    final CooldownProvider cooldowns = ref.watch(cooldownProvider);

    return ResourceManager(client, auth, cooldowns);
  }

  Future<void> delete(ResourceId id) async {
    final Resource? res = await _read(id);

    if (res == null) {
      return;
    }

    await _cache.remove(id);
  }

  Future<Resource> fetch(ResourceId id) async {
    Resource? resource = await _read(id);

    if (resource == null) {
      logger.i('Downloading resource ${id.display()}...');
      resource = await _request(id);
      await _write(id, resource);
    } else if (await _hasChanged(id, resource)) {
      logger.i('Resource ${id.display} has changed, re-downloading...');
      resource = await _request(id);
      await _write(id, resource);
    }

    return resource;
  }

  Future<bool> _hasChanged(ResourceId id, Resource resource) async {
    if (_cooldowns.onCooldown(Action.resourceMeta)) {
      return false;
    }

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

  Future<Resource?> _read(ResourceId id) async => await _cache.get(id);

  Future<void> _write(ResourceId id, Resource resource) async {
    await _cache.put(id, resource);
  }

  Future<Resource> _request(ResourceId id) async {
    final Stream<DownloadResponse> stream = _client.resourceService.download(
      DownloadRequest(
        resourceId: ResourceId(
          namespace: ResourceNamespace(userIcon: Empty()),
          key: id.key,
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
}
