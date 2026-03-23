import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
 class PaymentSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double refundAmount;
  final double total;

  const PaymentSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.refundAmount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, size: 26.sp),
              SizedBox(width: 10.w),
              Text(
                "Payment Summary",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 28.h),

          _row("Subtotal", subtotal),
          _row("Tax", tax),

          /// ✅ Coupon Discount
          if (discount > 0)
            _row("Coupon Discount", -discount),

          /// ✅ Refund
          if (refundAmount > 0)
            _row("Refund Amount", -refundAmount),

          SizedBox(height: 20.h),
          Divider(),
          SizedBox(height: 22.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Paid",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "₹${total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String title, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              color: amount < 0 ? Colors.red : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}