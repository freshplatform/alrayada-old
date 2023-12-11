import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/material.dart';

class PlatformAdaptiveIcon extends StatelessWidget {
  const PlatformAdaptiveIcon({
    Key? key,
    required this.iconData,
    this.color,
    this.materialIconData,
    this.cupertinoIconData,
  }) : super(key: key);
  final IconData iconData;
  final Color? color;
  final IconData? materialIconData;
  final IconData? cupertinoIconData;

  IconData? _getPlatformIconData() => getPlatformIconData(
        iconData: iconData,
        materialIconData: materialIconData,
        cupertinoIconData: cupertinoIconData,
      );

  static IconData getPlatformIconData(
      {required IconData iconData,
      IconData? materialIconData,
      IconData? cupertinoIconData}) {
    if (PlatformChecker.isAppleProduct()) {
      return cupertinoIconData ?? iconData;
    }
    return materialIconData ?? iconData;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      (_getPlatformIconData() ?? iconData),
      color: color,
    );
  }
}
