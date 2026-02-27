import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key});

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

          /// Title
          Row(
            children: [
              Icon(Icons.receipt_long,
                  size: 26.sp, color: const Color(0xFF1D2939)),
              SizedBox(width: 10.w),
              Text(
                "Payment Summary",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D2939),
                ),
              ),
            ],
          ),

          SizedBox(height: 28.h),

          _buildRow("Subtotal", 115.00),
          _buildRow("Item Discounts", -10.00, isNegative: true),
          _buildRow("Coupon Applied", -5.00, isNegative: true),
          _buildRow("Tax (GST 7%)", 8.05),

          SizedBox(height: 20.h),

          /// Dotted Divider
          Container(
            height: 1,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFD0D5DD),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),

          SizedBox(height: 22.h),

          /// Total Paid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Paid",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D2939),
                ),
              ),
              Text(
                "\$108.05",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E9F4B),
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          /// New Sale Button
          Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  "New Sale",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// Print Receipt Button
          Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE4E7EC),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.print,
                    color: const Color(0xFF1D2939), size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  "Print Receipt",
                  style: TextStyle(
                    color: const Color(0xFF1D2939),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 22.h),

          /// View Billing History
          Center(
            child: Text(
              "View Billing History",
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF667085),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, double amount,
      {bool isNegative = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF667085),
            ),
          ),
          Text(
            "${amount < 0 ? "-" : ""}\$${amount.abs().toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isNegative
                  ? const Color(0xFFD92D20)
                  : const Color(0xFF1D2939),
            ),
          ),
        ],
      ),
    );
  }
}