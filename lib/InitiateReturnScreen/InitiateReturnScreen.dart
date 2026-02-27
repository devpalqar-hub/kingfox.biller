import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/InitiateReturnScreen/Services/ReturnFlowController.dart';
import 'package:kinfox_biller/InitiateReturnScreen/Views/InitiateReturnCard.dart';
import 'package:kinfox_biller/InitiateReturnScreen/Views/RecentInvoiceSection.dart';
import 'package:kinfox_biller/ReturnScreens/ReturnScreen.dart';

class InitiateReturnScreen extends StatelessWidget {
  InitiateReturnScreen({super.key});

  final controller = Get.put(ReturnFlowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      body: SafeArea(
        child: GetBuilder<ReturnFlowController>(
          builder: (controller) {
            if (controller.showReturnScreen) {
              return const ReturnScreen();
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: InitiateReturnCard()),
                  SizedBox(height: 30.h),
                  const RecentInvoicesSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}