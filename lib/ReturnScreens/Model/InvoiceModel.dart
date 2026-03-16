class InvoiceModel {
  int? id;
  String? invoiceNumber;
  String? subtotal;
  String? discount;
  String? tax;
  String? returnCredit;
  String? finalAmount;
  String? status;
  String? createdAt;

  Customer? customer;
  List<InvoiceItem>? items;

  InvoiceModel({
    this.id,
    this.invoiceNumber,
    this.subtotal,
    this.discount,
    this.tax,
    this.returnCredit,
    this.finalAmount,
    this.status,
    this.createdAt,
    this.customer,
    this.items,
  });

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNumber = json['invoiceNumber'];
    subtotal = json['subtotal'];
    discount = json['discount'];
    tax = json['tax'];
    returnCredit = json['returnCredit'];
    finalAmount = json['finalAmount'];
    status = json['status'];
    createdAt = json['createdAt'];

    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;

    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(InvoiceItem.fromJson(v));
      });
    }
  }
}

class Customer {
  String? name;
  String? phone;
  String? email;
  String? address;

  Customer({this.name, this.phone, this.email, this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
  }
}

class InvoiceItem {
  int? quantity;
  String? price;
  String? subtotal;
  Variant? variant;

  InvoiceItem({this.quantity, this.price, this.subtotal, this.variant});

  InvoiceItem.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    subtotal = json['subtotal'];

    variant =
        json['variant'] != null ? Variant.fromJson(json['variant']) : null;
  }
}

class Variant {
  String? sku;
  String? size;
  String? color;
  Product? product;

  Variant({this.sku, this.size, this.color, this.product});

  Variant.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    size = json['size'];
    color = json['color'];

    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }
}

class Product {
  String? name;
  String? description;

  Product({this.name, this.description});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
  }
}