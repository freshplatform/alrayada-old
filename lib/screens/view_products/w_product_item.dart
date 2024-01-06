import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_data.dart';
import '../../cubits/p_product.dart';
import '../../data/product/m_product.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/w_price.dart';
import '../product_details/s_product_details.dart';
import '/services/image/s_image.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem(this._product, {super.key});

  final Product _product;

  bool isDiscount(Product product) => product.discountPercentage > 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final productProvider =
        ref.read(ProductItemNotifier.productItemProvider(_product).notifier);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        header: GridTileBar(
          title: const SizedBox.shrink(),
          trailing: !isDiscount(_product)
              ? const SizedBox.shrink()
              : Container(
                  padding: EdgeInsets.all(width >= 340 ? 6 : 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: MyAppTheme.isDark(context)
                        ? const Color(0XFF9E9E9E)
                        : Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    '${_product.discountPercentage}%${width >= 340 ? ' Off' : ''}',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    maxLines: null,
                    softWrap: true,
                    style: (isCupertino(context)
                        ? cupertinoTheme.textTheme.navTitleTextStyle
                        : materialTheme.textTheme.titleMedium),
                  ),
                ),
          leading: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: MyAppTheme.isDark(context)
                      ? Colors.black45
                      : Colors.black26,
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 14.0,
                  spreadRadius: 1.5,
                ),
              ],
            ),
            child: Consumer(
              builder: (context, ref, _) {
                final product = ref
                    .watch(ProductItemNotifier.productItemProvider(_product));
                return GestureDetector(
                  onTap: productProvider.toggleFavoriteItem,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: MyAppTheme.isDark(context)
                        ? Colors.black54
                        : Colors.white38,
                    child: Icon(
                      product.isFavorite
                          ? PlatformIcons(context).favoriteSolid
                          : PlatformIcons(context).favoriteOutline,
                      color: isCupertino(context)
                          ? cupertinoTheme.primaryColor
                          : materialTheme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(_product.name),
          subtitle: ProductPrice(
            originalPrice: _product.originalPrice,
            discountPercentage: _product.discountPercentage,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailsScreen.routeName, arguments: _product);
          },
          child: FadeInImage(
            // material hero tag 'productImage${product.id}'
            // alignment: Alignment.centerLeft,
            placeholder: AssetImage(Assets.images.productPlaceholder1.path),
            image: (_product.imageUrls.isNotEmpty
                ? CachedNetworkImageProvider(
                    ImageService.getImageByImageServerRef(
                        _product.imageUrls.first),
                  )
                : AssetImage(Assets.images.productPlaceholder1.path)
                    as ImageProvider),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
