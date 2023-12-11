import 'package:alrayada_admin/providers/p_product_category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alrayada_admin/screens/admin/widgets/categories/w_add_edit_category.dart';
import 'package:alrayada_admin/screens/admin/widgets/categories/w_delete_category.dart';
import 'package:alrayada_admin/screens/category_details/s_category_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/server/server.dart';
import 'package:flutter/material.dart';

class CategoryItem extends ConsumerWidget {
  const CategoryItem({
    super.key,
    required this.index,
    required this.unWatchedCategory,
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
