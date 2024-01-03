import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    show isCupertino;

List<Widget> textSectionIndicator(BuildContext context) => [
      Text(
        '|',
        style: TextStyle(
          color: isCupertino(context)
              ? CupertinoColors.destructiveRed
              : Colors.red,
          fontSize: 18,
        ),
      ),
      const SizedBox(width: 4),
    ];
