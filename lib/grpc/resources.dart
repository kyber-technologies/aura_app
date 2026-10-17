import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aura_app/ext/common.dart';
import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/grpc/cooldown.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_dart/resource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lru_cache/lru_cache.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

const int _maxCacheSize = 300;
const int _maxStoredSize = 100;
const int _maxCachedResourceSize = 500 * 1024;
const String _storedResourcesKey = 'storedResources';

final FutureProvider<ResourceManager> resourceProvider =
    FutureProvider<ResourceManager>(
      (Ref ref) async => await ResourceManager.init(ref),
    );

class ResourceManager {
  final Storage _storage;
  final AuraClient _client;
  final AuthService _auth;
  final CooldownProvider _cooldowns;
  final LruCache<ResourceId, Resource> _cache = LruCache<ResourceId, Resource>(
    _maxCacheSize,
  );

  ResourceManager(this._storage, this._client, this._auth, this._cooldowns);

  static Future<ResourceManager> init(Ref ref) async {
    final Storage storage = await ref.read(storageProvider.future);
    final AuraClient client = await ref.read(auraClientProvider.future);
    final AuthService auth = await ref.watch(authProvider.future);
    final CooldownProvider cooldowns = ref.watch(cooldownProvider);

    final ResourceManager resourceManager = ResourceManager(
      storage,
      client,
      auth,
      cooldowns,
    );

    await resourceManager._storage.lock((FlutterSecureStorage storage) async {
      if (!await storage.containsKey(key: _storedResourcesKey)) {
        await storage.write(
          key: _storedResourcesKey,
          value: json.encode(<String>[]),
        );
      }
    });

    await resourceManager._cleanStored();

    return resourceManager;
  }

  Future<void> delete(ResourceId id) async {
    final Resource? res = await _read(id);

    if (res == null) {
      return;
    }

    if (_shouldCache(id, res.meta)) {
      await _cache.remove(id);
    } else {
      final String key = id.display();
      await _storage.lock((FlutterSecureStorage storage) async {
        await storage.delete(key: key);
      });
    }
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

  bool _shouldCache(ResourceId id, ResourceMeta meta) {
    if ((id.namespace.hasUserIcon() && id.key == _auth.user.userId) ||
        meta.size > _maxCachedResourceSize) {
      return false;
    }

    return true;
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

  Future<Resource?> _read(ResourceId id) async {
    final Resource? cached = await _cache.get(id);

    if (cached != null) {
      return cached;
    }

    final String? stored = await _storage.lock(
      (FlutterSecureStorage storage) async =>
          await storage.read(key: id.display()),
    );

    if (stored == null) {
      return null;
    }

    return Resource.fromJson(stored);
  }

  Future<void> _write(ResourceId id, Resource resource) async {
    if (_shouldCache(id, resource.meta)) {
      await _cache.put(id, resource);
    } else {
      await _storage.lock((FlutterSecureStorage storage) async {
        final String? rawStored = await storage.read(key: _storedResourcesKey);
        final List<String> stored =
            rawStored != null
                  ? List<String>.from(json.decode(rawStored) as List<dynamic>)
                  : <String>[]
              ..add(id.display());

        await storage.write(
          key: _storedResourcesKey,
          value: json.encode(stored),
        );

        await storage.write(key: id.display(), value: resource.toJson());
      });
    }
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

  Future<void> _cleanStored() async {
    await _storage.lock((FlutterSecureStorage storage) async {
      final String? rawStored = await storage.read(key: _storedResourcesKey);
      if (rawStored == null) {
        return;
      }

      final List<String> stored = List<String>.from(
        json.decode(rawStored) as List<dynamic>,
      );

      if (stored.length > _maxStoredSize) {
        final List<String> toRemove = stored.sublist(
          0,
          stored.length - _maxStoredSize,
        );
        final List<String> retained = stored.sublist(
          stored.length - _maxStoredSize,
        );

        for (final String key in toRemove) {
          await storage.delete(key: key);
        }

        await storage.write(
          key: _storedResourcesKey,
          value: json.encode(retained),
        );
      }
    });
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
