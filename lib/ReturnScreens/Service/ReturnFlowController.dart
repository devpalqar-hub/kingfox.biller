import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/main.dart';

class ReturnFlowController extends GetxController {

  bool showReturnScreen = false;
  bool isLoading = false;

  InvoiceModel? invoice;
  List<InvoiceModel> recentInvoices = [];

  @override
  void onInit() {
    super.onInit();
    getRecentInvoices();
  }

  void startReturn() {
    showReturnScreen = true;
    update();
  }

  void backToInitiate() {
    showReturnScreen = false;
    update();
  }

  Future<void> getRecentInvoices() async {

    isLoading = true;
    update();

    final url = "$baseUrl/returns/recent-invoices";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      recentInvoices =
          data.map((e) => InvoiceModel.fromJson(e)).toList();

    } else {
      recentInvoices = [];
    }

    isLoading = false;
    update();
  }
}