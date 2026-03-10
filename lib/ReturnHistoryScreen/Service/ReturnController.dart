import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/ReturnHistoryScreen/Model/ReturnModel.dart';

import 'package:kinfox_biller/main.dart'; 

class ReturnsController extends GetxController {
  var isLoading = false;
  var returnsList = <ReturnModel>[].obs;

  Future getReturns() async {
    isLoading = true;
    update();

    final url = "$baseUrl/returns?branchId=1&type=INVOICE";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    final data = jsonDecode(response.body);
    returnsList.value = (data as List).map((e) => ReturnModel.fromJson(e)).toList();

    isLoading = false;
    update(); 
  }
}