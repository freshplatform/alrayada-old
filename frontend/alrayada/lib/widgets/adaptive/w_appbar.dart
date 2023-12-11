import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
