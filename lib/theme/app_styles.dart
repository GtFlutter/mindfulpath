import 'package:flutter/material.dart';

import '../helper/router.dart' show rootNavigator;

// import '../../routes/go_router_provider.dart';

enum Devices { mobile, tablet, largeTablet, smallMobile }

class AppStyle {
  AppStyle({Size? screenSize}) {
    // debugPrint("SCREEN SIZE :::: $screenSize");
    if (screenSize == null) {
      if (rootNavigator.currentContext != null) {
        screenSize = MediaQuery.of(rootNavigator.currentContext!).size;
      } else {
        scale = 1;
        return;
      }
    }
    final screenWidth = screenSize.width;
    if (screenWidth >= 250 && screenWidth <= 750) {
      scale = 1;
      devices = Devices.mobile;
    } else if (screenWidth >= 750 && screenWidth <= 950) {
      scale = 1.50;
      devices = Devices.tablet;
    } else if (screenWidth >= 950 && screenWidth <= 1200) {
      scale = 2;
      devices = Devices.largeTablet;
    } else {
      scale = 0.9;
      devices = Devices.smallMobile;
    }
  }
  late final double scale;

  /// Devices
  late final Devices devices;

  /// Text Style
  late final CommonTextStyle textStyle = CommonTextStyle(scale);

  /// Insets
  late final Insets insets = Insets(scale);

  /// Size
  late final CSize size = CSize(scale);

  /// Corners
  late final CommonCorners corners = CommonCorners(scale);

  /// Border Widths
  late final BordersWidth bordersWidth = BordersWidth(scale);

  /// Icon Size
  late final Common common = Common(scale);
}

class CommonTextStyle {
  const CommonTextStyle(this._scale);
  final double _scale;

  TextStyle commonFontStyle(
    TextStyle style, {
    Color? color,
    required double fontSize,
    double? height,
    double? letterSpacing,
    Paint? foreground,
  }) {
    fontSize *= _scale;

    if (height != null) {
      height *= _scale;
    }
    return style.copyWith(
        fontSize: fontSize,
        color: color,
        height: height != null ? (height / fontSize) : style.height,
        letterSpacing: letterSpacing != null ? fontSize * letterSpacing * 0.01 : style.letterSpacing,
        foreground: foreground);
  }
}

class Insets {
  Insets(this._scale);
  final double _scale;

  late final double xxxs = 4 * _scale;
  late final double xxs = 8 * _scale;
  late final double xs = 12 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 20 * _scale;
  late final double lg = 24 * _scale;
  late final double xl = 28 * _scale;
  late final double xxl = 32 * _scale;
  late final double xxxl = 56 * _scale;
}

class CSize {
  CSize(this._scale);
  final double _scale;
  Size commonSize({
    double? width,
    double? height,
  }) {
    if (width != null) {
      width *= _scale;
    }
    if (height != null) {
      height *= _scale;
    }
    return Size(width ?? 0, height ?? 0);
  }
}

class CommonCorners {
  CommonCorners(this._scale);
  final double _scale;

  late final double xxxs = 4 * _scale;
  late final double xxs = 8 * _scale;
  late final double xs = 12 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 20 * _scale;
  late final double lg = 24 * _scale;
  late final double xl = 28 * _scale;
  late final double xxl = 32 * _scale;
  late final double xxxl = 56 * _scale;
}

class BordersWidth {
  BordersWidth(this._scale);
  final double _scale;

  late final double sm = 1 * _scale;
  late final double md = 2 * _scale;
  late final double lg = 3 * _scale;
  late final double xl = 4 * _scale;
}

class Common {
  Common(this._scale);
  final double _scale;

  double size(double size) => size * _scale;
}
