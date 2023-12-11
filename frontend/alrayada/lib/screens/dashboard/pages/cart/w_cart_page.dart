import 'package:alrayada/providers/p_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/shared_alrayada.dart';

import '../../../product_details/w_add_update_button.dart';
import '/core/locales.dart';
import '/providers/p_cart.dart';
import '/providers/p_settings.dart';
import '/screens/dashboard/models/m_navigation_item.dart';
import '/screens/dashboard/pages/cart/checkout/w_cart_checkout.dart';
import '/screens/product_details/s_product_details.dart';
import '/screens/product_details/w_add_to_cart.dart';
import '/services/image/s_image.dart';
import '/widgets/adaptive/messenger.dart';
import '/widgets/errors/w_error.dart';
import '/widgets/no_data/w_no_data.dart';
import '/widgets/w_price.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../widgets/errors/w_internet_error.dart';
import 'w_confirm_delete.dart';

class CartPage extends ConsumerStatefulWidget implements NavigationData {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CartPage> createState() => _CartPageState();

  @override
  NavigationItemData Function(BuildContext context, WidgetRef ref)
      get navigationItemData => (context, ref) {
            final translations = AppLocalizations.of(context)!;
            return NavigationItemData(
              actions: [
                PlatformIconButton(
                  icon: Icon(PlatformIcons(context).clear),
                  material: (context, platform) => MaterialIconButtonData(
                    tooltip: translations.clear,
                  ),
                  onPressed: () =>
                      ref.read(CartNotifier.cartProvider.notifier).clearCart(),
                )
              ],
              materialFloatingActionButton:
                  Consumer(builder: (context, ref, _) {
                final cartItems = ref.watch(CartNotifier.cartProvider);
                final cartProvider =
                    ref.read(CartNotifier.cartProvider.notifier);
                if (cartItems.isEmpty) {
                  return const SizedBox.shrink();
                }
                return FloatingActionButton(
                  tooltip: translations.delete,
                  onPressed: () => cartProvider.clearCart(),
                  child: const Icon(Icons.delete),
                );
              }),
            );
          };
}

