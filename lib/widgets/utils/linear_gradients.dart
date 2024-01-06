import 'package:flutter/material.dart';

import '../../core/theme_data.dart';

class SimpleLinearGradient extends LinearGradient {
  SimpleLinearGradient(this.context)
      : super(
          colors: [
            Colors.transparent,
            MyAppTheme.isDark(context) ? Colors.black87 : Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.topCenter,
        );
  final BuildContext context;
}
