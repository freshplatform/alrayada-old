import 'package:json_annotation/json_annotation.dart';

part 'm_cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart {
  final String productId;
  final int quantity;
  final String notes;

  // We don't need the created at in toJson() since we will send those data to server and we don't want include it
  @JsonKey(includeToJson: false, includeFromJson: false)
  final int createdAt;

  const Cart({
    required this.productId,
    required this.quantity,
    this.createdAt = -1,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'createdAt': createdAt,
      'notes': notes
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      createdAt: map['createdAt'] as int,
      notes: map['notes'] as String,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);

  Cart copyWith(
      {String? productId, int? quantity, int? createdAt, String? notes}) {
    return Cart(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
