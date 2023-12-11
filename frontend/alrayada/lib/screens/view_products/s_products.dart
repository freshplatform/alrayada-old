import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '/providers/p_product.dart';
import '/screens/view_products/w_product_list.dart';
import '/widgets/errors/w_error.dart';
import '../../widgets/no_data/w_no_data.dart';

enum _ProductsLoadType { productsList, byCategory }

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/products';

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  var _isFirstTime = true;
  late final dynamic _data;
  late final _ProductsLoadType _loadType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstTime) {
      _data = ModalRoute.of(context)!.settings.arguments!;
      if (_data is ProductCategory) {
        _loadType = _ProductsLoadType.byCategory;
      } else if (_data is List<Product>) {
        _loadType = _ProductsLoadType.productsList;
      } else {
        throw 'Unexpected error';
      }
    }
    _isFirstTime = false;
  }

  String get _appBarTitle {
    switch (_loadType) {
      case _ProductsLoadType.productsList:
        return (_data as List<Product>).length.toString();
      case _ProductsLoadType.byCategory:
        return (_data as ProductCategory).name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        ref.read(ProductsNotifier.productsProvider.notifier);
    final icons = PlatformIcons(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(_appBarTitle),
        trailingActions: [
          PlatformIconButton(
            onPressed: () => productsProvider.toggleShowOnlyFavorites(),
            icon: Consumer(
              builder: (context, ref, _) {
                final provider = ref.watch(ProductsNotifier.productsProvider);
                return Icon(
                  provider.showOnlyFavoritesProducts
                      ? icons.favoriteSolid
                      : icons.favoriteOutline,
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _ProductsScreenBody(
          data: _data,
          loadType: _loadType,
        ),
      ),
    );
  }
}

class _ProductsScreenBody extends ConsumerStatefulWidget {
  const _ProductsScreenBody(
      {Key? key, required this.data, required this.loadType})
      : super(key: key);
  final dynamic data;
  final _ProductsLoadType loadType;

  @override
  ConsumerState<_ProductsScreenBody> createState() =>
      _ProductsScreenBodyState();
}

class _ProductsScreenBodyState extends ConsumerState<_ProductsScreenBody> {
  Future<List<Product>>? loadProductsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.loadType == _ProductsLoadType.byCategory) {
      loadProductsFuture = ref
          .read(ProductsNotifier.productsProvider.notifier)
          .getProductsByCategory((widget.data as ProductCategory).id);
    }
  }

  void _refreshLoadProductsByCategory() => setState(() {
        loadProductsFuture = ref
            .read(ProductsNotifier.productsProvider.notifier)
            .getProductsByCategory((widget.data as ProductCategory).id);
      });

  Widget _buildProductsConsumer(List<Product> products) => Consumer(
        builder: (context, ref, _) {
          final provider = ref.watch(ProductsNotifier.productsProvider);
          final favoritesOnly =
              products.where((product) => product.isFavorite).toList();
          return ProductsList(
            provider.showOnlyFavoritesProducts ? favoritesOnly : products,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    if (widget.loadType == _ProductsLoadType.productsList) {
      return _buildProductsConsumer(widget.data!);
    }
    return FutureBuilder(
      future: loadProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          return ErrorWithTryAgain(onTryAgain: _refreshLoadProductsByCategory);
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return NoDataWithTryAgain(onRefresh: _refreshLoadProductsByCategory);
        }
        final products = snapshot.data!;
        return _buildProductsConsumer(products);
      },
    );
  }
}
