import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/ReturnHistoryScreen/Model/ReturnModel.dart';

import 'package:kinfox_biller/main.dart'; 

class ReturnsController extends GetxController {
  var isLoading = false;
  var returnsList = <ReturnModel>[].obs;

  Future getReturns() async {
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

    final data = jsonDecode(response.body);
    returnsList.value = (data as List).map((e) => ReturnModel.fromJson(e)).toList();

    isLoading = false;
    update(); 
  }


  Future createReturn({
    required int invoiceId,
    required int variantId,
    required int quantity,
    required String reason,
  }) async {

    isLoading = true;
    update();

    final url = "$baseUrl/returns";

    final body = {
      "returnType": "INVOICE",
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

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      getReturns();
      Get.snackbar("Success", "Return created successfully");
    } else {
      Get.snackbar("Error", "Failed to create return");
    }

    isLoading = false;
    update();
  }
}