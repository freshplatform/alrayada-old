import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';

import '../../providers/p_product_category.dart';
import '../admin/widgets/categories/w_add_edit_category.dart';
import '../view_products/s_products.dart';
import 'w_sub_category.dart';

class CategoryDetailsScreen extends ConsumerStatefulWidget {
  const CategoryDetailsScreen({super.key});

  static const routeName = '/categoryDetails';

  @override
  ConsumerState<CategoryDetailsScreen> createState() =>
      _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends ConsumerState<CategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final parentCategory =
        ModalRoute.of(context)!.settings.arguments as ProductCategory;
    return Scaffold(
      appBar: AppBar(
        title: Text(parentCategory.name),
        actions: [
          Center(
            child: ElevatedButton(
              child: const Text('Add sub-category'),
              onPressed: () async {
                final success = await showDialog<bool>(
                      context: context,
                      builder: (context) => AddEditCategoryDialog(
                        categoryToEdit: null,
                        subCategoryParentId: parentCategory.id,
                        parentCategoryOfTheSubCategory: parentCategory,
                      ),
                    ) ??
                    false;
                if (success) {
                  setState(() {});
                }
              },
            ),
          )
        ],
      ),
      body: (parentCategory.children == null ||
              parentCategory.children!.isEmpty)
          ? Center(
              child: OutlinedButton(
              child: const Text('Open products page'),
              onPressed: () {
                Navigator.of(context).pushNamed(ProductsListScreen.routeName,
                    arguments: parentCategory);
              },
            ))
          : Consumer(
              builder: (context, ref, _) {
                final watchedCategory =
                    ref.watch(CategoryItemNotifier.provider(parentCategory));
                return GridView.builder(
                  itemCount: watchedCategory.children!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    final subCategory = watchedCategory.children![index];
                    return SubCategoryItem(
                      index: index,
                      subCategory: subCategory,
                      parentCategory: parentCategory,
                    );
                  },
                );
              },
            ),
    );
  }
}
