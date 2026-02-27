import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:kinfox_biller/InitiateReturnScreen/Services/ReturnFlowController.dart';
import 'package:kinfox_biller/ReturnScreens/Views/OrginalPurchaseList.dart';
import 'package:kinfox_biller/ReturnScreens/Views/OrginalTransationInfo.dart';
import 'package:kinfox_biller/ReturnScreens/Views/ReturnSummaryCard.dart';

class ReturnScreen extends StatelessWidget {
  const ReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Color(0xffF1F5F9),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                        icon: Icon(
                       Icons.arrow_back_ios_new,
                        size: 20.sp,
                    color: const Color(0xff1E293B),
                  ),
                 onPressed: () {
                   Get.find<ReturnFlowController>().backToInitiate();
                    },
                 ),
                     SizedBox(width: 8.w),
                            Text(
                              "Select Items to Return",
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1E293B),
                              ),
                            ),
                           SizedBox(width: 320.w,),
                            Text(
                              "Original Date: Oct 27, 2023",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                       
                         OriginalPurchaseList(),
                      ],
                    ),
                  ),
  
                  SizedBox(width:20.w),
                  ReturnSummaryCard()
                ],
              ),
            ),
            SizedBox(height: 32.h),
            OriginalTransactionInfo(),
          ],
        ),
      ),
    );
  }
}