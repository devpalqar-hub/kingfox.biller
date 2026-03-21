class PreviewModel {
  final List<PreviewItem> items;
  final double subtotal;
  final CouponModel? coupon;
  final double discount;
  final int gstPercent;
  final double gstAmount;
  final double finalAmount;

  PreviewModel({
    required this.items,
    required this.subtotal,
    required this.coupon,
    required this.discount,
    required this.gstPercent,
    required this.gstAmount,
    required this.finalAmount,
  });

  factory PreviewModel.fromJson(Map<String, dynamic> json) {
    return PreviewModel(
      items: (json['items'] ?? [])
          .map<PreviewItem>((e) => PreviewItem.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      coupon: json['coupon'] != null
          ? CouponModel.fromJson(json['coupon'])
          : null,
      discount: (json['discount'] ?? 0).toDouble(),
      gstPercent: json['gstPercent'] ?? 0,
      gstAmount: (json['gstAmount'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),
    );
  }
}class PreviewItem {
  final int variantId;
  final int quantity;
  final double price;
  final double subtotal;
  final String sku;
  final String size;
  final String color;
  final String productName;

  PreviewItem({
    required this.variantId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.sku,
    required this.size,
    required this.color,
    required this.productName,
  });

  factory PreviewItem.fromJson(Map<String, dynamic> json) {
    return PreviewItem(
      variantId: json['variantId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      sku: json['sku'] ?? "",
      size: json['size'] ?? "",
      color: json['color'] ?? "",
      productName: json['productName'] ?? "",
    );
  }
}class CouponModel {
  final String code;
  final String discountType;
  final double discountValue;
  final double discountApplied;

  CouponModel({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.discountApplied,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] ?? "",
      discountType: json['discountType'] ?? "",
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      discountApplied: (json['discountApplied'] ?? 0).toDouble(),
    );
  }
}