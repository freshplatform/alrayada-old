class Favorite {
  final String productId;
  final int createdAt;

  const Favorite({required this.productId, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'createdAt': createdAt,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      productId: map['productId'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  Favorite copyWith({
    String? productId,
    int? createdAt,
  }) {
    return Favorite(
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
