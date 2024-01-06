import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../cubits/settings/settings_cubit.dart';

class OnlyMaterialHero extends StatelessWidget {
  const OnlyMaterialHero({
    required this.tag,
    required this.child,
    super.key,
  });
  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isAnimationsEnabled =
        context.read<SettingsCubit>().state.isAnimationsEnabled;
    if (isMaterial(context) && isAnimationsEnabled && tag.trim().isNotEmpty) {
      return Hero(tag: tag, child: child);
    }
    return child;
  }
}
