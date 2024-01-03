import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// @Deprecated("Use material Badge() instead")
class CustomBadge extends StatelessWidget {
  const CustomBadge({
    required this.child, required this.value, super.key,
    this.color,
  });

  final Widget child;
  final String value;
  final Color? color;

  static Badge count({
    required int count,
    required Widget child,
    required BuildContext context,
  }) =>
      Badge.count(
        count: count,
        backgroundColor:
            isCupertino(context) ? CupertinoColors.systemRed : null,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code
    final container = Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ??
            (isCupertino(context)
                ? CupertinoColors.systemRed
                : Theme.of(context).colorScheme.secondary),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          // top: 16,
          bottom: 16,
          left: 12,
          child: container,
        )
      ],
    );
  }
}
