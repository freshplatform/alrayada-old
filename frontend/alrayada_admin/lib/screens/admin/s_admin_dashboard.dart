import 'package:flutter/material.dart';

import 'widgets/account/p_account.dart';
import 'widgets/categories/p_categories.dart';
import 'widgets/chat_rooms/p_chat_list.dart';
import 'widgets/offers/p_offers.dart';
import 'widgets/orders/p_orders.dart';
import 'widgets/products/p_products.dart';
import 'widgets/sub_categories/p_sub_categories.dart';
import 'widgets/users/p_users.dart';

@immutable
class NavigationItem {
  final Widget body;
  final IconData iconData;
  final String label;

  const NavigationItem({
    required this.body,
    required this.iconData,
    required this.label,
  });

  NavigationDestination toDestination() => NavigationDestination(
        icon: Icon(iconData),
        label: label,
      );

  NavigationRailDestination toRailDestination() => NavigationRailDestination(
        icon: Icon(iconData),
        label: Text(label),
      );
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  static const routeName = '/adminDashboard';

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  var _currentIndex = 0;
  final _pageController = PageController();

  final List<NavigationItem> _items = [
    const NavigationItem(
      iconData: Icons.person,
      label: 'Users',
      body: UserPage(key: PageStorageKey('Users')),
    ),
    const NavigationItem(
      iconData: Icons.folder,
      label: 'Categories',
      body: CategoriesPage(key: PageStorageKey('Categories')),
    ),
    const NavigationItem(
      iconData: Icons.shopping_cart,
      label: 'Orders',
      body: OrdersPage(key: PageStorageKey('Orders')),
    ),
    const NavigationItem(
      iconData: Icons.chat,
      label: 'Chat',
      body: ChatRoomsListPage(key: PageStorageKey('Chat')),
    ),
    const NavigationItem(
      iconData: Icons.attach_money,
      label: 'Offers',
      body: OffersPage(key: PageStorageKey('Offers')),
    ),
    const NavigationItem(
      iconData: Icons.category,
      label: 'Sub categories',
      body: SubCategoriesPage(key: PageStorageKey('Sub-Categories')),
    ),
    const NavigationItem(
      iconData: Icons.list,
      label: 'Products',
      body: ProductsPage(key: PageStorageKey('Products')),
    ),
    const NavigationItem(
      iconData: Icons.account_box,
      label: 'Account',
      body: AccountPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: (newIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
              _pageController.jumpToPage(newIndex);
            },
            destinations: _items
                .map(
                  (e) => e.toRailDestination(),
                )
                .toList(),
            selectedIndex: _currentIndex,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _items.map((e) => e.body).toList(),
              onPageChanged: (newIndex) {
                setState(() {
                  _currentIndex = newIndex;
                });
              },
            ),
          )
        ],
      ),
    );
    // header: Assets.images.appLogo.image(width: 150),
    // footerItems: [
    //
    // ],
  }
}
