// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_auth_request_response.dart';

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
abstract class _$$_AuthRequestCopyWith<$Res>
    implements $AuthRequestCopyWith<$Res> {
  factory _$$_AuthRequestCopyWith(
          _$_AuthRequest value, $Res Function(_$_AuthRequest) then) =
      __$$_AuthRequestCopyWithImpl<$Res>;
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
class __$$_AuthRequestCopyWithImpl<$Res>
    extends _$AuthRequestCopyWithImpl<$Res, _$_AuthRequest>
    implements _$$_AuthRequestCopyWith<$Res> {
  __$$_AuthRequestCopyWithImpl(
      _$_AuthRequest _value, $Res Function(_$_AuthRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceToken = null,
    Object? userData = freezed,
  }) {
    return _then(_$_AuthRequest(
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
class _$_AuthRequest implements _AuthRequest {
  const _$_AuthRequest(
      {required this.email,
      required this.password,
      required this.deviceToken,
      this.userData});

  factory _$_AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$$_AuthRequestFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthRequest &&
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
  _$$_AuthRequestCopyWith<_$_AuthRequest> get copyWith =>
      __$$_AuthRequestCopyWithImpl<_$_AuthRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthRequestToJson(
      this,
    );
  }
}

abstract class _AuthRequest implements AuthRequest {
  const factory _AuthRequest(
      {required final String email,
      required final String password,
      required final UserDeviceNotificationsToken deviceToken,
      final UserData? userData}) = _$_AuthRequest;

  factory _AuthRequest.fromJson(Map<String, dynamic> json) =
      _$_AuthRequest.fromJson;

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
  _$$_AuthRequestCopyWith<_$_AuthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

UserAuthenticatedResponse _$UserAuthenticatedResponseFromJson(
    Map<String, dynamic> json) {
  return _AuthSignInResponse.fromJson(json);
}

/// @nodoc
mixin _$UserAuthenticatedResponse {
  String get token => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  int get expiresAt => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAuthenticatedResponseCopyWith<UserAuthenticatedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAuthenticatedResponseCopyWith<$Res> {
  factory $UserAuthenticatedResponseCopyWith(UserAuthenticatedResponse value,
          $Res Function(UserAuthenticatedResponse) then) =
      _$UserAuthenticatedResponseCopyWithImpl<$Res, UserAuthenticatedResponse>;
  @useResult
  $Res call({String token, int expiresIn, int expiresAt, User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$UserAuthenticatedResponseCopyWithImpl<$Res,
        $Val extends UserAuthenticatedResponse>
    implements $UserAuthenticatedResponseCopyWith<$Res> {
  _$UserAuthenticatedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expiresIn = null,
    Object? expiresAt = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AuthSignInResponseCopyWith<$Res>
    implements $UserAuthenticatedResponseCopyWith<$Res> {
  factory _$$_AuthSignInResponseCopyWith(_$_AuthSignInResponse value,
          $Res Function(_$_AuthSignInResponse) then) =
      __$$_AuthSignInResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, int expiresIn, int expiresAt, User user});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$_AuthSignInResponseCopyWithImpl<$Res>
    extends _$UserAuthenticatedResponseCopyWithImpl<$Res, _$_AuthSignInResponse>
    implements _$$_AuthSignInResponseCopyWith<$Res> {
  __$$_AuthSignInResponseCopyWithImpl(
      _$_AuthSignInResponse _value, $Res Function(_$_AuthSignInResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expiresIn = null,
    Object? expiresAt = null,
    Object? user = null,
  }) {
    return _then(_$_AuthSignInResponse(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthSignInResponse implements _AuthSignInResponse {
  const _$_AuthSignInResponse(
      {required this.token,
      required this.expiresIn,
      required this.expiresAt,
      required this.user});

  factory _$_AuthSignInResponse.fromJson(Map<String, dynamic> json) =>
      _$$_AuthSignInResponseFromJson(json);

  @override
  final String token;
  @override
  final int expiresIn;
  @override
  final int expiresAt;
  @override
  final User user;

  @override
  String toString() {
    return 'UserAuthenticatedResponse(token: $token, expiresIn: $expiresIn, expiresAt: $expiresAt, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthSignInResponse &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, expiresIn, expiresAt, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthSignInResponseCopyWith<_$_AuthSignInResponse> get copyWith =>
      __$$_AuthSignInResponseCopyWithImpl<_$_AuthSignInResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthSignInResponseToJson(
      this,
    );
  }
}

abstract class _AuthSignInResponse implements UserAuthenticatedResponse {
  const factory _AuthSignInResponse(
      {required final String token,
      required final int expiresIn,
      required final int expiresAt,
      required final User user}) = _$_AuthSignInResponse;

  factory _AuthSignInResponse.fromJson(Map<String, dynamic> json) =
      _$_AuthSignInResponse.fromJson;

  @override
  String get token;
  @override
  int get expiresIn;
  @override
  int get expiresAt;
  @override
  User get user;
  @override
  @JsonKey(ignore: true)
  _$$_AuthSignInResponseCopyWith<_$_AuthSignInResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
