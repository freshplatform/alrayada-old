import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/platform_checker.dart';

enum MaterialButtonType { elevated, outlined }

class MaterialButtonOptions {
  final MaterialButtonType? type;
  final ButtonStyle? style;

  MaterialButtonOptions({
    this.type = MaterialButtonType.elevated,
    this.style,
  });
}

enum CupertinoButtonType { normal, noBackground }

class CupertinoButtonOptions {
  final CupertinoButtonType type;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final Color disabledColor;
  final double? minSize;
  final double? pressedOpacity;

  CupertinoButtonOptions({
    this.backgroundColor,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.padding,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize,
    this.pressedOpacity = 0.4,
    this.type = CupertinoButtonType.noBackground,
  });
}

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.materialOptions,
    this.cupertinoOptions,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final MaterialButtonOptions? materialOptions;
  final CupertinoButtonOptions? cupertinoOptions;

  @override
  Widget build(BuildContext context) {
    return PlatformChecker.isAppleProduct()
        ? _buildCupertinoButton()
        : _buildMaterialButton();
  }

  Widget _buildCupertinoButton() {
    if (cupertinoOptions != null &&
        cupertinoOptions!.type == CupertinoButtonType.normal) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        borderRadius: cupertinoOptions?.borderRadius,
        alignment: (cupertinoOptions?.alignment) ?? Alignment.center,
        padding: cupertinoOptions?.padding,
        disabledColor: (cupertinoOptions?.disabledColor) ??
            CupertinoColors.quaternarySystemFill,
        // minSize: cupertinoOptions?.minSize,
        pressedOpacity: cupertinoOptions?.pressedOpacity,
        child: child,
      );
    }
    return CupertinoButton(
      onPressed: onPressed,
      color: cupertinoOptions?.backgroundColor,
      borderRadius: cupertinoOptions?.borderRadius,
      alignment: (cupertinoOptions?.alignment) ?? Alignment.center,
      padding: cupertinoOptions?.padding,
      disabledColor: (cupertinoOptions?.disabledColor) ??
          CupertinoColors.quaternarySystemFill,
      // minSize: cupertinoOptions?.minSize,
      pressedOpacity: cupertinoOptions?.pressedOpacity,
      child: child,
    );
  }

  Widget _buildMaterialButton() {
    if (materialOptions != null &&
        materialOptions!.type == MaterialButtonType.outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: materialOptions?.style,
        child: child,
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: materialOptions?.style,
      child: child,
    );
  }
}
