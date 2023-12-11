import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/material.dart';

class AdaptiveIconButton extends StatelessWidget {
  const AdaptiveIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);
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
