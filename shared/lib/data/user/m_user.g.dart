// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      email: json['email'] as String,
      accountActivated: json['accountActivated'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? false,
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      pictureUrl: json['pictureUrl'] as String,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'email': instance.email,
      'accountActivated': instance.accountActivated,
      'emailVerified': instance.emailVerified,
      'role': _$UserRoleEnumMap[instance.role]!,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'pictureUrl': instance.pictureUrl,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'Admin',
  UserRole.user: 'User',
};

_$_UserData _$$_UserDataFromJson(Map<String, dynamic> json) => _$_UserData(
      labOwnerPhoneNumber: json['labOwnerPhoneNumber'] as String,
      labPhoneNumber: json['labPhoneNumber'] as String,
      labName: json['labName'] as String,
      labOwnerName: json['labOwnerName'] as String,
      city: $enumDecodeNullable(_$IraqGovernorateEnumMap, json['city']) ??
          IraqGovernorate.baghdad,
    );

Map<String, dynamic> _$$_UserDataToJson(_$_UserData instance) =>
    <String, dynamic>{
      'labOwnerPhoneNumber': instance.labOwnerPhoneNumber,
      'labPhoneNumber': instance.labPhoneNumber,
      'labName': instance.labName,
      'labOwnerName': instance.labOwnerName,
      'city': _$IraqGovernorateEnumMap[instance.city]!,
    };

const _$IraqGovernorateEnumMap = {
  IraqGovernorate.baghdad: 'Baghdad',
  IraqGovernorate.basra: 'Basra',
  IraqGovernorate.maysan: 'Maysan',
  IraqGovernorate.dhiQar: 'DhiQar',
  IraqGovernorate.diyala: 'Diyala',
  IraqGovernorate.karbala: 'Karbala',
  IraqGovernorate.kirkuk: 'Kirkuk',
  IraqGovernorate.najaf: 'Najaf',
  IraqGovernorate.nineveh: 'Nineveh',
  IraqGovernorate.wasit: 'Wasit',
  IraqGovernorate.anbar: 'Anbar',
  IraqGovernorate.salahAlDin: 'SalahAlDin',
  IraqGovernorate.babil: 'Babil',
  IraqGovernorate.babylon: 'Babylon',
  IraqGovernorate.alMuthanna: 'AlMuthanna',
  IraqGovernorate.alQadisiyyah: 'Al-Qadisiyyah',
  IraqGovernorate.thiQar: 'ThiQar',
};

_$_UserDeviceNotificationsToken _$$_UserDeviceNotificationsTokenFromJson(
        Map<String, dynamic> json) =>
    _$_UserDeviceNotificationsToken(
      firebase: json['firebase'] as String? ?? '',
      oneSignal: json['oneSignal'] ?? '',
    );

Map<String, dynamic> _$$_UserDeviceNotificationsTokenToJson(
        _$_UserDeviceNotificationsToken instance) =>
    <String, dynamic>{
      'firebase': instance.firebase,
      'oneSignal': instance.oneSignal,
    };
