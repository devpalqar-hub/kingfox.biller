import 'dart:async';
import 'dart:convert';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OrderCompleteDailogue/OrderCompleteDailogue.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/CheckoutModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/LuckyDrawModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/ProductModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/StaffModel.dart';
import 'package:kinfox_biller/SalesScreen/Service/PrinterController.dart';
import 'package:kinfox_biller/main.dart';
import 'package:flutter/material.dart';

class AddProductController extends GetxController {
  bool isLoading = false;
  bool isUpdatingQty = false;
  int? cartId;
  double subtotal = 0;
  double gstAmount = 0;
  double finalAmount = 0;
  CartModel? cart;
  String? couponError;
  String? voucherError;
  int? attendedByStaffId;

  List<LuckyDrawCampaign> campaigns = [];
  LuckyDrawCampaign? selectedCampaign;
  List<StaffModel> staffList = [];
  StaffModel? selectedStaff;
  String selectedPaymentMethod = "CASH";

  List items = [];
  List<ProductVariantModel> searchProductsList = [];

  String appliedCoupon = "";

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final voucherCountController = TextEditingController();
  final couponController = TextEditingController();
  final discountController = TextEditingController();

  DateTime? _lastHardwareScanAt;
  String _lastHardwareScanBarcode = '';

  String _normalizeBarcode(String raw) {
    final compact = raw.trim().replaceAll(RegExp(r'\s+'), '');
    return compact.replaceAll(RegExp(r'[^A-Za-z0-9\-_.]'), '');
  }

  Future<void> scanFromKeyboard(String rawBarcode, {int gstPercent = 5}) async {
    final barcode = _normalizeBarcode(rawBarcode);

    // Ignore accidental key noise that is too short to be a real barcode.
    if (barcode.length < 4) return;

    final now = DateTime.now();
    if (_lastHardwareScanBarcode == barcode &&
        _lastHardwareScanAt != null &&
        now.difference(_lastHardwareScanAt!).inMilliseconds < 900) {
      return;
    }

    if (isLoading) return;

    _lastHardwareScanBarcode = barcode;
    _lastHardwareScanAt = now;

    await scanAndAddProduct(barcode, gstPercent);
  }

  void clearAllTextControllers() {
    nameController.clear();
    phoneController.clear();
    voucherCountController.text = "0";
    couponController.clear();
    discountController.clear();
    update();
  }

  void clearVoucherSelection() {
    selectedCampaign = null;
  }

  void resetVoucherSelection() {
    if (campaigns.isEmpty) {
      fetchCampaigns();
    }
  }

  void selectStaff(StaffModel staff) {
    selectedStaff = staff;
    attendedByStaffId = staff.id;
    update();
  }

  void disposeAllTextControllers() {
    nameController.dispose();
    phoneController.dispose();
    voucherCountController.dispose();
    couponController.dispose();
    discountController.dispose();
  }

  void updateVoucherCount() {
    int count = int.tryParse(voucherCountController.text) ?? 1;
    count++;
    voucherCountController.text = count.toString();
    update();
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method.toUpperCase();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    voucherCountController.text = "1";
    fetchCampaigns();
    fetchStaff();
    getCart();
  }

  @override
  void onClose() {
    disposeAllTextControllers();
    super.onClose();
  }

  void selectCampaign(LuckyDrawCampaign campaign) {
    selectedCampaign = campaign;
    update();
  }

  Future scanAndAddProduct(String barcode, int gstPercent) async {
    final cleanedBarcode = _normalizeBarcode(barcode);
    if (cleanedBarcode.isEmpty) return;

    isLoading = true;
    update();

    final url = "$baseUrl/billing/cart/scan";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "barcode": cleanedBarcode,
        "gstPercent": gstPercent.toString(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      cart = CartModel.fromJson(data);
    } else {}

    isLoading = false;
    update();
  }

  Future<bool> getCart({
    String? couponCode,
    double? manualDiscountAmount,
  }) async {
    isLoading = true;
    update();

    final applied = couponCode ?? appliedCoupon;

    /// ✅ AUTO READ DISCOUNT FROM CONTROLLER (OPTIONAL BUT BEST)
    manualDiscountAmount ??= double.tryParse(discountController.text.trim());

    final queryParams = <String, String>{};

    if (applied.isNotEmpty) {
      queryParams['couponCode'] = applied;
    }

    /// ✅ FIXED CONDITION (allow even 0 if needed)
    if (manualDiscountAmount != null) {
      queryParams['manualDiscountAmount'] = manualDiscountAmount.toString();
    }

    final uri = Uri.parse(
      "$baseUrl/billing/cart",
    ).replace(queryParameters: queryParams);

    final headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };

    /// 🔥 PRINT REQUEST
    debugPrint("========== GET CART REQUEST ==========");
    debugPrint("URL: $uri");
    debugPrint("QUERY PARAMS: $queryParams");
    debugPrint("COUPON: $applied");
    debugPrint("DISCOUNT: $manualDiscountAmount");
    debugPrint("======================================");

