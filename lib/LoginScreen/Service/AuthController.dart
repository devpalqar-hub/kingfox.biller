import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/main.dart';


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
        "password": password
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {

      accessToken = data["access_token"];

      userId = data["user"]["id"];
      userName = data["user"]["name"];
      userEmail = data["user"]["email"];
      userRole = data["user"]["role"];
      Get.snackbar("Success", "Login successful");

    } else {

      Get.snackbar("Error", data["message"] ?? "Login failed");

    }

    isLoading = false;
    update();
  }
}