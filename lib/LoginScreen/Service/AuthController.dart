import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinfox_biller/main.dart';
import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/LoginScreen/LognScreen.dart';

class AuthController extends GetxController {
  bool isLoading = false;

  String userId = "";
  String userName = "";
  String userEmail = "";
  String userRole = "";

  Future<void> login(String email, String password) async {
    isLoading = true;
    update();

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      accessToken = data["access_token"];

      userId = data["user"]["id"].toString();
      userName = data["user"]["name"] ?? "";
      userEmail = data["user"]["email"] ?? "";
      userRole = data["user"]["role"] ?? "";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", accessToken!);

      Get.offAll(() => Dashboardscreen());
    } else {
      String errorMessage = "Login failed";

      if (data["message"] != null) {
        if (data["message"] is List) {
          errorMessage = data["message"].join(", ");
        } else {
          errorMessage = data["message"].toString();
        }
      }

      Get.snackbar("Error", errorMessage);
    }

    isLoading = false;
    update();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedToken = prefs.getString("accessToken");

    if (savedToken != null && savedToken.isNotEmpty) {
      accessToken = savedToken;
      Get.offAll(() => Dashboardscreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("accessToken");

    accessToken = null;

    Get.offAll(() => LoginScreen());
  }

  void handleUnauthorized(int statusCode) {
    if (statusCode == 401) {
      logout();

      Get.snackbar(
        "Session Expired",
        "Please login again",
      );
    }
  }
}