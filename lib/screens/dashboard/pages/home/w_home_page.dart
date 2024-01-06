import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart'
    show
        Card,
        CircleAvatar,
        CircularProgressIndicator,
        FloatingActionButton,
        Icons,
        RefreshIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../cubits/auth/auth_cubit.dart';
import '../../../../cubits/p_offer.dart';
import '../../../../cubits/p_order.dart';
import '../../../../cubits/p_product.dart';
import '../../../../cubits/p_product_category.dart';
import '../../../../data/product/m_product.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/extensions/build_context.dart';
import '../../../view_products/s_products.dart';
import '/core/theme_data.dart';
import '/screens/category_details/s_category_details.dart';
import '/screens/dashboard/models/m_navigation_item.dart';
import '/screens/support/s_support.dart';
import '/screens/view_products/w_product_list.dart';
import '/services/image/s_image.dart';
import '/widgets/adaptive/w_icon.dart';
import '/widgets/no_data/w_no_data.dart';
import '/widgets/others/w_text_link.dart';
import '/widgets/others/w_text_section_indicator.dart';
import '/widgets/w_image_slider_indicator.dart';
import 'w_chart.dart';

class HomePage extends ConsumerStatefulWidget implements NavigationData {
  const HomePage({required this.navigate, super.key});
  final Function(int newIndex) navigate;

