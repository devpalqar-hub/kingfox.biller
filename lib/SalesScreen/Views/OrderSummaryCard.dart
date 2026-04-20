import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double exchangeCredit;
  final double coupon;
  final double appliedReturnDiscount;
  final double grandTotal;
  final double refundAmount;
  final VoidCallback onPrint;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.exchangeCredit,
    required this.coupon,
    required this.appliedReturnDiscount,
    required this.grandTotal,
    required this.refundAmount,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.blue, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                "Order Summary",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          /// Rows
          _row("Subtotal", subtotal),
          _row("CGST ", (tax / 2)),
          _row("SGST ", (tax / 2)),

          _row("Exchange Credit", exchangeCredit, isNegative: true, red: true),
          _row("Coupon Deduction", coupon, isNegative: true),
          _row("Return Amount", appliedReturnDiscount, isNegative: true),
          _row("Refund Amount", refundAmount, isNegative: true),

          SizedBox(height: 2.h),

          /// Divider
          Divider(color: Colors.grey.shade300, thickness: 1, height: 20.h),

          SizedBox(height: 3.h),

          /// Grand Total Label
          Text(
            "GRAND TOTAL",
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Color(0xff64748B),
            ),
          ),

          SizedBox(height: 1.h),

          /// Amount
          Text(
            "₹${grandTotal.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1D4ED8),
            ),
          ),

          SizedBox(height: 10.h),

          /// Print Button
          GestureDetector(
            onTap: onPrint,
            
            child: Container(
              height: 42.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: const Color(0xff1D4ED8),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.print, color: Colors.white, size: 22.sp),
                  SizedBox(width: 10.w),
                  Text(
                    "PRINT ( F1 )",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Row Widget
  Widget _row(
    String title,
    double amount, {
    bool isNegative = false,
    bool red = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: red
                  ? Colors.red
                  : isNegative
                  ? Colors.green
                  : const Color(0xff1D2939),
            ),
          ),
        ],
      ),
    );
  }
}
