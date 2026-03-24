import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/InventoryManagementScreen/Model/InventoryAnalytiCSModel.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Model/InventoryModel.dart';
import 'package:kinfox_biller/main.dart';


class InventoryController extends GetxController {
  bool isLoading = false;
  bool isLoadMore = false;
  bool hasMore = true;

  int page = 1;
  int limit = 20;

  List<InventoryModel> inventories = [];
  InventoryAnalyticsModel? analytics;

  String selectedFilter = "All";
  String searchQuery = "";

  /// ================= INVENTORY =================
  Future<void> getInventory({
    bool refresh = false,
    String? stockStatus,
  }) async {
    if (refresh) {
      page = 1;
      hasMore = true;
      inventories.clear();
    }

    if (isLoadMore || !hasMore) return;

    page == 1 ? isLoading = true : isLoadMore = true;
  //  update();

    final queryParams = {
      "page": "$page",
      "limit": "$limit",
    };

    if (stockStatus != null && stockStatus.isNotEmpty) {
      queryParams["stockStatus"] = stockStatus;
    }

    final uri =
        Uri.parse("$baseUrl/inventory").replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List data = decoded is List
          ? decoded
          : (decoded['data'] ?? []);

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

  /// ================= SEARCH =================
  Future<void> getInventoryBySearch({
  bool refresh = false,
  String? search,
}) async {
  if (refresh) {
    page = 1;
    hasMore = true;
    inventories.clear();
  }

  if (isLoadMore || !hasMore) return;

  page == 1 ? isLoading = true : isLoadMore = true;
  update();

  if (search != null) {
    searchQuery = search;
  }

  if (searchQuery.isEmpty) {
    isLoading = false;
    isLoadMore = false;
    update();
    return;
  }

  final queryParams = {
    "search": searchQuery,
    "page": "$page",
    "limit": "$limit",
  };

  /// 🔥 OPTIONAL FILTER SUPPORT
  if (selectedFilter == "Low Stock") {
    queryParams["stockStatus"] = "LOW_STOCK";
  } else if (selectedFilter == "Out of Stock") {
    queryParams["stockStatus"] = "OUT_OF_STOCK";
  }

  final uri = Uri.parse("$baseUrl/products/variants")
      .replace(queryParameters: queryParams);

  final response = await http.get(
    uri,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    List data = decoded is List
        ? decoded
        : (decoded['data'] ?? []);

    if (data.isEmpty) {
      hasMore = false;
    } else {
      inventories.addAll(
        data.map((e) => InventoryModel.fromSearchJson(e)).toList(),
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
    final response = await http.get(
      Uri.parse("$baseUrl/inventory/analytics"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      analytics = InventoryAnalyticsModel.fromJson(
        jsonDecode(response.body),
      );
    }

    update();
  }
}