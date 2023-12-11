import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/m_product.dart';
import 'package:shared_alrayada/server/server.dart';

import '/core/locales.dart';
import 'w_add_update_button.dart';
import '/screens/product_details/w_wishlist_button.dart';
import '/services/image/s_image.dart';
import '/services/native/app_share/s_app_share.dart';
import '/widgets/adaptive/others/w_only_material_hero.dart';
import '/widgets/w_price.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/w_image_slider_indicator.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({Key? key, this.productData}) : super(key: key);

  static const routeName = '/productDetails';

  final Product? productData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final product =
        (ModalRoute.of(context)?.settings.arguments ?? productData) as Product;
    final translations = AppLocalizations.of(context)!;
    final actions = [
      PlatformIconButton(
        icon: const Icon(Icons.share),
        onPressed: () {
          final url =
              '${ServerConfigurations.productionBaseUrl}products/${product.id}';
          AppShareService.instance.shareText(url, product.name);
        },
      ),
    ];
    final actionsBox = SizedBox(
      height: isMaterial(context) ? 65 : 85,
      width: double.infinity,
      child: Card(
        color: isCupertino(context) ? cupertinoTheme.barBackgroundColor : null,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WishlistProductButton(product: product),
            AddUpdateProductToCartButton(product: product),
          ],
        ),
      ),
    );
    final detailsWidgets = SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMaterial(context)) // we already have it in sliver appbar
              Text(
                product.name,
                style: isMaterial(context)
                    ? materialTheme.textTheme.titleLarge
                    : cupertinoTheme.textTheme.navTitleTextStyle,
              ),
            ProductPrice(
              originalPrice: product.originalPrice,
              discountPercentage: product.discountPercentage,
              textAlign: TextAlign.start,
              textScaleFactor: 1.5,
              haveGradient: false,
            ),
            const SizedBox(height: 20),
            if (product.description.trim().isNotEmpty) ...[
              Text(
                translations.description,
                style: isMaterial(context)
                    ? materialTheme.textTheme.titleLarge
                    : cupertinoTheme.textTheme.pickerTextStyle,
              ),
              Text(
                product.description,
                style: isMaterial(context)
                    ? materialTheme.textTheme.bodySmall
                    : cupertinoTheme.textTheme.textStyle,
              ),
            ],
            const SizedBox(height: 20),
            if (product.shortDescription.trim().isNotEmpty) ...[
              Text(
                translations.short_description,
                style: isMaterial(context)
                    ? materialTheme.textTheme.titleLarge
                    : cupertinoTheme.textTheme.pickerTextStyle,
              ),
              Text(
                product.shortDescription,
                style: isMaterial(context)
                    ? materialTheme.textTheme.bodySmall
                    : cupertinoTheme.textTheme.textStyle,
              ),
            ],
            const SizedBox(height: 800),
          ],
        ),
      ),
    );
    if (isMaterial(context)) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              actions: actions,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.name),
                background: OnlyMaterialHero(
                  tag: 'productImage${product.id}',
                  child: Image(
                    semanticLabel: product.shortDescription,
                    image: (product.imageUrls.isNotEmpty
                            ? CachedNetworkImageProvider(
                                ImageService.getImageByImageServerRef(
                                    product.imageUrls.first),
                              )
                            : AssetImage(
                                Assets.images.productPlaceholder1.path))
                        as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 8),
                  detailsWidgets,
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: actionsBox,
      );
    }
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(product.name),
        trailingActions: actions,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    SliderImageWithPageIndicator(
                      itemCount: product.imageUrls.length,
                      autoPlay: false,
                      itemBuilder: (context, index, id) => Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: OnlyMaterialHero(
                          tag: index == 0
                              ? 'productImage${product.id}'
                              : id.toString(),
                          child: Image(
                            semanticLabel: product.shortDescription,
                            image: product.imageUrls.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    ImageService.getImageByImageServerRef(
                                      product.imageUrls[index],
                                    ),
                                  )
                                : AssetImage(
                                        Assets.images.productPlaceholder1.path)
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      semanticsLabelWidget: translations.product,
                      semanticsLabelSliderWidgets: translations.product_images,
                    ),
                    const SizedBox(height: 10),
                    detailsWidgets,
                  ],
                ),
              ),
            ),
            actionsBox,
          ],
        ),
      ),
    );
  }
}
