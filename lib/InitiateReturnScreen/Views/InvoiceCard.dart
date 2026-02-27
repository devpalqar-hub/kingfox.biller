import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class InvoiceCard extends StatelessWidget {
  final String id;
  final String date;
  final String customer;
  final String amount;

  const InvoiceCard({
    super.key,
    required this.id,
    required this.date,
    required this.customer,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 896.w,
      height: 94.h,
      margin:  EdgeInsets.only(bottom: 14.h),
      padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _data(
            title: "INVOICE ID",
            value: id,
            isBold: true,
          ),

          _Divider(),

          _data(
            title: "DATE",
            value: date,
          ),

          _Divider(),

     
          Expanded(
            flex: 2,
            child: _data(
              title: "CUSTOMER",
              value: customer,
            ),
          ),

          _Divider(),

          
          _data(
            title: "AMOUNT",
            value: amount,
            isBold: true,
          ),

           SizedBox(width: 30.w),

    
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 26.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xffe5e7eb),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child:  Row(
              children: [
                Text(
                  "Select for Return/Exchange",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _data({
    required String title,
    required String value,
    bool isBold = false,
  }) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              letterSpacing: 1.2.h,
              color: Color(0xff94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
           SizedBox(height: 5.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xff111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _Divider() {
    return Container(
      height: 45.h,
      width: 1.w,
      color: Color(0xffe5e7eb),
    );
  }
}