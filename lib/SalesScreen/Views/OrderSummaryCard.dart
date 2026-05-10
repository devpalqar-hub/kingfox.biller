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
          //   _row("Exchange Credit", exchangeCredit, isNegative: true, red: true),
          if (coupon > 0) _row("Coupon Deduction", coupon, isNegative: true),
          if (appliedReturnDiscount > 0)
            _row(
              "Exchange Credit",
              appliedReturnDiscount,
              isNegative: true,
              red: true,
            ),
          if (refundAmount > 0)
            _row("Refund Amount", refundAmount, isNegative: true),
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
            style: const TextStyle(
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
