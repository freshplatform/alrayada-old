// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get email => throw _privateConstructorUsedError;
  bool get accountActivated => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  UserData get data => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get pictureUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String email,
      bool accountActivated,
      bool emailVerified,
      UserRole role,
      UserData data,
      DateTime createdAt,
      String userId,
      String pictureUrl});

  $UserDataCopyWith<$Res> get data;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? accountActivated = null,
    Object? emailVerified = null,
    Object? role = null,
    Object? data = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? pictureUrl = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      accountActivated: null == accountActivated
          ? _value.accountActivated
          : accountActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserData,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pictureUrl: null == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get data {
    return $UserDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      bool accountActivated,
      bool emailVerified,
      UserRole role,
      UserData data,
      DateTime createdAt,
      String userId,
      String pictureUrl});

  @override
  $UserDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? accountActivated = null,
    Object? emailVerified = null,
    Object? role = null,
    Object? data = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? pictureUrl = null,
  }) {
    return _then(_$_User(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      accountActivated: null == accountActivated
          ? _value.accountActivated
          : accountActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserData,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pictureUrl: null == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User implements _User {
  const _$_User(
      {required this.email,
      this.accountActivated = false,
      this.emailVerified = false,
      this.role = UserRole.user,
      required this.data,
      required this.createdAt,
      required this.userId,
      required this.pictureUrl});

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String email;
  @override
  @JsonKey()
  final bool accountActivated;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final UserRole role;
  @override
  final UserData data;
  @override
  final DateTime createdAt;
  @override
  final String userId;
  @override
  final String pictureUrl;

  @override
  String toString() {
    return 'User(email: $email, accountActivated: $accountActivated, emailVerified: $emailVerified, role: $role, data: $data, createdAt: $createdAt, userId: $userId, pictureUrl: $pictureUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.accountActivated, accountActivated) ||
                other.accountActivated == accountActivated) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, accountActivated,
      emailVerified, role, data, createdAt, userId, pictureUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String email,
      final bool accountActivated,
      final bool emailVerified,
      final UserRole role,
      required final UserData data,
      required final DateTime createdAt,
      required final String userId,
      required final String pictureUrl}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get email;
  @override
  bool get accountActivated;
  @override
  bool get emailVerified;
  @override
  UserRole get role;
  @override
  UserData get data;
  @override
  DateTime get createdAt;
  @override
  String get userId;
  @override
  String get pictureUrl;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get labOwnerPhoneNumber => throw _privateConstructorUsedError;
  String get labPhoneNumber => throw _privateConstructorUsedError;
  String get labName => throw _privateConstructorUsedError;
  String get labOwnerName => throw _privateConstructorUsedError;
  IraqGovernorate get city => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String labOwnerPhoneNumber,
      String labPhoneNumber,
      String labName,
      String labOwnerName,
      IraqGovernorate city});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? labOwnerPhoneNumber = null,
    Object? labPhoneNumber = null,
    Object? labName = null,
    Object? labOwnerName = null,
    Object? city = null,
  }) {
    return _then(_value.copyWith(
      labOwnerPhoneNumber: null == labOwnerPhoneNumber
          ? _value.labOwnerPhoneNumber
          : labOwnerPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labPhoneNumber: null == labPhoneNumber
          ? _value.labPhoneNumber
          : labPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labName: null == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String,
      labOwnerName: null == labOwnerName
          ? _value.labOwnerName
          : labOwnerName // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as IraqGovernorate,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserDataCopyWith<$Res> implements $UserDataCopyWith<$Res> {
  factory _$$_UserDataCopyWith(
          _$_UserData value, $Res Function(_$_UserData) then) =
      __$$_UserDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String labOwnerPhoneNumber,
      String labPhoneNumber,
      String labName,
      String labOwnerName,
      IraqGovernorate city});
}

