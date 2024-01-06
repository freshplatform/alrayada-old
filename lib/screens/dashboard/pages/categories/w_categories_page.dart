import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cubits/p_product_category.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../widgets/w_image_card.dart';
import '/screens/category_details/s_category_details.dart';
import '/screens/dashboard/models/m_navigation_item.dart';
import '/services/image/s_image.dart';
import '/widgets/errors/w_error.dart';
import '/widgets/errors/w_internet_error.dart';
import '/widgets/no_data/w_no_data.dart';

class CategoriesPage extends ConsumerStatefulWidget implements NavigationData {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();

  @override
  NavigationItemData Function(BuildContext context, WidgetRef ref)
      get navigationItemData => (context, ref) {
            return const NavigationItemData(actions: []);
          };
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  late Future<void> _loadCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategoriesFuture = ref
        .read(ProductCategoriesNotififer.productCategoriesProvider.notifier)
        .getProductCategories();
  }

  void _refresh() => setState(() {
        _loadCategoriesFuture = ref
            .read(ProductCategoriesNotififer.productCategoriesProvider.notifier)
            .getProductCategories();
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadCategoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          if (kDebugMode) {
            print('Load Categories Error = ${snapshot.error.toString()}');
          }
          if (snapshot.error is DioException) {
            final dioException = snapshot.error as DioException;
            if (dioException.type == DioExceptionType.connectionError) {
              return InternetErrorWithTryAgain(onTryAgain: _refresh);
            }
          }
          return ErrorWithTryAgain(onTryAgain: _refresh);
        }
        return Consumer(builder: (context, ref, _) {
          final categories =
              ref.watch(ProductCategoriesNotififer.productCategoriesProvider);
          if (categories.isEmpty) {
            return NoDataWithTryAgain(onRefresh: _refresh);
          }
          return GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final imageProvider = (category.imageUrls.isNotEmpty
                      ? CachedNetworkImageProvider(
                          ImageService.getImageByImageServerRef(
                              category.imageUrls.first),
                        )
                      : AssetImage(Assets.images.productPlaceholder1.path))
                  as ImageProvider;
              return ImageCard(
                imageProvider: imageProvider,
                heroTag: 'categoryImage${category.id}',
                title: category.name,
                onTap: () => Navigator.pushNamed(
                    context, CategoryDetailsScreen.routeName,
                    arguments: category),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          );
        });
      },
    );
  }
}
