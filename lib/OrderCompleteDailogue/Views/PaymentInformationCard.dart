import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentInformationCard extends StatelessWidget {
  final DateTime paymentDateTime;
  final double? paidAmount;
  final double? tenderedAmount;
  final String paymentMethod ; // Placeholder, replace with actual method

  const PaymentInformationCard({
    super.key,
    required this.paymentDateTime,
    required this.paymentMethod,
    this.paidAmount,
    this.tenderedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final change = (tenderedAmount != null && paidAmount != null)
        ? tenderedAmount! - paidAmount!
        : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 2×2 info grid
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _gridCell(
                    label: 'Method',
                    child: Text(
                      paymentMethod, 
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    borderRight: true,
                    borderBottom: true,
                  ),
                ),
                Expanded(
                  child: _gridCell(
                    label: 'Status',
                    child: _PaidBadge(),
                    borderBottom: true,
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _gridCell(
                    label: 'Date & Time',
                    child: Text(
                      _formatDateTime(paymentDateTime),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    borderRight: true,
                  ),
                ),
                Expanded(
                  child: _gridCell(
                    label: 'Paid Amount',
                    child: Text(
                      paidAmount != null
                          ? '₹${paidAmount!.toStringAsFixed(2)}'
                          : '—',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF15803D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Tendered + change row (only when available)
          if (tenderedAmount != null && change != null && change >= 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  _inlineKV(
                    'Tendered',
                    '₹${tenderedAmount!.toStringAsFixed(2)}',
                  ),
                  SizedBox(width: 20.w),
                  _inlineKV(
                    'Change Given',
                    '₹${change.toStringAsFixed(2)}',
                    valueColor: const Color(0xFF15803D),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _gridCell({
    required String label,
    required Widget child,
    bool borderRight = false,
    bool borderBottom = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        border: Border(
          right: borderRight
              ? const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)
              : BorderSide.none,
          bottom: borderBottom
              ? const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3.h),
          child,
        ],
      ),
    );
  }

  Widget _PaidBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.w,
            height: 5.h,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Collected',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inlineKV(String key, String value, {Color? valueColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$key: ',
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

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $hour:$min $ampm';
  }
}
