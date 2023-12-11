import 'package:alrayada_admin/providers/p_product_category.dart';
import 'package:alrayada_admin/screens/admin/widgets/categories/w_add_edit_category.dart';
import 'package:alrayada_admin/screens/admin/widgets/categories/w_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  Widget get content => Consumer(
        builder: (context, ref, _) {
          final categories = ref.watch(CategoriesNotififer.provider);
          return GridView.builder(
            itemCount: categories.length,
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItem(
                index: index,
                unWatchedCategory: category,
              );
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = ref.read(CategoriesNotififer.provider.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Categories'),
        leading: Tooltip(
          message: 'Add category',
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddEditCategoryDialog(
                  categoryToEdit: null,
                  subCategoryParentId: null,
                ),
              );
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: provider.fetchProductCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }
          return content;
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