  @override
  NavigationItemData Function(
      BuildContext context, WidgetRef ref) get navigationItemData => (context,
          ref) {
        final translations = context.loc;
        return NavigationItemData(
          actions: [
            PlatformIconButton(
              material: (context, platform) => MaterialIconButtonData(
                tooltip: translations.support,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(SupportScreen.routeName),
              icon: const PlatformAdaptiveIcon(
                iconData: Icons.chat,
                cupertinoIconData: CupertinoIcons.chat_bubble_fill,
              ),
            ),
            PlatformIconButton(
              material: (context, platform) => MaterialIconButtonData(
                tooltip: translations.orders,
              ),
              onPressed: () =>
                  navigate(3), // TODO("Consider a solution for index changing")
              icon: const PlatformAdaptiveIcon(
                iconData: Icons.shopping_cart,
                cupertinoIconData: CupertinoIcons.square_stack_3d_down_right,
              ),
            ),
          ],
          materialFloatingActionButton: FloatingActionButton(
            tooltip: translations.support,
            onPressed: () =>
                Navigator.of(context).pushNamed(SupportScreen.routeName),
            child: const Icon(Icons.chat_bubble),
          ),
        );
      };

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void>? _loadStatisticsFuture;
  late Future<void> _loadOffersFuture;
  late Future<List<Product>> _loadBestSellingProductsFuture;
  late Future<List<Product>> _loadNewestProductsFuture;

  @override
  void initState() {
    super.initState();
    _initOthers();
  }

  Future<void> _initLoadStatisticsFuture() async {
    final authBloc = context.read<AuthCubit>();
    if (authBloc.state.userCredential != null &&
        _loadStatisticsFuture == null) {
      _loadStatisticsFuture =
          ref.read(OrdersNotifier.ordersProvider.notifier).loadStatistics();
      await _loadStatisticsFuture;
    }
  }

  Future<void> _initOthers() async {
    _loadOffersFuture =
        ref.read(OffersNotififer.offersProvider.notifier).loadOffers();
    final productsProvider =
        ref.read(ProductsNotifier.productsProvider.notifier);
    _loadBestSellingProductsFuture = productsProvider.getBestSelling();
    _loadNewestProductsFuture = productsProvider.getNewestProducts();
    await _loadOffersFuture;
    await _loadBestSellingProductsFuture;
    await _loadNewestProductsFuture;
  }

  Future<void> _refreshAll() async {
    await _initLoadStatisticsFuture();
    await _initOthers();
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    setState(() {});
  }

  Widget _buildLabelSection({
    required String text,
    VoidCallback? onClickMore,
    AppLocalizations? translations,
  }) =>
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ...textSectionIndicator(context),
            Text(
              text,
              style: MyAppTheme.getNormalTextStyle(context),
            ),
            if (onClickMore != null) ...[
              const Spacer(),
              TextLink(translations!.show_more, onTap: onClickMore),
            ]
          ],
        ),
      );

  Widget _buildStatistics(AppLocalizations translations) =>
      BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.userCredential != null) {
            _initLoadStatisticsFuture();
            return FutureBuilder(
              future: _loadStatisticsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
                // if (snapshot.hasError) {
                //   // TODO("Bug when the user is deleted and he still login")
                //   // Unhandled Exception: setState() or markNeedsBuild() called during build.
                //   // E/flutter (14547): This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
                //
                //   // simple workaround
                //   Future.delayed(Duration.zero).then(
                //     (value) => AdaptiveMessenger.showPlatformMessage(
                //       context: context,
                //       message: 'Please contact us with this error: 14547',
                //       title: translations.error,
                //     ),
                //   );
                //   if (kDebugMode) {
                //     print(snapshot.error);
                //   }
                // }
                return Consumer(
                  builder: (context, ref, _) {
                    final ordersContainer =
                        ref.watch(OrdersNotifier.ordersProvider);
                    return SizedBox(
                      height: 200,
                      child: ChartList(
                        monthlyTotals: ordersContainer.monthlyTotals,
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox(
            height: 200,
            child: ChartList(monthlyTotals: []),
          );
        },
      );

  Widget _buildCategories(AppLocalizations translations) => Consumer(
        builder: (context, ref, _) {
          final categories =
              ref.watch(ProductCategoriesNotififer.productCategoriesProvider);
          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabelSection(text: translations.categories),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemExtent: 90,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            CategoryDetailsScreen.routeName,
                            arguments: category),
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            ImageService.getImageByImageServerRef(
                              category.imageUrls.first,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      );

  Widget _buildOffers(AppLocalizations translations) => FutureBuilder(
        future: _loadOffersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final offers = ref.read(OffersNotififer.offersProvider);
          if (offers.isEmpty) {
            return const NoDataWithoutTryAgain();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabelSection(text: translations.offers_of_the_month),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SliderImageWithPageIndicator(
                  itemCount: offers.length,
                  itemBuilder: (context, index, id) {
                    if (offers.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final offer = offers[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: ImageService.getImageByImageServerRef(
                            offer.imageUrl),
                      ),
                    );
                  },
                  semanticsLabelWidget: translations.offers_of_the_month,
                  semanticsLabelSliderWidgets: translations.offers_pictures,
                ),
              ),
            ],
          );
        },
      );

  Widget _buildBestSellingProducts(AppLocalizations translations) =>
      FutureBuilder(
        future: _loadBestSellingProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.data?.isEmpty ?? true) {
            return const NoDataWithoutTryAgain();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabelSection(
                text: translations.best_selling_products,
                onClickMore: () => Navigator.of(context).pushNamed(
                    ProductsScreen.routeName,
                    arguments: snapshot.requireData),
                translations: translations,
              ),
              SizedBox(
                height: 220,
                child: ProductsGridList(snapshot.requireData.take(10).toList()),
              )
            ],
          );
        },
      );

  Widget _buildNewestProducts(AppLocalizations translations) => FutureBuilder(
        future: _loadNewestProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.data?.isEmpty ?? true) {
            return const NoDataWithoutTryAgain();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLabelSection(
                text: translations.newest_products,
                onClickMore: () => Navigator.of(context).pushNamed(
                    ProductsScreen.routeName,
                    arguments: snapshot.requireData),
                translations: translations,
              ),
              SizedBox(
                height: 220,
                child: ProductsGridList(snapshot.requireData.take(10).toList()),
              )
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return RefreshIndicator.adaptive(
      onRefresh: _refreshAll,
      child: Column(
        // padding: const EdgeInsets.all(12),
        children: [
          _buildStatistics(translations),
          _buildCategories(translations),
          const SizedBox(height: 20),
          _buildOffers(translations),
          const SizedBox(height: 20),
          _buildBestSellingProducts(translations),
          const SizedBox(height: 20),
          _buildNewestProducts(translations),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Lottie.asset(Assets.lottie.programming1.path),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
