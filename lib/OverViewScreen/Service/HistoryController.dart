import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/AnalyticsModel.dart';
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/SalesScreen/Model/CheckoutModel.dart';
import 'package:kinfox_biller/main.dart';

class Historycontroller extends GetxController {
  bool isLoading = false;
  bool isInvoicesLoading = false;
  bool hasMore = true;
  bool isLoadMore = false;
  
  int page = 1;
  final int limit = 20;

  AnalyticsModel? analytics;
  List<CheckoutData> invoices = [];
  String searchQuery = "";

  
 Future<void> geAnalytics({
  String? fromDate,
  String? toDate,
}) async {
  isLoading = true;
  update();


  final queryParams = <String, String>{};

  if (fromDate != null && fromDate.isNotEmpty) {
    queryParams['from'] = fromDate;
  }

  if (toDate != null && toDate.isNotEmpty) {
    queryParams['to'] = toDate;
  }

  final uri = Uri.parse(
    "$baseUrl/billing/analytics",
  ).replace(queryParameters: queryParams);

  final response = await http.get(
    uri,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );


  if (response.statusCode == 200) {
    analytics = AnalyticsModel.fromJson(
      jsonDecode(response.body),
    );
  } else {
    analytics = null;
  }

  isLoading = false;
  update();
}


Future<void> getInvoices({
  bool refresh = false,
  String? status,
  String? from,
  String? to,
  String?search,
}) async {
  if (refresh) {
    page = 1;
    hasMore = true;
    invoices.clear();
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
    if (status != null) "status": status,
    if (from != null) "from": from,
    if (to != null) "to": to,
     if (search != null && search.isNotEmpty) "search": search,
  };

  final uri = Uri.parse("$baseUrl/billing/my-invoices")
      .replace(queryParameters: queryParams);

  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    },
  );

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
      invoices.addAll(
        data.map((e) => CheckoutData.fromJson(e)).toList(),
      );
      page++;
    }
  }

  isLoading = false;
  isLoadMore = false;
  update();
}
}