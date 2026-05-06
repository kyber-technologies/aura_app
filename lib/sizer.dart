import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const double _baseWidth = 375;

Sizer useSizer(BuildContext context) {
  final MediaQueryData mediaQuery = MediaQuery.of(context);

  return useMemoized(() => Sizer(mediaQuery), <Object?>[
    mediaQuery.size,
    mediaQuery.orientation,
    mediaQuery.padding,
    mediaQuery.viewInsets,
  ]);
}

enum DeviceType {
  mobile,
  tablet,
  desktop;

  static DeviceType detect(double width) {
    if (kIsWeb) {
      return DeviceType.desktop;
    }

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return DeviceType.desktop;
    }

    if (width >= 600) {
      return DeviceType.tablet;
    }

    return DeviceType.mobile;
  }
}

class Sizer {
  final MediaQueryData query;

  late final Orientation orientation;
  late final DeviceType deviceType;

  late final double screenWidth;
  late final double screenHeight;

  late final double scale;

  Sizer(this.query) {
    screenWidth = query.size.width;
    screenHeight = query.size.height;

    orientation = query.orientation;
    deviceType = DeviceType.detect(screenWidth);
    scale = screenWidth / _baseWidth;
  }

  /// Scaled pixels (for padding, fonts, etc.)
  double sp(double value) => value * scale;

  /// Width percentage (0.0 - 1.0)
  double wp(double percent) => screenWidth * percent;

  /// Height percentage
  double hp(double percent) => screenHeight * percent;

  SizedBox box({double w = 0, double h = 0, Widget? child}) =>
      SizedBox(width: sp(w), height: sp(h), child: child);

  EdgeInsets insets({
    double? all,
    double? vertical,
    double? horizontal,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    if (all != null) {
      return EdgeInsets.all(sp(all));
    } else if (vertical != null || horizontal != null) {
      return EdgeInsets.symmetric(
        vertical: sp(vertical ?? 0),
        horizontal: sp(horizontal ?? 0),
      );
    } else {
      return EdgeInsets.only(
        left: sp(left),
        top: sp(top),
        right: sp(right),
        bottom: sp(bottom),
      );
    }
  }

  Padding padding({
    double? all,
    double? vertical,
    double? horizontal,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    Widget? child,
  }) => Padding(
    padding: insets(
      all: all,
      vertical: vertical,
      horizontal: horizontal,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: child,
  );
}
