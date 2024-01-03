import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

enum RoundedButtonType { elevated, outlined }

class AdaptiveRoundedButton extends StatelessWidget {
  const AdaptiveRoundedButton({
    required this.child, super.key,
    this.type = RoundedButtonType.elevated,
    this.onPressed,
    this.borderRadius = 30,
  });
  final Widget child;
  final RoundedButtonType type;
  final VoidCallback? onPressed;
  final double borderRadius;

  bool get _isElevated => type == RoundedButtonType.elevated;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final shape = RoundedRectangleBorder(
      borderRadius: radius,
    );
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: _isElevated
          ? PlatformElevatedButton(
              onPressed: onPressed,
              material: (context, platform) => MaterialElevatedButtonData(
                style: ElevatedButton.styleFrom(shape: shape),
              ),
              cupertino: (context, platform) => CupertinoElevatedButtonData(
                borderRadius: radius,
              ),
              child: child,
            )
          : PlatformWidget(
              cupertino: (context, platform) => CupertinoButton(
                onPressed: onPressed,
                borderRadius: radius,
                child: child,
              ),
              material: (context, platform) => OutlinedButton(
                style: OutlinedButton.styleFrom(shape: shape),
                onPressed: onPressed,
                child: child,
              ),
            ),
    );
  }
}
