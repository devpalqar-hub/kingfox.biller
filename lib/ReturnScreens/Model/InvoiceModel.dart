

class InvoiceModel {
  int id;
  String invoiceNumber;
  int customerId;
  int branchId;
  int userId;
  dynamic couponId;
  String subtotal;
  String discount;
  String tax;
  String returnCredit;
  String finalAmount;
  String status;
  DateTime createdAt;
  Customer customer;
  Branch branch;
  User user;
  dynamic coupon;
  List<Item> items;
  List<Payment> payments;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.customerId,
    required this.branchId,
    required this.userId,
    this.couponId,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.returnCredit,
    required this.finalAmount,
    required this.status,
    required this.createdAt,
    required this.customer,
    required this.branch,
    required this.user,
    this.coupon,
    required this.items,
    required this.payments,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        invoiceNumber: json["invoiceNumber"],
        customerId: json["customerId"],
        branchId: json["branchId"],
        userId: json["userId"],
        couponId: json["couponId"],
        subtotal: json["subtotal"],
        discount: json["discount"],
        tax: json["tax"],
        returnCredit: json["returnCredit"],
        finalAmount: json["finalAmount"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        customer: Customer.fromJson(json["customer"]),
        branch: Branch.fromJson(json["branch"]),
        user: User.fromJson(json["user"]),
        coupon: json["coupon"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        payments: List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNumber": invoiceNumber,
        "customerId": customerId,
        "branchId": branchId,
        "userId": userId,
        "couponId": couponId,
        "subtotal": subtotal,
        "discount": discount,
        "tax": tax,
        "returnCredit": returnCredit,
        "finalAmount": finalAmount,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "customer": customer.toJson(),
        "branch": branch.toJson(),
        "user": user.toJson(),
        "coupon": coupon,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
      };
}

class Customer {
  int id;
  String name;
  String phone;
  String email;
  String address;
  DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Branch {
  int id;
  String name;
  String phone;
  String address;
  String type;
  DateTime createdAt;

  Branch({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.type,
    required this.createdAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
      };
}

class User {
  int id;
  String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Item {
  int id;
  int invoiceId;
  int variantId;
  int quantity;
  String price;
  String subtotal;
  Variant? variant;

  Item({
    required this.id,
    required this.invoiceId,
    required this.variantId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.variant,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        invoiceId: json["invoiceId"],
        variantId: json["variantId"],
        quantity: json["quantity"],
        price: json["price"],
        subtotal: json["subtotal"],
        variant: json["variant"] != null ? Variant.fromJson(json["variant"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceId": invoiceId,
        "variantId": variantId,
        "quantity": quantity,
        "price": price,
        "subtotal": subtotal,
        "variant": variant?.toJson(),
      };
}

class Variant {
  int id;
  int productId;
  String size;
  String color;
  String sku;
  String barcode;
  String costPrice;
  String sellingPrice;
  String? image;
  DateTime createdAt;
  Product? product;

  Variant({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.sku,
    required this.barcode,
    required this.costPrice,
    required this.sellingPrice,
    required this.image,
    required this.createdAt,
    this.product,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json["id"],
        productId: json["productId"],
        size: json["size"],
        color: json["color"],
        sku: json["sku"],
        barcode: json["barcode"],
        costPrice: json["costPrice"],
        sellingPrice: json["sellingPrice"],
        image: json["image"],
        createdAt: DateTime.parse(json["createdAt"]),
        product: json["product"] != null ? Product.fromJson(json["product"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "size": size,
        "color": color,
        "sku": sku,
        "barcode": barcode,
        "costPrice": costPrice,
        "sellingPrice": sellingPrice,
        "image": image,
        "createdAt": createdAt.toIso8601String(),
        "product": product?.toJson(),
      };
}

class Product {
  int id;
  String name;
  String description;
  int brandId;
  int categoryId;
  List<dynamic> images;
  dynamic metaInfo;
  DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brandId,
    required this.categoryId,
    required this.images,
    this.metaInfo,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        brandId: json["brandId"],
        categoryId: json["categoryId"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        metaInfo: json["metaInfo"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "brandId": brandId,
        "categoryId": categoryId,
        "images": List<dynamic>.from(images.map((x) => x)),
        "metaInfo": metaInfo,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Payment {
  int id;
  int invoiceId;
  String paymentMethod;
  String amount;
  DateTime paidAt;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.paymentMethod,
    required this.amount,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        invoiceId: json["invoiceId"],
        paymentMethod: json["paymentMethod"],
        amount: json["amount"],
        paidAt: DateTime.parse(json["paidAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceId": invoiceId,
        "paymentMethod": paymentMethod,
        "amount": amount,
        "paidAt": paidAt.toIso8601String(),
      };
}