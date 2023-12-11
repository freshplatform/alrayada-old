import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme_data.dart';
import '/widgets/adaptive/others/w_only_material_hero.dart';
import '/widgets/utils/linear_gradients.dart';

class ImageCard extends ConsumerWidget {
  const ImageCard({
    Key? key,
    required this.imageProvider,
    this.contentDescription,
    required this.title,
    this.height = 200,
    this.gradientPercentage = 0.25,
    this.onTap,
    this.heroTag = '',
    this.howeverEffect = true,
    this.legacy = false,
  }) : super(key: key);
  final ImageProvider imageProvider;
  final String? contentDescription;
  final String title;
  final double height;
  final double gradientPercentage;
  final GestureTapCallback? onTap;
  final String heroTag;
  final bool howeverEffect;
  final bool legacy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    if (legacy) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: MyAppTheme.getAppMaterialTheme(context, ref),
          child: Card(
            color:
                isCupertino(context) ? cupertinoTheme.barBackgroundColor : null,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  // keep it Ink.image to work
                  child: OnlyMaterialHero(
                    tag: heroTag,
                    child: Material(
                      child: Ink.image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: onTap,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // opacity: AppThemeData.isDark() ? 0.95 : 0.6,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      gradient: SimpleLinearGradient(context, ref),
                    ),
                    height: height * gradientPercentage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: isMaterial(context)
                          ? materialTheme.textTheme.titleMedium
                          : cupertinoTheme.textTheme.textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: GridTile(
          footer: GridTileBar(
            // decoration:
            //     BoxDecoration(gradient: SimpleLinearGradient(context)),
            title: Text(title),
            backgroundColor: Colors.black54,
          ),
          child: Builder(
            builder: (context) {
              if (howeverEffect) {
                return OnlyMaterialHero(
                  tag: heroTag,
                  child: Material(
                    child: Ink.image(
                      fit: BoxFit.cover,
                      image: imageProvider,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onTap,
                      ),
                    ),
                  ),
                );
              }
              return GestureDetector(
                onTap: onTap,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
