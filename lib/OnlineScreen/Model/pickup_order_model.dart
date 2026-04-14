class PickupOrdersResponse {
  final List<PickupOrder> data;
  final Pagination pagination;

  PickupOrdersResponse({
    required this.data,
    required this.pagination,
  });

  factory PickupOrdersResponse.fromJson(Map<String, dynamic> json) {
    return PickupOrdersResponse(
      data: List<PickupOrder>.from(
        (json['data'] ?? []).map((x) => PickupOrder.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class PickupOrder {
  final int id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String finalAmount;
  final String paymentMethod;
  final String fulfillmentType;
  final String createdAt;
  final Customer customer;
  final List<OrderItem> items;

  PickupOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.finalAmount,
    required this.paymentMethod,
    required this.fulfillmentType,
    required this.createdAt,
    required this.customer,
    required this.items,
  });

 factory PickupOrder.fromJson(Map<String, dynamic> json) {
  return PickupOrder(
    id: json['id'] ?? 0,
    orderNumber: json['orderNumber']?.toString() ?? "",
    status: json['status']?.toString() ?? "",
    paymentStatus: json['paymentStatus']?.toString() ?? "",
    finalAmount: json['finalAmount']?.toString() ?? "0", 
    paymentMethod: json['paymentMethod']?.toString() ?? "",
    fulfillmentType: json['fulfillmentType']?.toString() ?? "",
    createdAt: json['createdAt']?.toString() ?? "",
    customer: Customer.fromJson(json['customer'] ?? {}),
    items: List<OrderItem>.from(
      (json['items'] ?? []).map((x) => OrderItem.fromJson(x)),
    ),
  );
}
}

class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
    );
  }
}

class OrderItem {
  final int id;
  final int quantity;
  final String price;
  final Variant variant;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.variant,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
  return OrderItem(
    id: json['id'] ?? 0,
    quantity: json['quantity'] ?? 0,
    price: json['price']?.toString() ?? "0", 
    variant: Variant.fromJson(json['variant'] ?? {}),
  );
}
}

class Variant {
  final int id;
  final String size;
  final String color;
  final String sellingPrice;
  final String weight;
  final Product product;

  Variant({
    required this.id,
    required this.size,
    required this.color,
    required this.sellingPrice,
    required this.weight,
    required this.product,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
  return Variant(
    id: json['id'] ?? 0,
    size: json['size']?.toString() ?? "",   
    color: json['color']?.toString() ?? "",
    sellingPrice: json['sellingPrice']?.toString() ?? "",
    weight: json['weight']?.toString() ?? "", 
    product: Product.fromJson(json['product'] ?? {}),
  );
}
}

class Product {
  final int id;
  final String name;
  final List<dynamic> images;

  Product({
    required this.id,
    required this.name,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      images: json['images'] ?? [],
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}