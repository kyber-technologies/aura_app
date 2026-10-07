
import 'package:aura_app/ext/text.dart';
import 'package:aura_app/logger.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Loader<T> extends HookConsumerWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, WidgetRef ref, T result) builder;

  const Loader(this.future, this.builder, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureBuilder<T>(
    future: future,
    builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
      if (snapshot.hasError) {
        logger
          ..f('Future completed with error: ${snapshot.error}')
          ..f('Stack Trace: ${snapshot.stackTrace}');

        return Text(
          'Error: ${snapshot.error}',
        ).error(context).copyWithStyle(fontSize: 14);
      } else if (snapshot.hasData) {
        return builder(context, ref, snapshot.data as T);
      } else {
        return const Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
            ),
          ],
        );
      }
    },
  );
}
