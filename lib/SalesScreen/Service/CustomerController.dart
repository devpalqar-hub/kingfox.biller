import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/SalesScreen/Model/CustomerModel.dart';
import 'package:kinfox_biller/main.dart';

class CustomerController extends GetxController {
  bool isLoading = false;

  List<CustomerModel> customerList = [];

  bool isDropdownOpen = false;

  CustomerModel? selectedCustomer;

  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;


    if (isDropdownOpen && customerList.isEmpty) {
      searchCustomers();
    }

    update();
  }

  void closeDropdown() {
    isDropdownOpen = false;
    customerList.clear();
    update();
  }

  Future<void> searchCustomers([String query = ""]) async {
    isLoading = true;

    isDropdownOpen = true;
    update();

    final url = query.isEmpty
        ? "$baseUrl/customers"
        : "$baseUrl/customers?search=$query";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

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
    }

    isLoading = false;
    update();
  }
}