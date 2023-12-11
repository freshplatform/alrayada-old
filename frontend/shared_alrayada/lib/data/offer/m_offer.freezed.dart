// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return _Offer.fromJson(json);
}

/// @nodoc
mixin _$Offer {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OfferCopyWith<Offer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferCopyWith<$Res> {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) then) =
      _$OfferCopyWithImpl<$Res, Offer>;
  @useResult
  $Res call({String id, String imageUrl, DateTime createdAt});
}

/// @nodoc
class _$OfferCopyWithImpl<$Res, $Val extends Offer>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$$_OfferCopyWith(_$_Offer value, $Res Function(_$_Offer) then) =
      __$$_OfferCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String imageUrl, DateTime createdAt});
}

/// @nodoc
class __$$_OfferCopyWithImpl<$Res> extends _$OfferCopyWithImpl<$Res, _$_Offer>
    implements _$$_OfferCopyWith<$Res> {
  __$$_OfferCopyWithImpl(_$_Offer _value, $Res Function(_$_Offer) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? createdAt = null,
  }) {
    return _then(_$_Offer(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Offer implements _Offer {
  const _$_Offer(
      {required this.id, required this.imageUrl, required this.createdAt});

  factory _$_Offer.fromJson(Map<String, dynamic> json) =>
      _$$_OfferFromJson(json);

  @override
  final String id;
  @override
  final String imageUrl;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Offer(id: $id, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Offer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OfferCopyWith<_$_Offer> get copyWith =>
      __$$_OfferCopyWithImpl<_$_Offer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OfferToJson(
      this,
    );
  }
}

abstract class _Offer implements Offer {
  const factory _Offer(
      {required final String id,
      required final String imageUrl,
      required final DateTime createdAt}) = _$_Offer;

  factory _Offer.fromJson(Map<String, dynamic> json) = _$_Offer.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_OfferCopyWith<_$_Offer> get copyWith =>
      throw _privateConstructorUsedError;
}
