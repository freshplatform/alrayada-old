import 'package:flutter/material.dart';
import 'package:alrayada_admin/providers/p_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alrayada_admin/screens/view_products/w_add_edit_product.dart';
import 'package:alrayada_admin/widgets/w_product_price.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '../../gen/assets.gen.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem({
    super.key,
    required this.index,
    required this.category,
    required this.unWatchedProduct,
  });

  final int index;
  final ProductCategory category;
  final Product unWatchedProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(ProductItemNotifier.provider(unWatchedProduct));
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: ProductPrice(
          discountPercentage: product.discountPercentage,
          originalPrice: product.originalPrice,
        ),
      ),
      header: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(product.name),
        subtitle: Text(product.shortDescription),
        leading: Tooltip(
          message: 'Edit',
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddEditProduct(
                  category: category,
                  product: product,
                ),
              );
            },
          ),
        ),
        trailing: Tooltip(
          message: 'Delete',
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref
                  .read(ProductsNotifier.provider.notifier)
                  .deleteProduct(product.id, index);
            },
          ),
        ),
      ),
      child: product.imageUrls.isEmpty
          ? Assets.images.appLogo.image()
          : CachedNetworkImage(
              imageUrl: product.imageUrls.first,
              fit: BoxFit.cover,
            ),
    );
  }
}
