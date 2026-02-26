import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/DashBoard/Service/DashBoardController.dart';
import 'package:kinfox_biller/DashBoard/Views/Header.dart';
import 'package:kinfox_biller/SalesScreen/SalesScreen.dart';

class Dashboardscreen extends StatelessWidget {
  Dashboardscreen({super.key});

  final controller = Get.put(DashboardController());

  final pages = const [
    SalesScreen(),
    //OverviewScreen(),
    //InventoryScreen(),
    //ReturnsScreen(),
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