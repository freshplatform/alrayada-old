import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';

import '../../gen/assets.gen.dart';
import '/core/locales.dart';
import '/screens/view_products/s_products.dart';
import '/services/image/s_image.dart';
import '/widgets/adaptive/others/w_only_material_hero.dart';
import '/widgets/w_image_slider_indicator.dart';
import 'w_sub_category_item.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({super.key});

  static const routeName = '/productsList';

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final category =
        ModalRoute.of(context)?.settings.arguments as ProductCategory;
    final translations = AppLocalizations.of(context)!;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          category.name,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(6),
          children: [
            const SizedBox(height: 2),
            SliderImageWithPageIndicator(
              itemCount: category.imageUrls.length,
              itemBuilder: (context, index, id) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: OnlyMaterialHero(
                    tag: (index == 0
                        ? 'categoryImage${category.id}'
                        : index.toString()),
                    child: Image(
                      // width: 350,
                      image: CachedNetworkImageProvider(
                        ImageService.getImageByImageServerRef(
                            category.imageUrls[index]),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              semanticsLabelWidget: translations.category,
              semanticsLabelSliderWidgets: translations.category_images,
            ),
            const SizedBox(height: 15),
            Text(
              category.description,
              maxLines: 15,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: isCupertino(context)
                  ? cupertinoTheme.textTheme.textStyle
                  : materialTheme.textTheme.bodyLarge,
            ),
            SizedBox(
              height: 400,
              child: _CategoriesOrOpenProducts(category),
            )
          ],
        ),
      ),
    );
  }
}

class _CategoriesOrOpenProducts extends StatelessWidget {
  const _CategoriesOrOpenProducts(this.category);
  final ProductCategory category;

  String get id => category.id;

  @override
  Widget build(BuildContext context) {
    final children = category.children;
    final translations = AppLocalizations.of(context)!;
    if (children == null) {
      return const Center(
        child: Text('Error from server side, please contact '
            'us with error message}'),
      );
    }
    if (children.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.lottie.onlineShopping1.path,
              fit: BoxFit.cover,
              width: 200,
            ),
            PlatformTextButton(
              child: Text(translations.open_products_list_page),
              onPressed: () => Navigator.of(context).pushNamed(
                ProductsScreen.routeName,
                arguments: category,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: children.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 15,
        mainAxisExtent: 220,
      ),
      itemBuilder: (context, index) {
        final category = children[index];
        return SubCategoryItem(category: category);
      },
    );
  }
}
