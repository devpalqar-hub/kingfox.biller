import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OnlineScreen/Model/pickup_analytics_model.dart';
import 'package:kinfox_biller/OnlineScreen/Model/pickup_order_model.dart';
import 'package:kinfox_biller/main.dart';

class PickupOrdersController extends GetxController {
  bool isLoading = false;
  bool isLoadMore = false;

  List<PickupOrder> orders = [];
  PickupAnalytics? analytics;
  bool isAnalyticsLoading = false;

  int page = 1;
  int totalPages = 1;

  String? selectedStatus;

  @override
  @override
  void onInit() {
    super.onInit();

    fetchOrders();
    fetchAnalytics();
  }

  Future<void> fetchOrders({bool loadMore = false}) async {
    if (loadMore) {
      isLoadMore = true;
    } else {
      isLoading = true;
    }
    update();

    String url = "$baseUrl/billing/pickup-orders?page=$page&limit=20";

    if (selectedStatus != null) {
      url += "&status=$selectedStatus";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final result = PickupOrdersResponse.fromJson(data);

      if (loadMore) {
        orders.addAll(result.data);
      } else {
        orders = result.data;
      }

      totalPages = result.pagination.totalPages;
    } else {}

    isLoading = false;
    isLoadMore = false;
    update();
  }

  Future<void> fetchAnalytics() async {
    isAnalyticsLoading = true;
    update();

    final url = "$baseUrl/billing/pickup-orders/analytics";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      analytics = PickupAnalytics.fromJson(data);
    } else {}

    isAnalyticsLoading = false;
    update();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final url = "$baseUrl/billing/pickup-orders/$orderId/status";

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode == 200) {
      page = 1;
      orders.clear();
      await fetchOrders();
      await fetchAnalytics();
    } else {}
  }

  void changeStatus(String? status) {
    selectedStatus = status;
    page = 1;
    orders.clear();
    fetchOrders();
  }

  void loadMore() {
    if (page < totalPages && !isLoadMore) {
      page++;
      fetchOrders(loadMore: true);
    }
  }

  Future<void> refreshOrders() async {
    page = 1;
    orders.clear();
    await fetchOrders();
  }
}
