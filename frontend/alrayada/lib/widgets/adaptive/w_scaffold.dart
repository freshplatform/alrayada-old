import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    Key? key,
    required this.body,
    required this.appBar,
  }) : super(key: key);
  final Widget body;
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return PlatformChecker.isAppleProduct()
        ? CupertinoPageScaffold(
            navigationBar: appBar as CupertinoNavigationBar,
            child: SafeArea(
              child: body,
            ),
          )
        : Scaffold(
            body: body,
            appBar: appBar as AppBar,
          );
  }
}
