import 'package:flutter/material.dart';

import '../../utils/platform_checker.dart';

class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    required this.icon, super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return PlatformChecker.isAppleProduct()
        ? GestureDetector(
            onTap: onPressed,
            child: icon,
          )
        : IconButton(
            onPressed: onPressed,
            icon: icon,
          );
  }
}
