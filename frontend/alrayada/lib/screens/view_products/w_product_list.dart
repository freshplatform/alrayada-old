import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '/widgets/no_data/w_no_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/locales.dart';
import 'w_product_item.dart';

class ProductsList extends StatefulWidget {
  const ProductsList(this.products, {Key? key}) : super(key: key);
  final List<Product> products;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  late final TextEditingController _searchController;
  var _reversed = false;

  List<Product> getProducts() {
    var allProducts = widget.products;
    if (_reversed) {
      allProducts = allProducts.reversed.toList();
    }
    final searchQuery = _searchController.text.trim().toLowerCase();
    if (searchQuery.isNotEmpty) {
      final filtered = allProducts.where((product) {
        final name = product.name.trim().toLowerCase();
        final description = product.description.trim().toLowerCase();
        final shortDescription = product.description.trim().toLowerCase();
        return name.contains(searchQuery) ||
            description.contains(searchQuery) ||
            shortDescription.contains(searchQuery);
      }).toList();
      return filtered;
    }
    return allProducts;
  }

  void onChanged(String value) => setState(() {});

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final products = getProducts();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: PlatformWidget(
                  cupertino: (context, platform) => CupertinoSearchTextField(
                    controller: _searchController,
                    onChanged: onChanged,
                  ),
                  material: (context, platform) => TextField(
                    controller: _searchController,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () =>
                                  setState(() => _searchController.text = ''),
                              icon: const Icon(Icons.clear),
                            ),
                      prefixIcon: const Icon(Icons.search),
                      labelText: translations.search,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              PlatformIconButton(
                onPressed: () => setState(() {
                  _reversed = !_reversed;
                }),
                icon:
                    Icon(_reversed ? Icons.filter_list_alt : Icons.filter_list),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: products.isEmpty
              ? const NoDataWithoutTryAgain()
              : ProductsGridList(products),
        ),
      ],
    );
  }
}

class ProductsGridList extends ConsumerWidget {
  const ProductsGridList(
    this.products, {
    Key? key,
  }) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 15,
        mainAxisExtent: 200,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(
          product,
          key: ValueKey(product.id + index.toString()),
        );
      },
    );
  }
}
