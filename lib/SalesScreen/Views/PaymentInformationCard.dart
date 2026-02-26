import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentInformationCard extends StatelessWidget {
  const PaymentInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 738.w,
      height: 170.h,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
     
   
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Row(
              children: [
                  Icon(Icons.payment_outlined,
                  size: 26.sp, color: const Color(0xFF1D2939)),
                  SizedBox(width: 10.w),
                Text(
                  "Payment Information",
                  style: TextStyle(
                   fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1D2939),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Method"),
                Row(
                  children: [
                    Icon(Icons.money_outlined, size: 20.sp, color: const Color(0xFF1D2939)),
                    SizedBox(width: 6.w),
                    Text("Cash"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date & Time"),
                Text("Oct 24, 2023 • 14:35 PM"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}