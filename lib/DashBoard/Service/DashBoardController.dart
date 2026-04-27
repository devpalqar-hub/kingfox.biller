import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:kinfox_biller/Dashboard/Models/BranchModel.dart';
import 'package:kinfox_biller/LoginScreen/LognScreen.dart';
import 'package:kinfox_biller/main.dart';

class DashboardController extends GetxController {
  int currentTab = 0;

  @override
  void onInit() {
    currentTab = 0;
    super.onInit();
  }

  void changeTab(int index) {
    currentTab = index;
    update();
  }

  void resetTab() {
    currentTab = 0;
    // update();
  }
  
}
