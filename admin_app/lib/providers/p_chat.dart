import 'dart:developer' as developer show log;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/chat/m_chat_message.dart';
import 'package:shared_alrayada/services/networking/dio/dio.dart';
import 'package:shared_alrayada/utils/constants/routes.dart';

class SupportChatsNotififer extends StateNotifier<List<ChatRoom>> {
  SupportChatsNotififer() : super([]);

  static final provider =
      StateNotifierProvider<SupportChatsNotififer, List<ChatRoom>>(
    (ref) => SupportChatsNotififer(),
  );

  final _dio = DioService.getDio();

  // List<ChatRoom> get chatRooms => [...state];

  var isInitLoading = true;

  void reset() {
    isInitLoading = true;
    state = [];
  }

  Future<void> loadRooms() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.appSupportRoutes.adminRoutes.getRooms,
      );
      final rooms =
          response.data?.map((e) => ChatRoom.fromJson(e)).toList() ?? [];
      state = [...rooms];
    } on DioException {
      rethrow;
    } catch (e) {
      developer.log('Unexpected error: $e');
    }
  }

  Future<void> deleteRoom(String chatRoomId, int index) async {
    try {
      final response = await _dio.delete(
        RoutesConstants.appSupportRoutes.adminRoutes.deleteRoom(chatRoomId),
      );
      if (response.statusCode != 200) return;
      state = [...state]..removeAt(index);
    } catch (e) {
      return;
    }
  }
}
