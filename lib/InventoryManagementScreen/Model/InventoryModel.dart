import 'dart:convert';

InventoryList inventoryListFromJson(String str) =>
    InventoryList.fromJson(json.decode(str));

class InventoryList {
  List<InventoryModel> inventories;

  InventoryList({required this.inventories});

  factory InventoryList.fromJson(List<dynamic> json) => InventoryList(
        inventories:
            json.map((e) => InventoryModel.fromJson(e)).toList(),
      );
}

class InventoryModel {
  int? id;
  int? variantId;
  int? branchId;
  int? stockQuantity;
  String? updatedAt;
  Branch? branch;
  Variant? variant;

  InventoryModel({
    this.id,
    this.variantId,
    this.branchId,
    this.stockQuantity,
    this.updatedAt,
    this.branch,
    this.variant,
  });

  /// ================= NORMAL API =================
  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      InventoryModel(
        id: json['id'],
        variantId: json['variantId'],
        branchId: json['branchId'],
        stockQuantity: json['stockQuantity'],
        updatedAt: json['updatedAt'],
        branch: json['branch'] != null
            ? Branch.fromJson(json['branch'])
            : null,
        variant: json['variant'] != null
            ? Variant.fromJson(json['variant'])
            : null,
      );

  /// ================= SEARCH API FIX =================
  factory InventoryModel.fromSearchJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      variantId: json['variantId'],
      branchId: null,

      /// sometimes search API may not return stock
      stockQuantity: json['stockQuantity'] ?? 0,
      updatedAt: json['createdAt'],

      /// ❌ branch not available in search API
      branch: null,

      /// 🔥 convert flat data → Variant
      variant: Variant(
        id: json['id'],
        productId: json['product']?['id'],
        size: json['size'],
        color: json['color'],
        sku: json['sku'],
        barcode: json['barcode'],
        costPrice: json['costPrice'],
        sellingPrice: json['sellingPrice'],
        createdAt: json['createdAt'],

        product: json['product'] != null
            ? Product.fromJson(json['product'])
            : null,
      ),
    );
  }
}

class Branch {
  int? id;
  String? name;
  String? phone;
  String? address;
  String? type;
  String? createdAt;

  Branch({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.type,
    this.createdAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        address: json['address'],
        type: json['type'],
        createdAt: json['createdAt'],
      );
}

class Variant {
  int? id;
  int? productId;
  String? size;
  String? color;
  String? sku;
  String? barcode;
  String? costPrice;
  String? sellingPrice;
  String? createdAt;
  Product? product;

  Variant({
    this.id,
    this.productId,
    this.size,
    this.color,
    this.sku,
    this.barcode,
    this.costPrice,
    this.sellingPrice,
    this.createdAt,
    this.product,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json['id'],
        productId: json['productId'],
        size: json['size'],
        color: json['color'],
        sku: json['sku'],
        barcode: json['barcode'],
        costPrice: json['costPrice'],
        sellingPrice: json['sellingPrice'],
        createdAt: json['createdAt'],
        product: json['product'] != null
            ? Product.fromJson(json['product'])
            : null,
      );
}

class Product {
  int? id;
  String? name;
  String? description;
  int? brandId;
  int? categoryId;
  String? createdAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.brandId,
    this.categoryId,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        brandId: json['brandId'],
        categoryId: json['categoryId'],
        createdAt: json['createdAt'],
      );
}