import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/main.dart';
import '../Model/InventoryModel.dart';

class InventoryController extends GetxController {
  bool isLoading = false;
  List<InventoryModel> inventories = [];

  Future<void> getInventory({int branchId = 1, int variantId = 1}) async {
    isLoading = true;
    update();

    final url = "$baseUrl/inventory?branchId=$branchId&variantId=$variantId";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      inventories = data.map((e) => InventoryModel.fromJson(e)).toList();
    } else {
      inventories = [];
    }

    isLoading = false;
    update();
  }
}