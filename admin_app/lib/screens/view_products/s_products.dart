import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';

import '../../providers/p_product.dart';
import 'w_add_edit_product.dart';
import 'w_product_item.dart';

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({super.key});

  static const routeName = '/productsList';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category =
        ModalRoute.of(context)?.settings.arguments as ProductCategory;
    final provider = ref.read(ProductsNotifier.provider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products of ${category.name}'),
        actions: [
          Center(
            child: OutlinedButton(
              child: const Text('Add product'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddEditProduct(
                    category: category,
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: provider.getProductsByCategory(category.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Consumer(
            builder: (context, ref, _) {
              final products = ref.watch(ProductsNotifier.provider);
              return GridView.builder(
                itemCount: products.length,
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItem(
                    index: index,
                    category: category,
                    unWatchedProduct: product,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
