import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TextLink extends StatelessWidget {
  const TextLink(this.text, {required this.onTap, super.key});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    return PlatformTextButton(
      onPressed: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isCupertino(context)
            ? cupertinoTheme.textTheme.actionTextStyle
            : const TextStyle(
                color: Colors.blue,
              ),
      ),
    );
  }
}
