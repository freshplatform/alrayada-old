import 'package:flutter/foundation.dart';
import 'package:shared_alrayada/server/server.dart';

@immutable
class RoutesConstants {
  const RoutesConstants._();

  static final productsRoutes = ProductsRoutes._();
  static final productsCategoryRoutes = ProductCategoryRoutes._();
  static final authRoutes = AuthRoutes._();
  static final offersRoutes = OffersRoutes._();
  static final ordersRoutes = OrdersRoutes._();

  static final appSupportRoutes = AppSupportRoutes._();
}

class ProductsRoutes {
  static final root = '${ServerConfigurations.getBaseUrl()}products/';

  final getProducts = root;
  final addProduct = root;
  String getProductsByCategory(String id) {
    return '${root}byCategory/$id';
  }

  String deleteProduct(String id) {
    return root + id;
  }

  String updateProduct(String id) {
    return root + id;
  }

  ProductsRoutes._();
}

class ProductCategoryRoutes {
  static final root =
      '${ServerConfigurations.getBaseUrl()}products/categories/';
  final getCategories = root;
  final addCategory = root;
  String deleteCategory(String id) {
    return root + id;
  }

  String updateCategory(String id) {
    return root + id;
  }

  ProductCategoryRoutes._();
}

class AuthRoutes {
  static final root = '${ServerConfigurations.getBaseUrl()}authentication/';

  final forgotPassword = '${root}forgotPassword';
  final userData = '${root}userData';
  final updatePassword = '${root}updatePassword';
  final socialLogin = '${root}socialLogin';
  final signIn = '${root}signIn';
  final signUp = '${root}signUp';
  final updateDeviceToken = '${root}updateDeviceToken';
  final user = '${root}user';
  final deleteAccount = '${root}deleteAccount';
  final adminRoutes = AuthAdminRoutes._();
  final signInWithAppleWebRedirectUrl =
      '${ServerConfigurations.getProductionBaseUrl()}authentication/socialLogin/signInWithApple';

  AuthRoutes._();
}

class AuthAdminRoutes {
  static final root = '${AuthRoutes.root}admin/users/';
  final getUsers = root;
  final activateUserAccount = '${root}activateAccount';
  final deactivateUserAccount = '${root}deactivateAccount';
  final deleteUser = '${root}deleteUser';
  final sendNotificationToUser = '${root}sendNotification';

  AuthAdminRoutes._();
}

class OffersRoutes {
  static final root = '${ServerConfigurations.getBaseUrl()}offers/';

  final getOffers = root;
  final addOffer = root;
  String deleteOffer(String id) {
    return root + id;
  }

  OffersRoutes._();
}

class OrdersRoutes {
  static final root = '${ServerConfigurations.getBaseUrl()}orders/';
  final getOrders = root;
  final checkout = '${root}checkout';
  final getStatistics = '${root}statistics';
  final cancelOrder = '${root}cancelOrder';
  final isOrderPaid = '${root}isOrderPaid';
  final adminRoutes = OrdersAdminRoutes._();

  OrdersRoutes._();
}

class OrdersAdminRoutes {
  static final root = '${OrdersRoutes.root}admin';
  final deleteOrder = '$root/deleteOrder';
  final approveOrder = '$root/approveOrder';
  final rejectOrder = '$root/rejectOrder';

  OrdersAdminRoutes._();
}

class AppSupportRoutes {
  static final root = '${ServerConfigurations.getBaseWsUrl()}support/';
  final userChat = root;
  final adminRoutes = AppSupportAdminRoutes._();
  AppSupportRoutes._();
}

class AppSupportAdminRoutes {
  static final root = '${AppSupportRoutes.root}admin/';

  /// userRoomId by default is the uuid of the user
  String chatWithUser(String userRoomId) {
    return '${root}chat/$userRoomId';
  }

  final getRooms = '${root}rooms';
  String deleteRoom(String chatRoomId) {
    return '${root}rooms/$chatRoomId';
  }

  AppSupportAdminRoutes._();
}
