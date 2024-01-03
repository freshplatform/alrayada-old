import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/p_settings.dart';

class OnlyMaterialHero extends ConsumerWidget {
  const OnlyMaterialHero({required this.tag, required this.child, super.key});
  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsData = ref.watch(SettingsNotifier.settingsProvider);
    if (isMaterial(context) &&
        settingsData.isAnimationsEnabled &&
        tag.trim().isNotEmpty) {
      return Hero(tag: tag, child: child);
    }
    return child;
  }
}
