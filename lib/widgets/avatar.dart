import 'package:aura_app/grpc/resources.dart';
import 'package:aura_app/sizer.dart';
import 'package:aura_app/theme.dart';
import 'package:aura_app/widgets/loader.dart';
import 'package:aura_dart/resource.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

class Avatar extends HookConsumerWidget {
  final String userId;
  final double width;
  final double height;

  const Avatar(
    this.userId, {
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = ref.watch(
      themeProvider.select((ThemeData theme) => theme.colorScheme.primary),
    );
    final Sizer sizer = useSizer(context);

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

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          border: Border.all(color: color, width: 2.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(sizer.sp(2.5)),
          child: Loader<Resource>(
            avatarFut,
            (BuildContext context, WidgetRef ref, Resource avatar) =>
                Image.memory(
                  avatar.data,
                  width: double.infinity,
                  height: double.infinity,
                ),
          ),
        ),
      ),
    );
  }
}
