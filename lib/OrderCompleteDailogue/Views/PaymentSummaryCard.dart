import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double refundAmount;
  final double total;
  final double? tenderedAmount;

  const PaymentSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.refundAmount,
    required this.total,
    this.tenderedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final change = (tenderedAmount != null && tenderedAmount! > total)
        ? tenderedAmount! - total
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section label
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 12.sp,
                color: const Color(0xFF94A3B8),
              ),
              SizedBox(width: 5.w),
              Text(
                'BILL SUMMARY',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        /// Line items
        _SummaryRow(label: 'Subtotal', value: subtotal),
        _SummaryRow(label: 'Tax / GST', value: tax),
        if (discount > 0)
          _SummaryRow(
            label: 'Coupon discount',
            value: -discount,
            valueColor: const Color(0xFFDC2626),
          ),
        if (refundAmount > 0)
          _SummaryRow(
            label: 'Refund adj.',
            value: -refundAmount,
            valueColor: const Color(0xFFDC2626),
          ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: const Divider(
            height: 0.5,
            thickness: 0.5,
            color: Color(0xFFE2E8F0),
          ),
        ),

        /// Total block
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL PAID',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 10.sp,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: const Color(0xFF4ADE80),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'incl. all taxes & discounts',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.30),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),

        /// Cash change block
        if (change != null) ...[
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash transaction',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                _ChangeRow(
                  label: 'Tendered',
                  value: '₹${tenderedAmount!.toStringAsFixed(2)}',
                ),
                SizedBox(height: 2.h),
                _ChangeRow(
                  label: 'Change',
                  value: '₹${change.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF15803D),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF64748B)),
          ),
          Text(
            value < 0
                ? '−₹${value.abs().toStringAsFixed(2)}'
                : '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ChangeRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF94A3B8)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: valueColor ?? const Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}
