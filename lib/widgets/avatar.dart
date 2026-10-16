import 'package:aura_app/grpc/resources.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_dart/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

class Avatar extends HookConsumerWidget {
  final String? userId;
  final Widget? image;
  final double width;
  final double height;

  const Avatar(
    this.userId, {
    required this.width,
    required this.height,
    super.key,
  }) : image = null;

  const Avatar.image(
    this.image, {
    required this.width,
    required this.height,
    super.key,
  }) : userId = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = useMemoized(
      () => Theme.of(context).colorScheme.primary,
    );

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            child: image != null
                ? SizedBox.expand(child: image)
                : _AvatarLoader(userId: userId!),
          ),
        ),
      ),
    );
  }
}

class _AvatarLoader extends HookConsumerWidget {
  final String userId;

  const _AvatarLoader({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<Resource> avatarFut = ref
        .read(
          resourceProvider.selectAsync(
            (ResourceManager manager) async => await manager.fetch(
              ResourceId(
                namespace: ResourceNamespace(userIcon: Empty()),
                key: userId,
              ),
            ),
          ),
        )
        .then((Future<Resource> fut) async => await fut);

    return Loader<Resource>(
      avatarFut,
      (BuildContext context, WidgetRef ref, Resource avatar) => Image.memory(
        avatar.data,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
