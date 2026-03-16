class CartItemModel {
  final int variantId;
  final String sku;
  final String size;
  final String color;
  final String productName;
  final double price;
  final int quantity;
  final double lineTotal;
  final String? image;

  CartItemModel({
    required this.variantId,
    required this.sku,
    required this.size,
    required this.color,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.lineTotal,
    this.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      variantId: json['variantId'] ?? 0,
      sku: json['sku'] ?? "",
      size: json['size'] ?? "",
      color: json['color'] ?? "",
      productName: json['productName'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      lineTotal: (json['lineTotal'] ?? 0).toDouble(),
       image: json['image'],
    );
  }
}class CartModel {
  final int cartId;
  final int gstPercent;
  final List<CartItemModel> items;
  final double subtotal;
  final double gstAmount;
  final double finalAmount;

  CartModel({
    required this.cartId,
    required this.gstPercent,
    required this.items,
    required this.subtotal,
    required this.gstAmount,
    required this.finalAmount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] ?? 0,
      gstPercent: json['gstPercent'] ?? 0,
      items: (json['items'] ?? [])
          .map<CartItemModel>((e) => CartItemModel.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      gstAmount: (json['gstAmount'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),
    );
  }
}