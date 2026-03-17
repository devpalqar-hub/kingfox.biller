import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/LuckyDrawModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/ProductModel.dart';
import 'package:kinfox_biller/main.dart';

class AddProductController extends GetxController {

  bool isLoading = false;
bool isUpdatingQty = false;
  int? cartId;
  double subtotal = 0;
  double gstAmount = 0;
  double finalAmount = 0;
  CartModel? cart;
  List<LuckyDrawCampaign> campaigns = [];
  LuckyDrawCampaign? selectedCampaign;

  List items = [];
List<ProductVariantModel> searchProductsList = [];

@override
  void onInit() {
    super.onInit();
    fetchCampaigns(); // fetch campaigns as soon as controller initializes
  }

Future scanAndAddProduct(String barcode, int gstPercent) async {
  isLoading = true;
  update();

  final url = "$baseUrl/billing/cart/scan";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    },
    body: jsonEncode({
      "barcode": barcode,
      "gstPercent": gstPercent.toString(),
    }),
  );

  final data = jsonDecode(response.body);

  cart = CartModel.fromJson(data);

  isLoading = false;
  update();
}

Future getCart() async {
  isLoading = true;
  update();

  final response = await http.get(
    Uri.parse("$baseUrl/billing/cart"),
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );

  final data = jsonDecode(response.body);

  cart = CartModel.fromJson(data);

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

Future<bool> checkoutCart({
  required String paymentMethod,
  String? customerName,
  String? customerPhone,
  String? customerEmail,
  String? customerAddress,
  String? couponCode,
  int? campaignId,
  int? voucherCount,
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
    "campaignId": campaignId ?? 0,
    "voucherCount": voucherCount ?? 0,
  };

  // Log the request
  print("=== Checkout Cart Request ===");
  print("URL: $url");
  print("Headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken' }");
  print("Body: ${jsonEncode(body)}");

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: jsonEncode(body),
  );

  // Log the response
  print("=== Checkout Cart Response ===");
  print("Status Code: ${response.statusCode}");
  print("Body: ${response.body}");

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print("Parsed Response: $data");

    items.clear();
    subtotal = 0;
    gstAmount = 0;
    finalAmount = 0;
    cart = null;

    isLoading = false;
    update();

    return true;
  } else {
    print("Checkout failed with status: ${response.statusCode}");
    isLoading = false;
    update();

    return false;
  }
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

  if (response.statusCode == 200 || response.statusCode == 201) {
   
    cart= null;
    items.clear();
   
  }

  isLoading = false;
  update();
}
Future<void> updateCartItemQuantity(int variantId, int quantity) async {

  if (isUpdatingQty) return;

  isUpdatingQty = true;

  final url = "$baseUrl/billing/cart/item/$variantId";

  final body = {
    "quantity": quantity,
  };

  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $accessToken",
  };
  final response = await http.patch(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    print("Parsed Response: $data");

    cart = CartModel.fromJson(data);

    
    for (var item in cart!.items) {
    }

    update();
  } else {
   
  }

  isUpdatingQty = false;
}

void fetchCampaigns() async {
  isLoading = true;
  update(); // triggers GetBuilder

  final url = '$baseUrl/lucky-draw/campaigns';
  print("Fetching campaigns from: $url"); // log request URL

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  print("Response status: ${response.statusCode}"); // log status code
  print("Response body: ${response.body}"); // log response body

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    campaigns = data.map((e) => LuckyDrawCampaign.fromJson(e)).toList();
    print("Parsed campaigns: ${campaigns.map((c) => c.name).toList()}"); // log parsed names
  } else {
    campaigns = [];
    print("Failed to fetch campaigns"); // log failure
  }

  isLoading = false;
  update(); // refresh UI after data is loaded
}

void selectCampaign(LuckyDrawCampaign? campaign) {
  selectedCampaign = campaign;
  print("Selected campaign: ${campaign?.name}"); // log selection
  update(); // rebuild dropdown
}
}