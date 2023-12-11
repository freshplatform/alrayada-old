// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatRoom _$$_ChatRoomFromJson(Map<String, dynamic> json) => _$_ChatRoom(
      id: json['id'] as String,
      chatRoomId: json['chatRoomId'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userData: UserData.fromJson(json['userData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ChatRoomToJson(_$_ChatRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatRoomId': instance.chatRoomId,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userData': instance.userData,
    };

_$_ChatMessage _$$_ChatMessageFromJson(Map<String, dynamic> json) =>
    _$_ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_ChatMessageToJson(_$_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'senderId': instance.senderId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
