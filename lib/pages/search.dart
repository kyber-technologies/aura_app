import 'package:aura_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Scaffold(
    bottomNavigationBar: Navbar(),
    body: Center(child: Text('Search')),
  );
}
