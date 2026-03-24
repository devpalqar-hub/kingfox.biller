import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/DashBoard/Service/DashBoardController.dart';
import 'package:kinfox_biller/DashBoard/Views/Header.dart';
import 'package:kinfox_biller/LoginScreen/Service/AuthController.dart';
import 'package:kinfox_biller/ReturnHistoryScreens/InititateReturnScreen/InitiateReturnScreen.dart';
import 'package:kinfox_biller/InventoryManagementScreen/InventoryManagementScreen.dart';
import 'package:kinfox_biller/OverViewScreen/OverViewScreen.dart';
import 'package:kinfox_biller/SalesScreen/SalesScreen.dart';

class Dashboardscreen extends StatelessWidget {
  Dashboardscreen({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final AuthController authController = Get.put(AuthController());

  final pages = [
    SalesScreen(),
    const OverviewScreen(),
    const InventoryManagementScreen(),
   // const InitiateReturnScreen(),
  ];

  @override
  Widget build(BuildContext context) {

 
    return Scaffold(
      body: Column(
        children: [

          const Header(),

          Expanded(
            child: GetBuilder<DashboardController>(
              builder: (controller) {
                return pages[controller.currentTab];
              },
            ),
          ),
        ],
      ),
    );
  }
}