class _CartPageState extends ConsumerState<CartPage>
    with AutomaticKeepAliveClientMixin {
  late Future? _loadCartFuture;

  @override
  void initState() {
    super.initState();
    _loadCartFuture =
        ref.read(CartNotifier.cartProvider.notifier).loadAllCartItems();
  }

  // Important (The setState() method on _CartPageState#ba3dd was called with a closure or method that returned a Future. Maybe it is marked as "async".)
  // Instead of performing asynchronous work inside a call to setState(), first execute the work (without updating the widget state), and then synchronously update the state inside a call to setState().
  void _refresh() => setState(() {
        _loadCartFuture =
            ref.read(CartNotifier.cartProvider.notifier).loadAllCartItems();
      });

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final translations = AppLocalizations.of(context)!;
    final userContainer = ref.watch(UserNotifier.provider);
    final userProvider = ref.read(UserNotifier.provider.notifier);
    return FutureBuilder<void>(
      future: _loadCartFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          if (snapshot.error is DioException) {
            final dioException = (snapshot.error as DioException);
            if (dioException.type == DioExceptionType.connectionError) {
              return InternetErrorWithTryAgain(onTryAgain: _refresh);
            }
          }
          return ErrorWithTryAgain(onTryAgain: _refresh);
        }
        return Consumer(
          builder: (context, ref, child) {
            final cartItems = ref.watch(CartNotifier.cartProvider);
            if (cartItems.isEmpty) {
              return const NoDataWithoutTryAgain();
            }
            final total = cartItems.fold(
              0.0,
              (previousValue, cartItemData) =>
                  previousValue +
                  cartItemData.product.salePrice * cartItemData.cart.quantity,
            );
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            translations.order_total,
                            style: isMaterial(context)
                                ? materialTheme.textTheme.bodySmall
                                : cupertinoTheme.textTheme.tabLabelTextStyle
                                    .copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${(total).round().toStringAsFixed(2).replaceFirst('.00', '')}\$',
                            style: isMaterial(context)
                                ? materialTheme.textTheme.titleLarge
                                : cupertinoTheme.textTheme.navTitleTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      PlatformElevatedButton(
                        onPressed: () async {
                          await userProvider.loadSavedUser();
                          if (userContainer == null) {
                            Future.microtask(() {
                              AdaptiveMessenger.showPlatformMessage(
                                context: context,
                                message: translations.you_need_to_login_first,
                                title: translations.not_authenticated,
                              );
                            });
                            return;
                          }
                          if (!userContainer.user.accountActivated) {
                            Future.microtask(() {
                              AdaptiveMessenger.showPlatformMessage(
                                context: context,
                                message: translations
                                    .your_account_need_to_be_activated,
                                title: translations.not_activated,
                              );
                            });
                            return;
                          }
                          Future.microtask(
                            () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const CheckoutModalDialog(),
                            ),
                          );
                        },
                        cupertino: (context, platform) =>
                            CupertinoElevatedButtonData(
                          padding: const EdgeInsets.all(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PlatformIcons(context).shoppingCart,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              translations.checkout,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      final cartItem = cartItems[index];
                      return Column(
                        children: [
                          CartItemWidget(cartItem),
                          const Divider(),
                        ],
                      );
                    },
                    // padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CartItemWidget extends ConsumerWidget {
  const CartItemWidget(this.cartItem, {Key? key}) : super(key: key);

  final CartItemData cartItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProvider = ref.read(CartNotifier.cartProvider.notifier);
    return Dismissible(
      background: Container(
        alignment: Alignment.center, // TODO("Maybe it will change")
        padding: const EdgeInsets.only(right: 20),
        color:
            isCupertino(context) ? CupertinoColors.destructiveRed : Colors.red,
        child: Icon(PlatformIcons(context).delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog<bool>(
        context: context,
        builder: (context) => const ConfirmDeleteCartItemDialog(),
      ),
      onDismissed: (direction) => cartProvider.removeFromCart(cartItem),
      key: ValueKey<String>(cartItem.cart.productId),
      child: PlatformListTile(
        title: Text(
          cartItem.product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: cartItem.product),
          child: Image(
            height: 100,
            width: 80,
            image: cartItem.product.imageUrls.isNotEmpty
                ? CachedNetworkImageProvider(
                    ImageService.getImageByImageServerRef(
                        cartItem.product.imageUrls.first))
                : AssetImage(Assets.images.productPlaceholder1.path)
                    as ImageProvider,
          ),
        ),
        onTap: () => true
            ? AddUpdateProductToCartButton.showEditUpdate(
                context: context,
                product: cartItem.product,
                cart: cartItem.cart,
              )
            : showPlatformModalSheet<void>(
                context: context,
                cupertino: CupertinoModalSheetData(
                  barrierColor: Colors.black38,
                ),
                material: MaterialModalSheetData(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  barrierColor: Colors.black38,
                ),
                builder: (context) =>
                    AddUpdateProductToCart(cartItem.cart, cartItem.product),
              ),
        subtitle: Wrap(
          // TODO("Should it changed to Row?")
          children: [
            ProductPrice(
              discountPercentage: cartItem.product.discountPercentage,
              originalPrice: cartItem.product.originalPrice,
              textAlign: TextAlign.start,
              haveGradient: false,
            ),
            Text(
              ' * ${cartItem.cart.quantity}',
            )
          ],
        ),
        trailing: PlatformIconButton(
          onPressed: () async {
            final settingsData = ref.read(SettingsNotifier.settingsProvider);
            if (settingsData.confirmDeleteCartItem) {
              final value = await showDialog<bool>(
                    context: context,
                    builder: (context) => const ConfirmDeleteCartItemDialog(),
                  ) ??
                  false;
              if (!value) {
                return;
              }
            }
            cartProvider.removeFromCart(cartItem);
          },
          icon: Icon(
            PlatformIcons(context).delete,
            color: const Color(0xffd32f2f),
          ),
        ),
      ),
    );
  }
}
