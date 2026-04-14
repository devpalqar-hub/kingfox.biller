import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/LuckyDrawModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/ProductModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/StaffModel.dart';
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
  CartModel? completedOrder;
  String? invoiceNumber;

  List items = [];
  List<ProductVariantModel> searchProductsList = [];

  String appliedCoupon = "";

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final voucherCountController = TextEditingController();
  final couponController = TextEditingController();
  final discountController = TextEditingController();

  void clearAllTextControllers() {
    nameController.clear();
    phoneController.clear();
    voucherCountController.clear();
    couponController.clear();
    discountController.clear();
  }

  void clearVoucherSelection() {
    campaigns.clear();
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
        "barcode": barcode,
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

    final queryParams = <String, String>{};

    if (applied.isNotEmpty) {
      queryParams['couponCode'] = applied;
    }

    if (manualDiscountAmount != null && manualDiscountAmount > 0) {
      queryParams['manualDiscountAmount'] = manualDiscountAmount.toString();
    }

    final uri = Uri.parse(
      "$baseUrl/billing/cart",
    ).replace(queryParameters: queryParams);

    final headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      cart = CartModel.fromJson(data);
      appliedCoupon = applied;

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

    if (cart == null || cart!.items.isEmpty) {
      return false;
    }

    if (couponCode != null && couponCode.isNotEmpty) {
      if ((cart?.couponDiscountAmount ?? 0) == 0) {
        couponError = "Invalid or expired coupon";
        update();
        return false;
      }
    }

    if (campaignId != null && voucherCount != null) {
      if (voucherCount <= 0) {
        voucherError = "Invalid voucher count";
        update();
        return false;
      }

      if (selectedCampaign == null) {
        voucherError = "Please select a campaign";
        update();
        return false;
      }
    }

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

    if (couponCode != null && couponCode.isNotEmpty) {
      body["couponCode"] = couponCode;
    }

    if (campaignId != null && voucherCount != null) {
      body["campaignId"] = campaignId;
      body["voucherCount"] = voucherCount;
    }

    if (manualDiscountAmount != null && manualDiscountAmount > 0) {
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
      couponError = null;
      voucherError = null;

      final data = jsonDecode(response.body);

      completedOrder = CartModel.fromJson(data["data"] ?? data);
      invoiceNumber = data["invoiceNumber"] ?? data["invoice_number"];

      clearAllTextControllers();
      clearVoucherSelection();

      isLoading = false;
      update();

      return true;
    }

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

      for (var item in cart!.items) {}

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
