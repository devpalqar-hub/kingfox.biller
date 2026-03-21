import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentInformationCard extends StatelessWidget {
  //final String paymentMethod;
  final DateTime paymentDateTime;
  final double? paidAmount;

  const PaymentInformationCard({
    super.key,
   // required this.paymentMethod,
    required this.paymentDateTime,
    this.paidAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 738.w,
      //height: 180.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Method", style: TextStyle(fontSize: 14.sp)),
              Row(
                children: [
                  Icon(Icons.money_outlined, size: 20.sp),
                  SizedBox(width: 6.w),
                //  Text(paymentMethod, style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date & Time", style: TextStyle(fontSize: 14.sp)),
              Text(_formatDateTime(paymentDateTime), style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          if (paidAmount != null) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Paid Amount", style: TextStyle(fontSize: 14.sp)),
                Text("₹${paidAmount!.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            )
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    final minute = dt.minute.toString().padLeft(2, '0');
    return "${months[dt.month-1]} ${dt.day}, ${dt.year} • $hour:$minute $ampm";
  }
}