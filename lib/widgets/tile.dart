import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String? tooltip;
  final Widget title;
  final Widget content;
  final double? width;
  final double? spacing;

  const Tile({
    required this.title,
    required this.content,
    this.tooltip,
    this.width,
    this.spacing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget titleWidget = tooltip != null
        ? Tooltip(message: tooltip, child: title)
        : title;

    final Widget row = Row(
      children: <Widget>[
        const SizedBox(width: 15),
        Expanded(
          child: Align(alignment: Alignment.centerLeft, child: titleWidget),
        ),
        if (spacing != null) SizedBox(width: spacing),
        content,
        if (spacing != null) SizedBox(width: spacing),
      ],
    );

    return width == null ? row : SizedBox(width: width, child: row);
  }
}
