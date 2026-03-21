import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/AnalyticsModel.dart';
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/main.dart';

class Historycontroller extends GetxController {
  bool isLoading = false;
  bool isInvoicesLoading = false;
  bool hasMore = true;
  bool isLoadMore = false;
  
  int page = 1;
  final int limit = 20;

  AnalyticsModel? analytics;
  List<InvoiceModel> invoices = [];

  
   


  //......get analytics.....

  Future<void> geAnalytics() async {
    isLoading = true;
    update();

    final response = await http.get(
      Uri.parse("$baseUrl/billing/analytics"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      analytics = AnalyticsModel.fromJson(jsonDecode(response.body));
    } else {
      analytics = null;
    }

    isLoading = false;
    update();
  }
 
//...get invoices.....
Future<void> getInvoices({bool refresh = false}) async {
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

  final url = "$baseUrl/billing/my-invoices?page=$page&limit=$limit";
  final response = await http.get(
    Uri.parse(url),
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
        data.map((e) => InvoiceModel.fromJson(e)).toList(),
      );
      page++;
    }
  } else {
   
  }
  isLoading = false;
  isLoadMore = false;
  update();
}
}