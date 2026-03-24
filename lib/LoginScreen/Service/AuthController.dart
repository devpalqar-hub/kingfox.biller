import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinfox_biller/main.dart';
import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/LoginScreen/LognScreen.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  bool _loginCheckCompleted = false;

  String userId = "";
  String userName = "";


  @override
  void onInit() async {
    super.onInit();
    
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getString("userId") ?? "";
    userName = prefs.getString("userName") ?? "";
    
    // Perform login check only once, after first frame is rendered
    if (!_loginCheckCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await checkLogin();
        _loginCheckCompleted = true;
      });
    }
    
    update();
  }


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
    
      final prefs = await SharedPreferences.getInstance();

      /// ✅ STORE EVERYTHING
      await prefs.setString("accessToken", accessToken!);
      await prefs.setString("userId", userId);
      await prefs.setString("userName", userName);
      

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

    if (savedToken == null || savedToken.isEmpty) {
      Get.offAll(() => LoginScreen());
      return;
    }

    accessToken = savedToken;

    final response = await http.get(
      Uri.parse("$baseUrl/auth/profile"),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      Get.offAll(() => Dashboardscreen());
    } else {
      await logout();
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
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