import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_data.dart';

class SimpleLinearGradient extends LinearGradient {
  final BuildContext context;
  final WidgetRef ref;
  SimpleLinearGradient(this.context, this.ref)
      : super(
          colors: [
            Colors.transparent,
            MyAppTheme.isDark(context, ref) ? Colors.black87 : Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.topCenter,
        );
}
