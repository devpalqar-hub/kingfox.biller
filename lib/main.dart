import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/LoginScreen/LognScreen.dart';

void main() {
  runApp(KingfoxBiller());
}

class KingfoxBiller extends StatelessWidget {
  KingfoxBiller({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
       designSize:  Size(1280, 832),
       child: GetMaterialApp(theme: 
       ThemeData(fontFamily: "Inter"),
       home: LoginScreen(), ));
  }
}
