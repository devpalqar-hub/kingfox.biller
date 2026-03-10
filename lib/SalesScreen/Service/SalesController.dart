import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/ProductModel.dart';
import 'package:kinfox_biller/main.dart';

class AddProductController extends GetxController {

  bool isLoading = false;

  int? cartId;
  double subtotal = 0;
  double gstAmount = 0;
  double finalAmount = 0;
  CartModel? cart;

  List items = [];
List<ProductVariantModel> searchProductsList = [];

  Future scanAndAddProduct(String barcode, int gstPercent) async {
  isLoading = true;
  update();

  final url = "$baseUrl/billing/cart/scan";
  final requestBody = {
    "barcode": barcode,
    "gstPercent": gstPercent.toString(),
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    },
    body: jsonEncode(requestBody),
  );
  final data = jsonDecode(response.body);
  cart = CartModel.fromJson(data);

cartId = cart!.cartId;
items = cart!.items;
subtotal = cart!.subtotal;
gstAmount = cart!.gstAmount;
finalAmount = cart!.finalAmount;

  isLoading = false;
  update();
}

Future getCart() async {
  isLoading = true;
  update();

  final url = "$baseUrl/billing/cart";
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $accessToken",
    },
  );

  final data = jsonDecode(response.body);
  cart = CartModel.fromJson(data);
  cartId = cart?.cartId;
  items = cart?.items ?? [];

  isLoading = false;
  update();
}

Future searchProducts(String query) async {

  if (query.isEmpty) {
    searchProductsList.clear();
    update();
    return;
  }

  isLoading = true;
  update();

  var response = await http.get(
    Uri.parse("$baseUrl/billing/product-search?q=$query"),
    headers: {
      "Authorization": "Bearer $accessToken"
    },
  );

  if (response.statusCode == 200) {

    List data = jsonDecode(response.body);

    searchProductsList =
        data.map((e) => ProductVariantModel.fromJson(e)).toList();

  } else {

    searchProductsList = [];

  }

  isLoading = false;
  update();
}

Future<void> checkoutCart({
  required String paymentMethod,
  String? customerName,
  String? customerPhone,
  String? customerEmail,
  String? customerAddress,
  String? couponCode,
  List<String>? voucherCodes,
}) async {
  isLoading = true;
  update();

  final url = "$baseUrl/billing/cart/checkout";

  final body = {
    "paymentMethod": paymentMethod.toUpperCase(),
    "customerName": customerName ?? "",
    "customerPhone": customerPhone ?? "",
    "customerEmail": customerEmail ?? "",
    "customerAddress": customerAddress ?? "",
    "couponCode": couponCode ?? "",
    "voucherCodes": voucherCodes ?? [],
  };
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    items.clear();
    subtotal = 0;
    gstAmount = 0;
    finalAmount = 0;
    update();
  }

  isLoading = false;
  update();
}



Future<void> deleteCart() async {
  isLoading = true;
  update();

  final url = "$baseUrl/billing/cart";

  final response = await http.delete(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    /// Clear local cart
    cartId = null;
    items.clear();
    subtotal = 0;
    gstAmount = 0;
    finalAmount = 0;
  }

  isLoading = false;
  update();
}
Future<void> updateCartItemQuantity(int variantId, int quantity) async {
  final url = "$baseUrl/billing/cart/item/$variantId";

  print("----- UPDATE CART ITEM API -----");
  print("URL: $url");
  print("Request Body: ${jsonEncode({"quantity": quantity})}");

  final response = await http.patch(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: jsonEncode({
      "quantity": quantity,
    }),
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    /// Replace full cart model
    cart = CartModel.fromJson(data);

    print("Cart Updated Successfully");
    print("Cart ID: ${cart!.cartId}");
    print("Items Count: ${cart!.items.length}");
    print("Subtotal: ${cart!.subtotal}");
    print("GST Amount: ${cart!.gstAmount}");
    print("Final Amount: ${cart!.finalAmount}");

    update(); // rebuild UI
  } else {
    print("Cart Update Failed ❌");
  }
}}