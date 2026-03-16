import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:kinfox_biller/ReturnScreens/Service/ReturnController.dart';
import 'package:kinfox_biller/ReturnScreens/Views/OrginalPurchaseList.dart';
import 'package:kinfox_biller/ReturnScreens/Views/OrginalTransationInfo.dart';
import 'package:kinfox_biller/ReturnScreens/Views/ReturnSummaryCard.dart';

class ReturnScreen extends StatelessWidget {
  const ReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {

    

    return GetBuilder<ReturnController>(
      builder: (controller) {

        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          color: const Color(0xffF1F5F9),
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// LEFT SECTION
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// HEADER
                        Row(
                          children: [

                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                size: 20.sp,
                                color: const Color(0xff1E293B),
                              ),
                              onPressed: () {
                                Get.back();
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

                            SizedBox(width: 320.w),

                            /// INVOICE NUMBER FROM API
                            Text(
                              "Invoice: ${controller.invoice?.invoiceNumber ?? ""}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        /// PURCHASE ITEMS LIST
                        const OriginalPurchaseList(),
                      ],
                    ),

                    SizedBox(width: 20.w),

                    /// RETURN SUMMARY
                    const ReturnSummaryCard(),
                  ],
                ),

                SizedBox(height: 32.h),

                /// TRANSACTION INFO
                const OriginalTransactionInfo(),
              ],
            ),
          ),
        );
      },
    );
  }
}