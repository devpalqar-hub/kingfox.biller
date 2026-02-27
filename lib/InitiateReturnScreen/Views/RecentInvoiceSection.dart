import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:kinfox_biller/InitiateReturnScreen/Views/InvoiceCard.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/ReturnHistoryScreen.dart';



class RecentInvoicesSection extends StatelessWidget {
  const RecentInvoicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 170.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: Colors.red),
                  SizedBox(width: 8.w),
                  Text(
                    "Recent Invoices",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 580.w),
                   GestureDetector(
                     onTap: () {
                       Get.to(() => const ReturnHistoryScreen());
                     },
                     child: Text(
                                     "View all history",
                                     style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                                   ),
                   )
                ],
              )
             
            ],
          ),
           SizedBox(height: 20.h),
           InvoiceCard(
            id: "INV-10245",
            date: "Oct 26, 2023",
            customer: "Walk-in Customer",
            amount: "₹3,450.00",
          ),
           InvoiceCard(
            id: "INV-10244",
            date: "Oct 26, 2023",
            customer: "Rahul Sharma",
            amount: "₹1,899.00",
          ),
          InvoiceCard(
            id: "INV-10243",
            date: "Oct 25, 2023",
            customer: "Ananya Singh",
            amount: "₹5,200.00",
          ),
           InvoiceCard(
            id: "INV-10242",
            date: "Oct 25, 2023",
            customer: "Walk-in Customer",
            amount: "₹999.00",
          ),
        ],
      ),
    );
  }
}