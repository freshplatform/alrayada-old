// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) {
  return _AuthRequest.fromJson(json);
}

/// @nodoc
mixin _$AuthRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  UserDeviceNotificationsToken get deviceToken =>
      throw _privateConstructorUsedError;
  UserData? get userData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthRequestCopyWith<AuthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthRequestCopyWith<$Res> {
  factory $AuthRequestCopyWith(
          AuthRequest value, $Res Function(AuthRequest) then) =
      _$AuthRequestCopyWithImpl<$Res, AuthRequest>;
  @useResult
  $Res call(
      {String email,
      String password,
      UserDeviceNotificationsToken deviceToken,
      UserData? userData});

  $UserDeviceNotificationsTokenCopyWith<$Res> get deviceToken;
  $UserDataCopyWith<$Res>? get userData;
}

/// @nodoc
class _$AuthRequestCopyWithImpl<$Res, $Val extends AuthRequest>
    implements $AuthRequestCopyWith<$Res> {
  _$AuthRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceToken = null,
    Object? userData = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      deviceToken: null == deviceToken
          ? _value.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as UserDeviceNotificationsToken,
      userData: freezed == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as UserData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDeviceNotificationsTokenCopyWith<$Res> get deviceToken {
    return $UserDeviceNotificationsTokenCopyWith<$Res>(_value.deviceToken,
        (value) {
      return _then(_value.copyWith(deviceToken: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res>? get userData {
    if (_value.userData == null) {
      return null;
    }

    return $UserDataCopyWith<$Res>(_value.userData!, (value) {
      return _then(_value.copyWith(userData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthRequestImplCopyWith<$Res>
    implements $AuthRequestCopyWith<$Res> {
  factory _$$AuthRequestImplCopyWith(
          _$AuthRequestImpl value, $Res Function(_$AuthRequestImpl) then) =
      __$$AuthRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      UserDeviceNotificationsToken deviceToken,
      UserData? userData});

  @override
  $UserDeviceNotificationsTokenCopyWith<$Res> get deviceToken;
  @override
  $UserDataCopyWith<$Res>? get userData;
}

/// @nodoc
class __$$AuthRequestImplCopyWithImpl<$Res>
    extends _$AuthRequestCopyWithImpl<$Res, _$AuthRequestImpl>
    implements _$$AuthRequestImplCopyWith<$Res> {
  __$$AuthRequestImplCopyWithImpl(
      _$AuthRequestImpl _value, $Res Function(_$AuthRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceToken = null,
    Object? userData = freezed,
  }) {
    return _then(_$AuthRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      deviceToken: null == deviceToken
          ? _value.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as UserDeviceNotificationsToken,
      userData: freezed == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as UserData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthRequestImpl implements _AuthRequest {
  const _$AuthRequestImpl(
      {required this.email,
      required this.password,
      required this.deviceToken,
      this.userData});

  factory _$AuthRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final UserDeviceNotificationsToken deviceToken;
  @override
  final UserData? userData;

  @override
  String toString() {
    return 'AuthRequest(email: $email, password: $password, deviceToken: $deviceToken, userData: $userData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.deviceToken, deviceToken) ||
                other.deviceToken == deviceToken) &&
            (identical(other.userData, userData) ||
                other.userData == userData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, deviceToken, userData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthRequestImplCopyWith<_$AuthRequestImpl> get copyWith =>
      __$$AuthRequestImplCopyWithImpl<_$AuthRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthRequestImplToJson(
      this,
    );
  }
}

abstract class _AuthRequest implements AuthRequest {
  const factory _AuthRequest(
      {required final String email,
      required final String password,
      required final UserDeviceNotificationsToken deviceToken,
      final UserData? userData}) = _$AuthRequestImpl;

  factory _AuthRequest.fromJson(Map<String, dynamic> json) =
      _$AuthRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  UserDeviceNotificationsToken get deviceToken;
  @override
  UserData? get userData;
  @override
  @JsonKey(ignore: true)
  _$$AuthRequestImplCopyWith<_$AuthRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
