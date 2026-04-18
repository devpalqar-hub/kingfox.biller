import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final int brandId;
  final int categoryId;
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brandId,
    required this.categoryId,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? 0,
    name: json['name'] ?? '-',
    description: json['description'] ?? '-',
    brandId: json['brandId'] ?? 0,
    categoryId: json['categoryId'] ?? 0,
    createdAt: json['createdAt'] ?? '',
  );
}

class Variant {
  final int id;
  final int productId;
  final String size;
  final String color;
  final String sku;
  final String barcode;
  final String costPrice;
  final String sellingPrice;
  final String createdAt;
  final Product product;

  Variant({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.sku,
    required this.barcode,
    required this.costPrice,
    required this.sellingPrice,
    required this.createdAt,
    required this.product,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json['id'] ?? 0,
    productId: json['productId'] ?? 0,
    size: json['size'] ?? '-',
    color: json['color'] ?? '-',
    sku: json['sku'] ?? '-',
    barcode: json['barcode'] ?? '-',
    costPrice: json['costPrice'] ?? '0',
    sellingPrice: json['sellingPrice'] ?? '0',
    createdAt: json['createdAt'] ?? '',
    product: Product.fromJson(json['product'] ?? {}),
  );
}

class InvoiceItem {
  final int id;
  final int invoiceId;
  final int variantId;
  final int quantity;
  final String price;
  final String subtotal;
  final Variant variant;
  final int returnedQuantity;

  InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.variantId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.variant,
    required this.returnedQuantity,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    id: json['id'] ?? 0,
    invoiceId: json['invoiceId'] ?? 0,
    variantId: json['variantId'] ?? 0,
    quantity: json['quantity'] ?? 0,
    price: json['price'] ?? '0',
    subtotal: json['subtotal'] ?? '0',
    returnedQuantity: json["returnedQuantity"] ?? 0,
    variant: Variant.fromJson(json['variant'] ?? {}),
  );
}

class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'] ?? 0,
    name: json['name'] ?? '-',
    phone: json['phone'] ?? '-',
    email: json['email'] ?? '-',
    address: json['address'] ?? '-',
    createdAt: json['createdAt'] ?? '',
  );
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'] ?? 0, name: json['name'] ?? '-');
}

class Coupon {
  final int id;
  final String code;
  final String description;
  final String discountType;
  final String discountValue;
  final String startDate;
  final String endDate;

  Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json['id'] ?? 0,
    code: json['code'] ?? '-',
    description: json['description'] ?? '-',
    discountType: json['discountType'] ?? '-',
    discountValue: json['discountValue'] ?? '0',
    startDate: json['startDate'] ?? '',
    endDate: json['endDate'] ?? '',
  );
}

class Payment {
  final int id;
  final int invoiceId;
  final String paymentMethod;
  final String amount;
  final String paidAt;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.paymentMethod,
    required this.amount,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] ?? 0,
    invoiceId: json['invoiceId'] ?? 0,
    paymentMethod: json['paymentMethod'] ?? '-',
    amount: json['amount'] ?? '0',
    paidAt: json['paidAt'] ?? '',
  );
}

class InvoiceModel {
  final int id;
  final String invoiceNumber;
  final int? customerId;
  final int branchId;
  final int userId;
  final String subtotal;
  final String discount;
  final String tax;
  final String returnCredit;
  final String finalAmount;
  final String status;
  final String createdAt;
  final Customer? customer;
  final User user;
  final Coupon? coupon;
  final List<InvoiceItem> items;
  final List<Payment> payments;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    this.customerId,
    required this.branchId,
    required this.userId,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.returnCredit,
    required this.finalAmount,
    required this.status,
    required this.createdAt,
    this.customer,
    required this.user,
    this.coupon,
    required this.items,
    required this.payments,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    id: json['id'] ?? 0,
    invoiceNumber: json['invoiceNumber'] ?? '-',
    customerId: json['customerId'],
    branchId: json['branchId'] ?? 0,
    userId: json['userId'] ?? 0,
    subtotal: json['subtotal'] ?? '0',
    discount: json['discount'] ?? '0',
    tax: json['tax'] ?? '0',
    returnCredit: json['returnCredit'] ?? '0',
    finalAmount: json['finalAmount'] ?? '0',
    status: json['status'] ?? '-',
    createdAt: json['createdAt'] ?? '',
    customer: json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null,
    user: json['user'] != null
        ? User.fromJson(json['user'])
        : User(id: 0, name: '-'),
    coupon: json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null,
    items:
        (json['items'] as List<dynamic>?)
            ?.map((e) => InvoiceItem.fromJson(e))
            .toList() ??
        [],
    payments:
        (json['payments'] as List<dynamic>?)
            ?.map((e) => Payment.fromJson(e))
            .toList() ??
        [],
  );
}

List<InvoiceModel> invoiceListFromJson(String str) =>
    (json.decode(str)['data'] as List<dynamic>?)
        ?.map((e) => InvoiceModel.fromJson(e))
        .toList() ??
    [];
