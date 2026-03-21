
class CartModel {
  final int cartId;
  final int gstPercent;

  final int? returnInvoiceId;
  final double returnCredit;

  final List<ReturnItemModel> returnItems;
  final List<CartItemModel> items;

  final double subtotal;
  final double appliedReturnDiscount;
  final double refundAmount;
  final double discountedSubtotal;
  final double gstAmount;
  final double finalAmount;

  final List<dynamic> availableVouchers;

  CartModel({
    required this.cartId,
    required this.gstPercent,
    required this.returnItems,
    required this.items,
    required this.subtotal,
    required this.gstAmount,
    required this.finalAmount,
    required this.returnCredit,
    required this.appliedReturnDiscount,
    required this.refundAmount,
    required this.discountedSubtotal,
    required this.availableVouchers,
    this.returnInvoiceId,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] ?? 0,
      gstPercent: json['gstPercent'] ?? 0,

      returnInvoiceId: json['returnInvoiceId'],
      returnCredit: (json['returnCredit'] ?? 0).toDouble(),

      returnItems: (json['returnItems'] ?? [])
          .map<ReturnItemModel>((e) => ReturnItemModel.fromJson(e))
          .toList(),

      items: (json['items'] ?? [])
          .map<CartItemModel>((e) => CartItemModel.fromJson(e))
          .toList(),

      subtotal: (json['subtotal'] ?? 0).toDouble(),
      appliedReturnDiscount:
          (json['appliedReturnDiscount'] ?? 0).toDouble(),
      refundAmount: (json['refundAmount'] ?? 0).toDouble(),
      discountedSubtotal:
          (json['discountedSubtotal'] ?? 0).toDouble(),
      gstAmount: (json['gstAmount'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),

      availableVouchers: json['availableVouchers'] ?? [],
    );
  }
}
class ReturnItemModel {
  final int variantId;
  final int quantity;
  final double creditPerUnit;

  ReturnItemModel({
    required this.variantId,
    required this.quantity,
    required this.creditPerUnit,
  });

  factory ReturnItemModel.fromJson(Map<String, dynamic> json) {
    return ReturnItemModel(
      variantId: json['variantId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      creditPerUnit: (json['creditPerUnit'] ?? 0).toDouble(),
    );
  }
}
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
}
