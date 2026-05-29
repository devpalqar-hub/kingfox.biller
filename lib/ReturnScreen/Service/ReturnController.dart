import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/ReturnScreen/Model/ReturnModel.dart';
import 'package:kinfox_biller/ReturnHistoryScreens/Model/InvoiceModel.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';
import 'package:kinfox_biller/main.dart';

class ReturnsController extends GetxController {
  var isLoading = false;

  List<ReturnModel> returnsList = [];
  Map<int, int> returnQty = {};

  InvoiceModel? invoice;

  String? selectedReason;

  final TextEditingController internalNoteController = TextEditingController();

  /// ================= REASONS =================
  List<String> returnReasons = [
    "Sizing issue / Too large",
    "Sizing issue / Too small",
    "Damaged item",
    "Defective product",
    "Wrong item delivered",
    "Quality not as expected",
    "Item no longer needed",
    "Changed mind",
    "Received late",
    "Other",
  ];

  Set<int> selectedItems = {};

  @override
  void onInit() {
    super.onInit();
    selectedReason = null;
    update();
  }

  void clearReturnData() {
    selectedItems.clear();
    returnQty.clear();
    selectedReason = null;
    invoice = null;
    internalNoteController.clear();
    update();
  }

  void toggleItemSelection(int variantId) {
    if (selectedItems.contains(variantId)) {
      selectedItems.remove(variantId);
      returnQty.remove(variantId);
    } else {
      selectedItems.add(variantId);
      returnQty[variantId] = 1;
    }
    update();
  }

  bool isItemSelected(int variantId) {
    return selectedItems.contains(variantId);
  }

  double get totalReturnAmount {
    double total = 0.0;

    if (invoice == null) return 0.0;

    for (var variantId in selectedItems) {
      final item = invoice!.items.firstWhere((e) => e.variantId == variantId);

      final qty = returnQty[variantId] ?? 1;
      final price = double.tryParse(item.price.toString()) ?? 0.0;

      total += qty * price;
    }

    return total;
  }

  void increaseQty(int variantId, int maxQty) {
    if (maxQty <= 0) return;

    returnQty[variantId] = (returnQty[variantId] ?? 1);

    if (returnQty[variantId]! < maxQty) {
      returnQty[variantId] = returnQty[variantId]! + 1;
      update();
    }
  }

  void decreaseQty(int variantId) {
    returnQty[variantId] = (returnQty[variantId] ?? 1);

    if (returnQty[variantId]! > 1) {
      returnQty[variantId] = returnQty[variantId]! - 1;
      update();
    }
  }

  /// ......get returns
  Future<void> getReturns() async {
    isLoading = true;
    update();

    final url = "$baseUrl/returns?type=INVOICE";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      returnsList = (data as List).map((e) => ReturnModel.fromJson(e)).toList();
    }

    isLoading = false;
    update();
  }

  bool addingItemLoading = false;

  Future<bool> addReturnItemsToCart() async {
    if (addingItemLoading) {
      return false;
    }
    addingItemLoading = true;

    if (invoice == null) {
      return false;
    }

    if (selectedItems.isEmpty) {
      return false;
    }

    final items = selectedItems.map((variantId) {
      return {"variantId": variantId, "quantity": returnQty[variantId] ?? 1};
    }).toList();
    int? sessionId = Get.find<AddProductController>().selectedSessionId;
    final url =
        "$baseUrl/billing/cart/return-items?billingSessionId=${sessionId}";

    final body = {"originalInvoiceId": invoice!.id, "items": items};

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    addingItemLoading = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      await getReturns();

      await Get.find<AddProductController>().getCart();
      clearReturnData();
      return true;
    } else {
      return false;
    }
  }

  /// ================= GET INVOICE =================
  Future<void> getInvoice(String invoiceId) async {
    isLoading = true;
    update();

    final url = "$baseUrl/invoices/$invoiceId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] != "CANCELLED") invoice = InvoiceModel.fromJson(data);
    } else {
      invoice = null;
    }

    isLoading = false;
    update();
  }

  Future<bool> deleteReturnItemsFromCart(List<int> variantIds) async {
    int? sessionId = Get.find<AddProductController>().selectedSessionId;

    if (variantIds.isEmpty) {
      return false;
    }

    final url =
        "$baseUrl/billing/cart/return-items?billingSessionId=${sessionId}";

    final body = {
      "variantIds": variantIds, // 👈 send list of ids to delete
    };

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body), // 👈 important (some APIs need body)
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await getReturns(); // refresh list
      return true;
    } else {
      return false;
    }
  }
}
