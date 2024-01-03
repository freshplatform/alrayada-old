import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AdaptiveOutlinedButton extends StatelessWidget {
  const AdaptiveOutlinedButton({
    required this.onPressed, required this.child, super.key,
  });
  final VoidCallback onPressed;
  final Widget child;

  Widget _buildMaterialButton() => OutlinedButton(
        onPressed: onPressed,
        child: child,
      );

  Widget _buildCupertinoButton() => Container(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: 10,
          right: 10,
        ),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.systemGrey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: CupertinoButton(
          onPressed: onPressed,
          borderRadius: BorderRadius.circular(25),
          padding: EdgeInsets.zero,
          minSize: 40,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return _buildCupertinoButton();
    }
    return _buildMaterialButton();
  }
}
