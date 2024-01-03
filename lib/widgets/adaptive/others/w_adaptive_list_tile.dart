import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MaterialListTileData {

  MaterialListTileData({
    this.shape,
  });
  final ShapeBorder? shape;
}

class CupertinoListTileData {

  CupertinoListTileData({
    this.leadingSize = _kLeadingSize,
  });
  final double leadingSize;

  static const double _kLeadingSize = 28.0;
}

class AdaptiveListTile extends StatelessWidget {
  const AdaptiveListTile({
    required this.title, super.key,
    this.trailing,
    this.leading,
    this.subtitle,
    this.onTap,
    this.material,
    this.cupertino,
  });
  final Widget title;
  final Widget? trailing;
  final Widget? leading;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final MaterialListTileData? material;
  final CupertinoListTileData? cupertino;

  @override
  Widget build(BuildContext context) {
    return isCupertino(context)
        ? CupertinoListTile(
            title: title,
            trailing: trailing,
            leading: leading,
            subtitle: subtitle,
            onTap: onTap,
            leadingSize:
                cupertino?.leadingSize ?? CupertinoListTileData._kLeadingSize,
          )
        : ListTile(
            title: title,
            trailing: trailing,
            leading: leading,
            subtitle: subtitle,
            onTap: onTap,
            shape: material?.shape,
          );
  }
}
