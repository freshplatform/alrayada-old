import 'package:cached_network_image/cached_network_image.dart';
import '/services/image/s_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';

import '../../gen/assets.gen.dart';
// import '../../widgets/utils/linear_gradients.dart';
import '../view_products/s_products.dart';

class SubCategoryItem extends StatelessWidget {
  const SubCategoryItem({Key? key, required this.category}) : super(key: key);
  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final imageProvider = (category.imageUrls.isNotEmpty
        ? CachedNetworkImageProvider(
            ImageService.getImageByImageServerRef(
              category.imageUrls.first,
            ),
          )
        : AssetImage(Assets.images.productPlaceholder1.path)) as ImageProvider;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          ProductsScreen.routeName,
          arguments: category,
        ),
        child: GridTile(
          header: Container(
            constraints: const BoxConstraints(
              minHeight: 30,
            ),
            color: Colors.black54,
            child: GridTileBar(
              title: Text(
                category.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(
                category.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          child: FadeInImage(
            image: imageProvider,
            fit: BoxFit.cover,
            placeholder: AssetImage(Assets.images.productPlaceholder1.path),
          ),
        ),
      ),
    );
  }
}
