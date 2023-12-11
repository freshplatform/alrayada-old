import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_favorite.dart';
import '/screens/view_products/w_product_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  static const routeName = '/favorites';

  // TODO("Complete this")

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = AppLocalizations.of(context)!;
    final favoritesProvider =
        ref.read(FavoritesNotifier.favoritesProvider.notifier);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.favorites),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: favoritesProvider.loadAllFavoritesProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(Assets.lottie.loading1.path),
              );
            }
            return const _FavoritesList();
          },
        ),
      ),
    );
  }
}

class _FavoritesList extends ConsumerWidget {
  const _FavoritesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesProducts = ref.watch(FavoritesNotifier.favoritesProvider);
    return ProductsList(favoritesProducts);
  }
}