/// @nodoc
class __$$_UserDataCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$_UserData>
    implements _$$_UserDataCopyWith<$Res> {
  __$$_UserDataCopyWithImpl(
      _$_UserData _value, $Res Function(_$_UserData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? labOwnerPhoneNumber = null,
    Object? labPhoneNumber = null,
    Object? labName = null,
    Object? labOwnerName = null,
    Object? city = null,
  }) {
    return _then(_$_UserData(
      labOwnerPhoneNumber: null == labOwnerPhoneNumber
          ? _value.labOwnerPhoneNumber
          : labOwnerPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labPhoneNumber: null == labPhoneNumber
          ? _value.labPhoneNumber
          : labPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labName: null == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String,
      labOwnerName: null == labOwnerName
          ? _value.labOwnerName
          : labOwnerName // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as IraqGovernorate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserData implements _UserData {
  const _$_UserData(
      {required this.labOwnerPhoneNumber,
      required this.labPhoneNumber,
      required this.labName,
      required this.labOwnerName,
      this.city = IraqGovernorate.baghdad});

  factory _$_UserData.fromJson(Map<String, dynamic> json) =>
      _$$_UserDataFromJson(json);

  @override
  final String labOwnerPhoneNumber;
  @override
  final String labPhoneNumber;
  @override
  final String labName;
  @override
  final String labOwnerName;
  @override
  @JsonKey()
  final IraqGovernorate city;

  @override
  String toString() {
    return 'UserData(labOwnerPhoneNumber: $labOwnerPhoneNumber, labPhoneNumber: $labPhoneNumber, labName: $labName, labOwnerName: $labOwnerName, city: $city)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserData &&
            (identical(other.labOwnerPhoneNumber, labOwnerPhoneNumber) ||
                other.labOwnerPhoneNumber == labOwnerPhoneNumber) &&
            (identical(other.labPhoneNumber, labPhoneNumber) ||
                other.labPhoneNumber == labPhoneNumber) &&
            (identical(other.labName, labName) || other.labName == labName) &&
            (identical(other.labOwnerName, labOwnerName) ||
                other.labOwnerName == labOwnerName) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, labOwnerPhoneNumber,
      labPhoneNumber, labName, labOwnerName, city);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserDataCopyWith<_$_UserData> get copyWith =>
      __$$_UserDataCopyWithImpl<_$_UserData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserDataToJson(
      this,
    );
  }
}

abstract class _UserData implements UserData {
  const factory _UserData(
      {required final String labOwnerPhoneNumber,
      required final String labPhoneNumber,
      required final String labName,
      required final String labOwnerName,
      final IraqGovernorate city}) = _$_UserData;

  factory _UserData.fromJson(Map<String, dynamic> json) = _$_UserData.fromJson;

  @override
  String get labOwnerPhoneNumber;
  @override
  String get labPhoneNumber;
  @override
  String get labName;
  @override
  String get labOwnerName;
  @override
  IraqGovernorate get city;
  @override
  @JsonKey(ignore: true)
  _$$_UserDataCopyWith<_$_UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDeviceNotificationsToken _$UserDeviceNotificationsTokenFromJson(
    Map<String, dynamic> json) {
  return _UserDeviceNotificationsToken.fromJson(json);
}

/// @nodoc
mixin _$UserDeviceNotificationsToken {
  String get firebase => throw _privateConstructorUsedError;
  dynamic get oneSignal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDeviceNotificationsTokenCopyWith<UserDeviceNotificationsToken>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDeviceNotificationsTokenCopyWith<$Res> {
  factory $UserDeviceNotificationsTokenCopyWith(
          UserDeviceNotificationsToken value,
          $Res Function(UserDeviceNotificationsToken) then) =
      _$UserDeviceNotificationsTokenCopyWithImpl<$Res,
          UserDeviceNotificationsToken>;
  @useResult
  $Res call({String firebase, dynamic oneSignal});
}

/// @nodoc
class _$UserDeviceNotificationsTokenCopyWithImpl<$Res,
        $Val extends UserDeviceNotificationsToken>
    implements $UserDeviceNotificationsTokenCopyWith<$Res> {
  _$UserDeviceNotificationsTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebase = null,
    Object? oneSignal = freezed,
  }) {
    return _then(_value.copyWith(
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as String,
      oneSignal: freezed == oneSignal
          ? _value.oneSignal
          : oneSignal // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserDeviceNotificationsTokenCopyWith<$Res>
    implements $UserDeviceNotificationsTokenCopyWith<$Res> {
  factory _$$_UserDeviceNotificationsTokenCopyWith(
          _$_UserDeviceNotificationsToken value,
          $Res Function(_$_UserDeviceNotificationsToken) then) =
      __$$_UserDeviceNotificationsTokenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String firebase, dynamic oneSignal});
}

/// @nodoc
class __$$_UserDeviceNotificationsTokenCopyWithImpl<$Res>
    extends _$UserDeviceNotificationsTokenCopyWithImpl<$Res,
        _$_UserDeviceNotificationsToken>
    implements _$$_UserDeviceNotificationsTokenCopyWith<$Res> {
  __$$_UserDeviceNotificationsTokenCopyWithImpl(
      _$_UserDeviceNotificationsToken _value,
      $Res Function(_$_UserDeviceNotificationsToken) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebase = null,
    Object? oneSignal = freezed,
  }) {
    return _then(_$_UserDeviceNotificationsToken(
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as String,
      oneSignal: freezed == oneSignal ? _value.oneSignal! : oneSignal,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserDeviceNotificationsToken implements _UserDeviceNotificationsToken {
  const _$_UserDeviceNotificationsToken(
      {this.firebase = '', this.oneSignal = ''});

  factory _$_UserDeviceNotificationsToken.fromJson(Map<String, dynamic> json) =>
      _$$_UserDeviceNotificationsTokenFromJson(json);

  @override
  @JsonKey()
  final String firebase;
  @override
  @JsonKey()
  final dynamic oneSignal;

  @override
  String toString() {
    return 'UserDeviceNotificationsToken(firebase: $firebase, oneSignal: $oneSignal)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserDeviceNotificationsToken &&
            (identical(other.firebase, firebase) ||
                other.firebase == firebase) &&
            const DeepCollectionEquality().equals(other.oneSignal, oneSignal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, firebase, const DeepCollectionEquality().hash(oneSignal));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserDeviceNotificationsTokenCopyWith<_$_UserDeviceNotificationsToken>
      get copyWith => __$$_UserDeviceNotificationsTokenCopyWithImpl<
          _$_UserDeviceNotificationsToken>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserDeviceNotificationsTokenToJson(
      this,
    );
  }
}

abstract class _UserDeviceNotificationsToken
    implements UserDeviceNotificationsToken {
  const factory _UserDeviceNotificationsToken(
      {final String firebase,
      final dynamic oneSignal}) = _$_UserDeviceNotificationsToken;

  factory _UserDeviceNotificationsToken.fromJson(Map<String, dynamic> json) =
      _$_UserDeviceNotificationsToken.fromJson;

  @override
  String get firebase;
  @override
  dynamic get oneSignal;
  @override
  @JsonKey(ignore: true)
  _$$_UserDeviceNotificationsTokenCopyWith<_$_UserDeviceNotificationsToken>
      get copyWith => throw _privateConstructorUsedError;
}
