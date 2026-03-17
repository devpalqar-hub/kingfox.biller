import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/LoginScreen/LognScreen.dart';

String baseUrl = "https://api.kingfox.palqar.cloud/v1";
String? accessToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  accessToken = prefs.getString("accessToken");

  runApp(KingfoxBiller());
}

class KingfoxBiller extends StatelessWidget {
  KingfoxBiller({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(1280, 832),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Inter"),

        /// If token exists → open dashboard
        /// If not → login screen
        home: accessToken != null
            ? Dashboardscreen()
            : LoginScreen(),
      ),
    );
  }
}