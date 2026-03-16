import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/ReturnScreens/InititateReturnScreen/Views/InitiateReturnCard.dart';
import 'package:kinfox_biller/ReturnScreens/InititateReturnScreen/Views/RecentInvoiceSection.dart';
import 'package:kinfox_biller/ReturnScreens/ReturnScreen.dart';
import 'package:kinfox_biller/ReturnScreens/Service/ReturnFlowController.dart';

class InitiateReturnScreen extends StatefulWidget {
  InitiateReturnScreen({super.key});

  @override
  State<InitiateReturnScreen> createState() => _InitiateReturnScreenState();
}

class _InitiateReturnScreenState extends State<InitiateReturnScreen> {

  final ReturnFlowController controller = Get.put(ReturnFlowController());
 @override
  void initState() {
    super.initState();
    
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      body: SafeArea(
        child: GetBuilder<ReturnFlowController>(
         
          builder: (controller) {

            if (controller.showReturnScreen && controller.invoice != null) {
              return ReturnScreen();
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: InitiateReturnCard(),
                  ),
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