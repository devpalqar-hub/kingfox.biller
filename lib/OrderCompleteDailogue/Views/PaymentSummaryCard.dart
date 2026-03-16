import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';

class PaymentSummaryCard extends StatelessWidget {
  final CartModel cart;

  const PaymentSummaryCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double subtotal = cart.subtotal;
    double gst = cart.gstAmount;
    double total = cart.finalAmount;

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
              Icon(Icons.receipt_long, size: 26.sp, color: const Color(0xFF1D2939)),
              SizedBox(width: 10.w),
              Text("Payment Summary",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: 28.h),
          _buildRow("Subtotal", subtotal),
          _buildRow("Tax (GST ${cart.gstPercent}%)", gst),
          SizedBox(height: 20.h),
          Divider(color: const Color(0xFFD0D5DD), thickness: 1),
          SizedBox(height: 22.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Paid", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
              Text("₹${total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF667085))),
          Text("₹${amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1D2939))),
        ],
      ),
    );
  }
}