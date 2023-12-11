import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_data.dart';

class AdaptiveCard extends ConsumerWidget {
  const AdaptiveCard({
    Key? key,
    this.margin,
    required this.child,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      material: (context, platform) => Card(
        margin: margin,
        child: child,
      ),
      cupertino: (context, platform) => Container(
        margin: margin,
        decoration: BoxDecoration(
          color: MyAppTheme.isDark(context, ref)
              ? CupertinoColors.tertiaryLabel
              : CupertinoColors.tertiarySystemGroupedBackground,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.2),
              blurRadius: 4.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
