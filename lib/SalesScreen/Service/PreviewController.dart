import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/SalesScreen/Model/PreviewModel.dart';
import 'package:kinfox_biller/main.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';

class PreviewController extends GetxController {
  bool isLoading = false;

  PreviewModel? preview;

  Future<void> getPreview({
    required List<CartItemModel> cartItems,
    String? couponCode,
    int gstPercent = 5,
  }) async {
    isLoading = true;
    update();

    final url = "$baseUrl/billing/preview";

 
    final items = cartItems.map((e) {
      return {
        "variantId": e.variantId,
        "quantity": e.quantity,
      };
    }).toList();

    final body = {
      "items": items,
      "couponCode": couponCode ?? "",
      "gstPercent": gstPercent,
    };
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
      preview = PreviewModel.fromJson(data);
    } else {
      preview = null;
    }

    isLoading = false;
    update();
  }
}