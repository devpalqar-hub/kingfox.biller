import 'dart:convert';

InventoryList inventoryListFromJson(String str) =>
    InventoryList.fromJson(json.decode(str));

/// ================= SAFE HELPERS =================
String? safeString(dynamic v) => v?.toString();

int? safeInt(dynamic v) =>
    v == null ? null : int.tryParse(v.toString());

double? safeDouble(dynamic v) =>
    v == null ? null : double.tryParse(v.toString());

/// ================= INVENTORY LIST =================
class InventoryList {
  List<InventoryModel> inventories;

  InventoryList({required this.inventories});

  factory InventoryList.fromJson(List<dynamic> json) => InventoryList(
        inventories:
            json.map((e) => InventoryModel.fromJson(e)).toList(),
      );
}

/// ================= INVENTORY MODEL =================
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

  /// 🔥 NORMAL API
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: safeInt(json['id']),
      variantId: safeInt(json['variantId']),
      branchId: safeInt(json['branchId']),
      stockQuantity: safeInt(json['stockQuantity']),
      updatedAt: safeString(json['updatedAt']),
      branch:
          json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      variant:
          json['variant'] != null ? Variant.fromJson(json['variant']) : null,
    );
  }

  /// 🔥 SEARCH API (FLAT → NESTED)
  factory InventoryModel.fromSearchJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: safeInt(json['id']),
      variantId: safeInt(json['variantId']),
      branchId: null,

      stockQuantity: safeInt(json['stockQuantity']) ?? 0,
      updatedAt: safeString(json['createdAt']),

      branch: null,

      variant: Variant(
        id: safeInt(json['id']),
        productId: safeInt(json['product']?['id']),

        size: safeString(json['size']),
        color: safeString(json['color']),
        sku: safeString(json['sku']),
        barcode: safeString(json['barcode']),

        costPrice: safeString(json['costPrice']),
        sellingPrice: safeString(json['sellingPrice']),

        createdAt: safeString(json['createdAt']),

        product: json['product'] != null
            ? Product.fromJson(json['product'])
            : null,
      ),
    );
  }
}

/// ================= BRANCH =================
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
        id: safeInt(json['id']),
        name: safeString(json['name']),
        phone: safeString(json['phone']),
        address: safeString(json['address']),
        type: safeString(json['type']),
        createdAt: safeString(json['createdAt']),
      );
}

/// ================= VARIANT =================
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
        id: safeInt(json['id']),
        productId: safeInt(json['productId']),
        size: safeString(json['size']),
        color: safeString(json['color']),
        sku: safeString(json['sku']),
        barcode: safeString(json['barcode']),
        costPrice: safeString(json['costPrice']),
        sellingPrice: safeString(json['sellingPrice']),
        createdAt: safeString(json['createdAt']),
        product: json['product'] != null
            ? Product.fromJson(json['product'])
            : null,
      );
}

/// ================= PRODUCT =================
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
        id: safeInt(json['id']),
        name: safeString(json['name']),
        description: safeString(json['description']),
        brandId: safeInt(json['brandId']),
        categoryId: safeInt(json['categoryId']),
        createdAt: safeString(json['createdAt']),
      );
}