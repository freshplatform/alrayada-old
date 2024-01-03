import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/shared_alrayada.dart';
import 'package:shared_alrayada/widgets/pagination/pagination_options/pagniation_options.dart';

// @immutable
// class AdminUserNotifierState {
//   final List<User> user;
//   const AdminUserNotifierState({required this.user});
// }

class UserItemNotififer extends StateNotifier<User> {
  UserItemNotififer(super.user);

  static final provider = StateNotifierProvider.autoDispose
      .family<UserItemNotififer, User, User>((ref, user) {
    return UserItemNotififer(user);
  });

  Future<String?> activateAccount() async {
    try {
      await DioService.getDio().patch(
        RoutesConstants.authRoutes.adminRoutes.activateUserAccount,
        data: {
          'email': state.email,
        },
      );
      state = state.copyWith(accountActivated: true, emailVerified: true);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deactivateAccount() async {
    try {
      await DioService.getDio().patch(
        RoutesConstants.authRoutes.adminRoutes.deactivateUserAccount,
        data: {
          'email': state.email,
        },
      );
      state = state.copyWith(accountActivated: false);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendNotification({
    required String title,
    required String body,
  }) async {
    RoutesConstants.authRoutes.adminRoutes;
    try {
      await DioService.getDio().post(
        RoutesConstants.authRoutes.adminRoutes.sendNotificationToUser,
        data: {
          'title': title,
          'body': body,
          'email': state.email,
        },
      );
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}\n ${e.message}';
    }
  }
}

class AdminUsersNotifier extends StateNotifier<Object?> {
  AdminUsersNotifier() : super(null);

  static final provider = StateNotifierProvider<AdminUsersNotifier, Object?>(
    (ref) => AdminUsersNotifier(),
  );

  final _dio = DioService.getDio();

  PaginationState paginationState = const PaginationState();

  Future<List<User>> loadUsers(
      {required int page, String searchQuery = ''}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.authRoutes.adminRoutes.getUsers,
        queryParameters: {
          'page': page,
          'limit': 50,
          'searchQuery': searchQuery,
        },
      );
      final loadedUsers = response.data?.map(User.fromJson).toList() ?? [];
      return loadedUsers;
    } on DioException {
      rethrow;
    }
  }

  Future<String?> deleteUserAccount(
      {required BuildContext context,
      required int index,
      required String email}) async {
    try {
      await DioService.getDio().delete(
        RoutesConstants.authRoutes.adminRoutes.deleteUser,
        data: {
          'email': email,
        },
      );
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    } catch (e) {
      return 'Unknown error: ${e.toString()}';
    }
  }
}
