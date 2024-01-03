// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_api_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

IpGeoLocation _$IpGeoLocationFromJson(Map<String, dynamic> json) {
  return _IpGeoLocation.fromJson(json);
}

/// @nodoc
mixin _$IpGeoLocation {
// required String ip,
// required String network,
// required String version,
  String get city => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IpGeoLocationCopyWith<IpGeoLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IpGeoLocationCopyWith<$Res> {
  factory $IpGeoLocationCopyWith(
          IpGeoLocation value, $Res Function(IpGeoLocation) then) =
      _$IpGeoLocationCopyWithImpl<$Res, IpGeoLocation>;
  @useResult
  $Res call({String city});
}

/// @nodoc
class _$IpGeoLocationCopyWithImpl<$Res, $Val extends IpGeoLocation>
    implements $IpGeoLocationCopyWith<$Res> {
  _$IpGeoLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = null,
  }) {
    return _then(_value.copyWith(
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IpGeoLocationImplCopyWith<$Res>
    implements $IpGeoLocationCopyWith<$Res> {
  factory _$$IpGeoLocationImplCopyWith(
          _$IpGeoLocationImpl value, $Res Function(_$IpGeoLocationImpl) then) =
      __$$IpGeoLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String city});
}

/// @nodoc
class __$$IpGeoLocationImplCopyWithImpl<$Res>
    extends _$IpGeoLocationCopyWithImpl<$Res, _$IpGeoLocationImpl>
    implements _$$IpGeoLocationImplCopyWith<$Res> {
  __$$IpGeoLocationImplCopyWithImpl(
      _$IpGeoLocationImpl _value, $Res Function(_$IpGeoLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = null,
  }) {
    return _then(_$IpGeoLocationImpl(
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IpGeoLocationImpl implements _IpGeoLocation {
  const _$IpGeoLocationImpl({required this.city});

  factory _$IpGeoLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$IpGeoLocationImplFromJson(json);

// required String ip,
// required String network,
// required String version,
  @override
  final String city;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IpGeoLocationImpl &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, city);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IpGeoLocationImplCopyWith<_$IpGeoLocationImpl> get copyWith =>
      __$$IpGeoLocationImplCopyWithImpl<_$IpGeoLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IpGeoLocationImplToJson(
      this,
    );
  }
}

abstract class _IpGeoLocation implements IpGeoLocation {
  const factory _IpGeoLocation({required final String city}) =
      _$IpGeoLocationImpl;

  factory _IpGeoLocation.fromJson(Map<String, dynamic> json) =
      _$IpGeoLocationImpl.fromJson;

  @override // required String ip,
// required String network,
// required String version,
  String get city;
  @override
  @JsonKey(ignore: true)
  _$$IpGeoLocationImplCopyWith<_$IpGeoLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
