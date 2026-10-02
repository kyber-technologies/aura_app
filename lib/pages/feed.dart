import 'package:aura_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: Navbar(),
      body: const Center(child: Text('Feed')),
    );
  }
}
