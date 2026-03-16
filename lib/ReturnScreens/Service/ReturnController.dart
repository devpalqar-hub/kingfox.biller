import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/main.dart';

class ReturnController extends GetxController {

  bool isLoading = false;

  InvoiceModel? invoice;

  List<InvoiceModel> recentInvoices = [];

 
  Future<void> getInvoice(int id) async {

    isLoading = true;
    update();

    final url = "$baseUrl/invoices/$id";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      invoice = InvoiceModel.fromJson(data);

    }

    isLoading = false;
    update();
  }


 
}