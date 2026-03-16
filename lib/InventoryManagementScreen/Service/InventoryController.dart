import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/InventoryManagementScreen/Model/InventoryAnalytiCSModel.dart';
import 'package:kinfox_biller/main.dart';
import '../Model/InventoryModel.dart';

class InventoryController extends GetxController {
  bool isLoading = false;
  List<InventoryModel> inventories = [];
  InventoryAnalyticsModel? analytics;

  Future<void> getInventory({int branchId = 1, int variantId = 1}) async {
    isLoading = true;
    update();

    final url = "$baseUrl/inventory?&variantId=$variantId";
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

  Future<void> getInventoryAnalytics({int branchId = 1}) async {

    isLoading = true;
    update();

    final url = "$baseUrl/inventory/analytics?branchId=$branchId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      analytics = InventoryAnalyticsModel.fromJson(data);

    } else {

      analytics = null;
    }

    isLoading = false;
    update();
  }
}