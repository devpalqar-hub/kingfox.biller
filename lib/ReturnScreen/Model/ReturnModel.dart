import 'dart:convert';

class Product {
  final int id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(id: json['id'], name: json['name']);
}

class Variant {
  final int id;
  final String size;
  final String color;
  final String sku;
  final Product product;

  Variant({
    required this.id,
    required this.size,
    required this.color,
    required this.sku,
    required this.product,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json['id'],
    size: json['size'],
    color: json['color'],
    sku: json['sku'],
    product: Product.fromJson(json['product']),
  );
}

class ReturnItem {
  final int id;
  final int quantity;
  final String refundAmount;
  final Variant variant;

  ReturnItem({
    required this.id,
    required this.quantity,
    required this.refundAmount,
    required this.variant,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) => ReturnItem(
    id: json['id'],
    quantity: json['quantity'],
    refundAmount: json['refundAmount'],
    variant: Variant.fromJson(json['variant']),
  );
}

// ------------------ Customer ------------------
class Customer {
  final int id;
  final String name;
  final String phone;

  Customer({required this.id, required this.name, required this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(id: json['id'], name: json['name'], phone: json['phone']);
}

class Branch {
  final int id;
  final String name;
  final String address;

  Branch({required this.id, required this.name, required this.address});

  factory Branch.fromJson(Map<String, dynamic> json) =>
      Branch(id: json['id'], name: json['name'], address: json['address']);
}

class ReturnModel {
  final int id;
  final String totalRefund;
  final String reason;
  final List<ReturnItem> items;
  // final Customer? customer;
  final Branch branch;
  final String createdAt;

  ReturnModel({
    required this.id,
    required this.totalRefund,
    required this.reason,
    required this.items,
    // required this.customer,
    required this.branch,
    required this.createdAt,
  });

  factory ReturnModel.fromJson(Map<String, dynamic> json) => ReturnModel(
    id: json['id'],
    totalRefund: json['totalRefund'],
    reason: json['reason'],
    items: (json['items'] as List).map((e) => ReturnItem.fromJson(e)).toList(),
    //customer: Customer.fromJson(json['customer']),
    branch: Branch.fromJson(json['branch']),
    createdAt: json['createdAt'],
  );
}

List<ReturnModel> returnModelFromJson(String str) =>
    (json.decode(str) as List).map((e) => ReturnModel.fromJson(e)).toList();
