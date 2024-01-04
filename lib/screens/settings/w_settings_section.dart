import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoListSection;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_data.dart';

class SettingsSection extends ConsumerWidget {
  const SettingsSection({required this.title, required this.tiles, super.key});

  final String title;
  final List<Widget> tiles;

  Widget buildTileList() => ListView.builder(
        shrinkWrap: true,
        itemCount: tiles.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => tiles[index],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isCupertino(context)) {
      return CupertinoListSection.insetGrouped(
        header: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 15,
            bottom: 5 *
                MediaQuery.textScalerOf(context)
                    .scale(5), // TODO: Take a look at this
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // margin: const EdgeInsets.all(12),
        children: tiles,
      );
    }
    // final materialTheme = Theme.of(context);

    final tileList = buildTileList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: MediaQuery.textScalerOf(context).scale(24),
            bottom: MediaQuery.textScalerOf(context).scale(10),
            start: 24,
            end: 24,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: MyAppTheme.isDark(context, ref)
                  ? const Color(0xffd3e3fd)
                  : const Color(0xff0b57d0),
            ),
            child: Text(title),
          ),
        ),
        tileList,
      ],
    );
  }
}
