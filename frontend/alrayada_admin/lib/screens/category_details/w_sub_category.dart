import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/server/server.dart';

import '../admin/widgets/categories/w_add_edit_category.dart';
import '../admin/widgets/categories/w_delete_category.dart';
import 's_category_details.dart';

class SubCategoryItem extends ConsumerWidget {
  const SubCategoryItem({
    super.key,
    required this.subCategory,
    required this.index,
    required this.parentCategory,
  });

  final ProductCategory subCategory;
  final ProductCategory parentCategory;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            CategoryDetailsScreen.routeName,
            arguments: subCategory,
          );
        },
        child: GridTile(
          header: GridTileBar(
            title: Text(
              subCategory.name,
              maxLines: 1,
            ),
            subtitle: Text(
              subCategory.shortDescription,
              maxLines: 1,
            ),
            leading: Tooltip(
              message: 'Edit',
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddEditCategoryDialog(
                      categoryToEdit: parentCategory,
                      subCategoryParentId: null,
                      parentCategoryOfTheSubCategory: subCategory,
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
                  showDialog(
                    context: context,
                    builder: (context) => DeleteCategoryDialog(
                      isSubCategory: true,
                      category: parentCategory,
                      subCategoryIndex: index,
                    ),
                  );
                },
              ),
            ),
            backgroundColor: Colors.black54,
          ),
          child: CachedNetworkImage(
            imageUrl:
                ServerConfigurations.getImageUrl(subCategory.imageUrls.first),
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
