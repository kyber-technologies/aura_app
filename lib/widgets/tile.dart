import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

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
      padding: const EdgeInsets.only(left: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100.w,
          maxWidth: 600.w,
          minHeight: 36.h,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(alignment: Alignment.centerLeft, child: titleWidget),
            ),
            if (spacing != null) SizedBox(width: spacing),
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