    final response = await http.get(uri, headers: headers);

    /// 🔥 PRINT RESPONSE
    debugPrint("========== GET CART RESPONSE ==========");
    debugPrint("STATUS CODE: ${response.statusCode}");
    debugPrint("BODY: ${response.body}");
    debugPrint("=======================================");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      cart = CartModel.fromJson(data);
      appliedCoupon = applied;

      /// 🔍 EXTRA DEBUG
      debugPrint("Cart Total: ${cart?.finalAmount}");
      debugPrint("Coupon Discount: ${cart?.couponDiscountAmount}");

      if (applied.isNotEmpty && (cart?.couponDiscountAmount ?? 0) == 0) {
        couponError = "Invalid or expired coupon";

        isLoading = false;
        update();
        return false;
      }

      couponError = null;

      isLoading = false;
      update();
      return true;
    } else {
      cart = null;

      couponError = "Failed to fetch cart";

      isLoading = false;
      update();
      return false;
    }
  }

  Future searchProducts(String query) async {
    if (query.isEmpty) {
      searchProductsList.clear();

      return;
    }

    isLoading = true;

    final url = "$baseUrl/billing/product-search?q=$query";

    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List data = [];

      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded['data'] != null) {
        data = decoded['data'];
      }

      searchProductsList = data
          .map((e) => ProductVariantModel.fromJson(e))
          .toList();
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
    double? manualDiscountAmount,
    int? attendedByStaffId,
  }) async {
    couponError = null;
    voucherError = null;

    if (cart == null || (cart!.returnItems.isEmpty && cart!.items.isEmpty)) {
      return false;
    }

    manualDiscountAmount ??= double.tryParse(discountController.text.trim());

    attendedByStaffId ??= selectedStaff?.id;

    debugPrint("========== FINAL VALUES ==========");
    debugPrint("Discount Text: ${discountController.text}");
    debugPrint("Parsed Discount: $manualDiscountAmount");
    debugPrint("Selected Staff ID: $attendedByStaffId");
    debugPrint("=================================");

    if (customerPhone != null &&
        customerPhone != "" &&
        customerPhone.trim().length == 10) {
      customerPhone = "+91$customerPhone";
    }
    isLoading = true;
    update();

    final url = "$baseUrl/billing/cart/checkout";

    final Map<String, dynamic> body = {
      "paymentMethod": selectedPaymentMethod,
      "customerName": customerName ?? "",
      "customerPhone": customerPhone ?? "",
      "customerEmail": customerEmail ?? "",
      "customerAddress": customerAddress ?? "",
    };

    if (couponCode != null && couponCode.isNotEmpty) {
      body["couponCode"] = couponCode;
    }

    if (campaignId != null && voucherCount != null) {
      body["campaignId"] = campaignId;
      body["voucherCount"] = voucherCount;
    }

    if (manualDiscountAmount != null) {
      body["manualDiscountAmount"] = manualDiscountAmount;
    }

    if (attendedByStaffId != null) {
      body["attendedByStaffId"] = attendedByStaffId;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data["returnOnly"] ?? false) {
      } else {
        CheckoutData printModel = CheckoutData.fromJson(data);
        PrinterController pctrl = Get.find();
        pctrl.printReceipt(printModel);
        Get.dialog(OrderCompleteDialog(data: printModel));
      }
      clearAllTextControllers();
      clearVoucherSelection();
      selectedStaff = null;
      discountController.clear();
      isLoading = false;
      update();

      return true;
    }

    /// ❌ ERROR HANDLING
    final data = jsonDecode(response.body);

    String errorMessage = "";

    if (data is Map) {
      errorMessage = data["message"] ?? data["error"] ?? "";
    }

    if (errorMessage.toLowerCase().contains("coupon")) {
      couponError = errorMessage;
      voucherError = null;
    } else {
      voucherError = errorMessage.isNotEmpty
          ? errorMessage
          : "Something went wrong";
      couponError = null;
    }

    isLoading = false;
    update();

    return false;
  }

  Future<void> updateCartItemQuantity(int variantId, int quantity) async {
    if (isUpdatingQty) return;

    isUpdatingQty = true;
    final url = "$baseUrl/billing/cart/item/$variantId";
    final body = {"quantity": quantity};
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
      cart = CartModel.fromJson(data);
      update();
    } else {}

    isUpdatingQty = false;
  }

  Future<void> fetchCampaigns() async {
    final response = await http.get(
      Uri.parse("$baseUrl/lucky-draw/campaigns"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List data = [];
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded['data'] != null) {
        data = decoded['data'];
      }
      campaigns = data.map((e) => LuckyDrawCampaign.fromJson(e)).toList();
    } else {
      campaigns = [];
    }

    update();
  }

  Future<void> fetchStaff() async {
    final response = await http.get(
      Uri.parse("$baseUrl/users?role=staff"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List data = decoded is List ? decoded : decoded['data'] ?? [];
      staffList = data.map<StaffModel>((e) => StaffModel.fromJson(e)).toList();
    } else {
      staffList = [];
    }

    update();
  }
}
