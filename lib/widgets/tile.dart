import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String? tooltip;
  final Widget title;
  final Widget content;
  final double? spacing;

  const Tile({
    required this.title,
    required this.content,
    this.tooltip,
    this.spacing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget titleWidget = tooltip != null
        ? Tooltip(message: tooltip, child: title)
        : title;

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(width: 750, height: 50),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(alignment: Alignment.centerLeft, child: titleWidget),
            ),

            SizedBox(width: spacing),

            Expanded(
              flex: 3,
              child: Align(alignment: Alignment.centerRight, child: content),
            ),
          ],
        ),
      ),
    );
  }
}
