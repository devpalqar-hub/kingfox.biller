class ProductVariantModel {
  final int variantId;
  final String sku;
  final String barcode;
  final String size;
  final String color;
  final double sellingPrice;
  final double costPrice;
  final int stockQty;
  final bool inStock;

  final int productId;
  final String productName;
  final String description;
  final String category;

  ProductVariantModel({
    required this.variantId,
    required this.sku,
    required this.barcode,
    required this.size,
    required this.color,
    required this.sellingPrice,
    required this.costPrice,
    required this.stockQty,
    required this.inStock,
    required this.productId,
    required this.productName,
    required this.description,
    required this.category,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json["variantId"] ?? 0,
      sku: json["sku"] ?? "",
      barcode: json["barcode"] ?? "",
      size: json["size"] ?? "",
      color: json["color"] ?? "",
      sellingPrice: (json["sellingPrice"] ?? 0).toDouble(),
      costPrice: (json["costPrice"] ?? 0).toDouble(),
      stockQty: json["stockQty"] ?? 0,
      inStock: json["inStock"] ?? false,

      productId: json["product"]?["id"] ?? 0,
      productName: json["product"]?["name"] ?? "",
      description: json["product"]?["description"] ?? "",
      category: json["product"]?["category"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "variantId": variantId,
      "sku": sku,
      "barcode": barcode,
      "size": size,
      "color": color,
      "sellingPrice": sellingPrice,
      "costPrice": costPrice,
      "stockQty": stockQty,
      "inStock": inStock,
      "product": {
        "id": productId,
        "name": productName,
        "description": description,
        "category": category,
      }
    };
  }
}