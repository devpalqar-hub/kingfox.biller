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

  String? loginError;

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

  void clearLoginError() {
    if (loginError == null) return;
    loginError = null;
    update();
  }

  Future<void> login(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      loginError = 'Enter staff ID and password';
      update();
      return;
    }

    isLoading = true;
    loginError = null;
    update();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": trimmedEmail, "password": trimmedPassword}),
      );

      final dynamic data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        userId = data["user"]["id"].toString();
        userName = data["user"]["name"] ?? "";

        final roleRaw = data["user"]["role"];
        final role = (roleRaw ?? '').toString().trim().toLowerCase();

        final prefs = await SharedPreferences.getInstance();

        if (role == "cashier") {
          accessToken = data["access_token"];
          await prefs.setString("accessToken", accessToken!);
          await prefs.setString("userId", userId);
          await prefs.setString("userName", userName);
          await prefs.setString("userRole", role);

          Get.offAll(() => Dashboardscreen());
        } else {
          // Ensure a non-cashier cannot enter via stale token.
          accessToken = null;
          await prefs.remove("accessToken");
          await prefs.remove("userRole");
          loginError = "Please login as cashier";
        }
      } else {
        String errorMessage = "Login failed";

        if (data is Map && data["message"] != null) {
          final msg = data["message"];
          if (msg is List) {
            errorMessage = msg.join(", ");
          } else {
            errorMessage = msg.toString();
          }
        }

        loginError = errorMessage;
      }
    } catch (_) {
      loginError = 'Login failed. Check your connection and try again.';
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedToken = prefs.getString("accessToken");
    final savedRole = (prefs.getString("userRole") ?? '').trim().toLowerCase();

    if (savedToken == null || savedToken.isEmpty || savedRole != 'cashier') {
      await prefs.remove("accessToken");
      await prefs.remove("userRole");
      Get.offAll(() => LoginScreen());
      return;
    }

    accessToken = savedToken;

    final response = await http.get(
      Uri.parse("$baseUrl/auth/profile"),
      headers: {"Authorization": "Bearer $accessToken"},
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
    Get.deleteAll();
    Get.offAll(() => LoginScreen());
  }

  void handleUnauthorized(int statusCode) {
    if (statusCode == 401) {
      logout();
    }
  }
}
