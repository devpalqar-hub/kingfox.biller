import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OriginalTransactionInfo extends StatelessWidget {
  const OriginalTransactionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1232.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xffe5e7eb),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORIGINAL TRANSACTION INFO",
            style: TextStyle(
              fontSize: 12.sp,
              letterSpacing: 1.2,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
         Row(
  children: [
    Icon(
      Icons.receipt_long,
      size: 18.sp,
      color: Colors.grey.shade700,
    ),
    SizedBox(width: 15.w),
    Text(
      "INV-10245",
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
),
          Row(
            children: [
              Icon(
      Icons.money,
      size: 18.sp,
      color: Colors.grey.shade700,
    ),SizedBox(width: 15.w),
               Text("CASH PAYMENT"),
            ],
          ),
          Row(
            children: [
               Icon(
      Icons.print,
      size: 18.sp,
      color: Colors.grey.shade700,
    ),SizedBox(width: 15.w),
               Text("Processed by: Alex R."),
            ],
          ),
        ],
      ),
    );
  }
}