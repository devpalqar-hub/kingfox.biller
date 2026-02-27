import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/OrderDetailCard.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/PaymentInformationCard.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/PaymentSummaryCard.dart';


class OrderCompleteDialog extends StatelessWidget {
  const OrderCompleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 40.h),
      child: Container(
        width: 1320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color:  Color(0xffF1F5F9),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SingleChildScrollView(
          child: Column(
           
            children: [

              /// Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon:  Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              SizedBox(height: 10.h),

              /// Success Icon
              CircleAvatar(
                radius: 40.r,
                backgroundColor: const Color(0xFFE6F4EA),
                child: Icon(
                  Icons.check,
                  size: 40.sp,
                  color: Colors.green,
                ),
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

              const Text(
                "Invoice Number: INV-10245",
                style: TextStyle(color: Colors.grey),
              ),
               SizedBox(height: 15.h),
              SizedBox(
  width: 1100.w,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 750.w,
        child: Column(
          children: [
            const OrderDetailsCard(),
            SizedBox(height: 20.h),
            const PaymentInformationCard(),
          ],
        ),
      ),

      SizedBox(width: 15.w), 

      
      SizedBox(
        width: 320.w,
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