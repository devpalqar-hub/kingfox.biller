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
  CartModel? completedOrder;
String? invoiceNumber;

  List items = [];
List<ProductVariantModel> searchProductsList = [];
String appliedCoupon = "";

@override
  void onInit() {
    super.onInit();
    fetchCampaigns(); 
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

  final url = "$baseUrl/billing/product-search?q=$query";

  final headers = {
    "Authorization": "Bearer $accessToken"
  };

  /// 🔥 REQUEST LOG
  print("📤 ================= PRODUCT SEARCH REQUEST =================");
  print("➡️ URL: $url");
  print("➡️ METHOD: GET");
  print("➡️ HEADERS: $headers");
  print("➡️ QUERY: $query");
  print("📤 ==========================================================");

  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  /// 🔥 RESPONSE LOG
  print("📥 ================= PRODUCT SEARCH RESPONSE =================");
  print("⬅️ STATUS CODE: ${response.statusCode}");
  print("⬅️ BODY: ${response.body}");
  print("📥 ===========================================================");

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);

    /// 🔍 PARSED DATA LOG
    print("🔍 PARSED PRODUCTS COUNT: ${data.length}");

    searchProductsList =
        data.map((e) => ProductVariantModel.fromJson(e)).toList();

  } else {
    /// ❌ ERROR LOG
    print("❌ FAILED TO FETCH PRODUCTS");

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

  final Map<String, dynamic> body = {
    "paymentMethod": paymentMethod.toUpperCase(),
    "customerName": customerName ?? "",
    "customerPhone": customerPhone ?? "",
    "customerEmail": customerEmail ?? "",
    "customerAddress": customerAddress ?? "",
  };

  /// ✅ Add coupon ONLY if exists
  if (couponCode != null && couponCode.isNotEmpty) {
    body["couponCode"] = couponCode;
  }

  /// ✅ Add voucher ONLY if campaign exists
  if (campaignId != null) {
    body["campaignId"] = campaignId;

    if (voucherCount != null && voucherCount > 0) {
      body["voucherCount"] = voucherCount;
    }
  }

  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $accessToken",
  };

  /// 🔥 REQUEST LOG
  print("📤 ================= CHECKOUT REQUEST =================");
  print("➡️ URL: $url");
  print("➡️ METHOD: POST");
  print("➡️ HEADERS: $headers");
  print("➡️ BODY: ${jsonEncode(body)}");
  print("📤 ====================================================");

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  /// 🔥 RESPONSE LOG
  print("📥 ================= CHECKOUT RESPONSE =================");
  print("⬅️ STATUS CODE: ${response.statusCode}");
  print("⬅️ BODY: ${response.body}");
  print("📥 =====================================================");

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);

    /// 🔍 PARSED LOG
    print("🔍 PARSED DATA: $data");

    completedOrder = CartModel.fromJson(data["data"] ?? data);
    invoiceNumber = data["invoiceNumber"] ?? data["invoice_number"];

    print("✅ Checkout Success");
    print("🧾 Invoice Number: $invoiceNumber");

    isLoading = false;
    update();
    return true;
  }

  /// ❌ ERROR LOG
  print("❌ Checkout Failed");

  isLoading = false;
  update();
  return false;
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
  update();

  final url = '$baseUrl/lucky-draw/campaigns';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);

    campaigns =
        data.map((e) => LuckyDrawCampaign.fromJson(e)).toList();
  } else {
    campaigns = [];

  }

  isLoading = false;
  update();
}

void selectCampaign(LuckyDrawCampaign? campaign) {
  selectedCampaign = campaign;

  update();
}
}