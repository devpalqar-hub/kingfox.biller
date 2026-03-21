import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/InventoryManagementScreen/Model/InventoryAnalytiCSModel.dart';
import 'package:kinfox_biller/main.dart';
import '../Model/InventoryModel.dart';

class InventoryController extends GetxController {
  bool isLoading = false;
  bool isLoadMore = false;
  bool hasMore = true;

  int page = 1;
  int limit = 20;

  List<InventoryModel> inventories = [];
  InventoryAnalyticsModel? analytics;
  String selectedFilter = "All";

  /// ================= INVENTORY PAGINATION =================
  Future<void> getInventory({
  bool refresh = false,
  String? stockStatus, // LOW_STOCK / OUT_OF_STOCK
}) async {
  if (refresh) {
    page = 1;
    hasMore = true;
    inventories.clear();
  }

  if (isLoadMore || !hasMore) return;

  if (page == 1) {
    isLoading = true;
  } else {
    isLoadMore = true;
  }

  update();

  final queryParams = {
    "page": "$page",
    "limit": "$limit",
  };

  /// 🔥 FILTER PARAM
  if (stockStatus != null && stockStatus.isNotEmpty) {
    queryParams["stockStatus"] = stockStatus;
  }

  final uri = Uri.parse("$baseUrl/inventory")
      .replace(queryParameters: queryParams);

  print("📤 REQUEST: $uri");

  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
  );

  print("📥 RESPONSE: ${response.body}");

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    List data = [];

    if (decoded is List) {
      data = decoded;
    } else if (decoded is Map && decoded['data'] != null) {
      data = decoded['data'];
    }

    if (data.isEmpty) {
      hasMore = false;
    } else {
      inventories.addAll(
        data.map((e) => InventoryModel.fromJson(e)).toList(),
      );
      page++;
    }
  }

  isLoading = false;
  isLoadMore = false;
  update();
}

  /// ================= ANALYTICS =================
  Future<void> getInventoryAnalytics() async {
    isLoading = true;
    update();

    final url = "$baseUrl/inventory/analytics";

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