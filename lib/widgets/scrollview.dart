import 'package:flutter/material.dart';

class FullScrollView extends StatelessWidget {
  final Widget child;

  const FullScrollView({required this.child, super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    ),
  );
}
