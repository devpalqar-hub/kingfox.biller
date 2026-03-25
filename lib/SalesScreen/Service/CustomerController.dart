import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/SalesScreen/Model/CustomerModel.dart';
import 'package:kinfox_biller/main.dart';

class CustomerController extends GetxController {
  bool isLoading = false;
  List<CustomerModel> customerList = [];

Future<void> searchCustomers([String query = ""]) async {
  isLoading = true;
  update();

  final url = query.isEmpty
      ? "$baseUrl/customers"
      : "$baseUrl/customers?search=$query";

  print("📡 API REQUEST → $url");

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );

  print("✅ STATUS CODE → ${response.statusCode}");
  print("📦 RESPONSE BODY → ${response.body}");

  customerList.clear();

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data is List) {
      customerList = data
          .map<CustomerModel>((e) => CustomerModel.fromJson(e))
          .toList();
    } else if (data['data'] != null) {
      customerList = (data['data'] as List)
          .map<CustomerModel>((e) => CustomerModel.fromJson(e))
          .toList();
    }
  } else {
    print("❌ API ERROR → ${response.statusCode}");
  }

  print("👥 CUSTOMERS FOUND → ${customerList.length}");

  isLoading = false;
  update();
}}