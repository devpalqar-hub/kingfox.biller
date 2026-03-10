import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/AnalyticsModel.dart';
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/main.dart';


class Historycontroller extends GetxController {
  bool isLoading = false;
  AnalyticsModel? analytics; 
  bool isInvoicesLoading = false;
  List<InvoiceModel> invoices = [];

  
  Future<void> geAnalytics() async {
    isLoading = true;
    update(); 
    final url = "$baseUrl/billing/analytics";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      analytics = AnalyticsModel.fromJson(data);
    } else {
      analytics = null; 
    }

    isLoading = false;
    update();
  }


  Future<void> getInvoices({int branchId = 1, int page = 1, int limit = 20}) async {
    isInvoicesLoading = true;
    update(); 

    final url = "$baseUrl/billing/my-invoices?branchId=$branchId&page=$page&limit=$limit";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200) {
      invoices = invoiceListFromJson(response.body);
    } else {
      invoices = [];
    }

    isInvoicesLoading = false;
    update(); 
  }
}