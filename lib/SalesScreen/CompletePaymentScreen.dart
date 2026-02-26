import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Views/OrderDetailCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/PaymentInformationCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/PaymentSummaryCard.dart';

class CompletePaymentScreen extends StatelessWidget {
  const CompletePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),

              
               CircleAvatar(
                radius: 40.r,
                backgroundColor: Color(0xFFE6F4EA),
                child: Icon(Icons.check, size: 40.sp, color: Colors.green),
              ),

              SizedBox(height: 20.h),

              Text(
                "Order Completed Successfully",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

               SizedBox(height: 8.h),

               Text(
                "Invoice Number: INV-10245",
                style: TextStyle(color: Colors.grey),
              ),

               SizedBox(height: 40.h),

             Expanded(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// LEFT SIDE
      SizedBox(
        width: 816.w, // Adjust based on screen design
        child: Column(
          children: [
            const OrderDetailsCard(),
            SizedBox(height: 20.h),
            const PaymentInformationCard(),
          ],
        ),
      ),

    

      /// RIGHT SIDE
      SizedBox(
        width: 380.w, // Summary smaller than left
        child: const PaymentSummaryCard(),
      ),
    ],
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}