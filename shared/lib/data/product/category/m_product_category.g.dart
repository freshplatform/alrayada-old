// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProductCategory _$$_ProductCategoryFromJson(Map<String, dynamic> json) =>
    _$_ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      parent: json['parent'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ProductCategoryToJson(_$_ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'imageUrls': instance.imageUrls,
      'parent': instance.parent,
      'createdAt': instance.createdAt.toIso8601String(),
      'children': instance.children,
    };

_$_ProducrtCategoryRequest _$$_ProducrtCategoryRequestFromJson(
        Map<String, dynamic> json) =>
    _$_ProducrtCategoryRequest(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      parent: json['parent'] as String?,
    );

Map<String, dynamic> _$$_ProducrtCategoryRequestToJson(
        _$_ProducrtCategoryRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'parent': instance.parent,
    };
