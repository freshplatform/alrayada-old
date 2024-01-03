import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/server/server.dart';

import '../../../../providers/p_product_category.dart';
import '../../../category_details/s_category_details.dart';
import 'w_add_edit_category.dart';
import 'w_delete_category.dart';

class CategoryItem extends ConsumerWidget {
  const CategoryItem({
    required this.index, required this.unWatchedCategory, super.key,
  });

  final int index;
  final ProductCategory unWatchedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(
      CategoryItemNotifier.provider(unWatchedCategory),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(CategoryDetailsScreen.routeName, arguments: category),
        child: GridTile(
          header: GridTileBar(
            title: Text(
              category.name,
              maxLines: 1,
            ),
            subtitle: Text(
              category.shortDescription,
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
                      categoryToEdit: category,
                      subCategoryParentId: null,
                      parentCategoryOfTheSubCategory: category,
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
                      isSubCategory: false,
                      category: category,
                    ),
                  );
                },
              ),
            ),
            backgroundColor: Colors.black54,
          ),
          child: CachedNetworkImage(
            imageUrl:
                ServerConfigurations.getImageUrl(category.imageUrls.first),
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
