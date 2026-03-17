import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Model/ReturnModel.dart';

import 'package:kinfox_biller/main.dart'; 

class ReturnsController extends GetxController {
  var isLoading = false;
List<ReturnModel> returnsList = [];



  InvoiceModel? invoice;

  List<InvoiceModel> recentInvoices = [];
  Set<int> selectedItems = {};

  void toggleItemSelection(int variantId) {
    if (selectedItems.contains(variantId)) {
      selectedItems.remove(variantId);
    } else {
      selectedItems.add(variantId);
    }
    update(); 
  }

  bool isItemSelected(int variantId) {
    return selectedItems.contains(variantId);
  }


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

  // Log response info
  print("📥 Response Status Code: ${response.statusCode}");
  print("📥 Response Headers: ${response.headers}");
  print("📥 Response Body: ${response.body}");

  final data = jsonDecode(response.body);
  returnsList = (data as List).map((e) => ReturnModel.fromJson(e)).toList();

  isLoading = false;
  update();
}

  Future createReturn({
  required int invoiceId,
  required int variantId,
  required int quantity,
  required String reason,
  required String returnType,
}) async {
  isLoading = true;
  update();

  final url = "$baseUrl/returns";

  final body = {
    "returnType": returnType,
    "invoiceId": invoiceId,
    "onlineOrderId": null,
    "reason": reason,
    "items": [
      {
        "variantId": variantId,
        "quantity": quantity
      }
    ]
  };

  // Log request
  print("📤 POST Request URL: $url");
  print("📤 Request Headers: {Content-Type: application/json, Authorization: Bearer $accessToken}");
  print("📤 Request Body: ${jsonEncode(body)}");

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
    body: jsonEncode(body),
  );

  // Log response
  print("📥 Response Status Code: ${response.statusCode}");
  print("📥 Response Headers: ${response.headers}");
  print("📥 Response Body: ${response.body}");

  if (response.statusCode == 201 || response.statusCode == 200) {
    getReturns();
    Get.snackbar("Success", "Return created successfully");
  } else {
    Get.snackbar("Error", "Failed to create return");
  }

  isLoading = false;
  update();
}

  Future<void> getInvoice(String invoiceId) async {
  isLoading = true;
  update();

  final url = "$baseUrl/invoices/$invoiceId"; 

  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $accessToken",
  };

  // Log request
  print("📤 GET Request URL: $url");
  print("📤 Request Headers: $headers");

  final response = await http.get(Uri.parse(url), headers: headers);

  // Log response
  print("📥 Response Status Code: ${response.statusCode}");
  print("📥 Response Headers: ${response.headers}");
  print("📥 Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    invoice = InvoiceModel.fromJson(data);
    print("✅ Invoice fetched successfully: ${invoice?.id}");
  } else {
    invoice = null;
    final data = jsonDecode(response.body);
    print("⚠️ API Error: ${data['message']}");
  }

  isLoading = false;
  update();
}
 
}