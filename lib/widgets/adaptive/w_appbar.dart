import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/platform_checker.dart';

PreferredSizeWidget adaptiveAppBar({
  required BuildContext context,
  Widget? title,
  List<Widget>? actions,
}) {
  return PlatformChecker.isAppleProduct()
      ? CupertinoNavigationBar(
          middle: title,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions ?? [],
          ),
        )
      : AppBar(
          title: title,
          actions: actions,
        ) as PreferredSizeWidget;
}
