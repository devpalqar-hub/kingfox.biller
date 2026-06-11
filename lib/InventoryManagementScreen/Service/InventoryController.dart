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

  void logMsg(String msg) {}

  Future<void> getInventory({
    bool refresh = false,
    String? stockStatus,
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

    final queryParams = {"page": "$page", "limit": "$limit"};

    /// ✅ STOCK FILTER
    if (stockStatus != null && stockStatus.isNotEmpty) {
      queryParams["stockStatus"] = stockStatus;
    }

    /// 🔥 SEARCH FIX
    if (search != null && search.isNotEmpty) {
      queryParams["search"] = search;
    }

    final uri = Uri.parse(
      "$baseUrl/inventory",
    ).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List data = decoded['data'] ?? [];
        final pagination = decoded['pagination'];

        if (data.isEmpty) {
          hasMore = false;
        } else {
          final newItems = data.map((e) => InventoryModel.fromJson(e)).toList();

          inventories.addAll(
            newItems.where((item) => !inventories.any((i) => i.id == item.id)),
          );

          if (pagination != null) {
            int currentPage = pagination['page'] ?? page;
            int totalPages = pagination['totalPages'] ?? page;

            hasMore = currentPage < totalPages;
          } else {
            if (data.length < limit) hasMore = false;
          }

          page++;
        }
      }
    } catch (e) {}

    isLoading = false;
    isLoadMore = false;
    update();
  }

  /// ================= ANALYTICS =================
  Future<void> getInventoryAnalytics() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/inventory/analytics"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        analytics = InventoryAnalyticsModel.fromJson(jsonDecode(response.body));
      } else {}
    } catch (e) {}

    update();
  }
}
