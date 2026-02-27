import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReturnData extends StatelessWidget {
  const ReturnData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      child: Row(
        children: [

          const Expanded(child: Text("RET-5501")),
          const Expanded(child: Text("#INV-10245")),

          
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: const Color(0xffDCFCE7),
                  child: Text("JD", style: TextStyle(fontSize: 11.sp)),
                ),
                SizedBox(width: 8.w),
                const Text("John Doe"),
              ],
            ),
          ),

          Expanded(child: Text("2 Items")),
           Expanded(child: Text("₹2,788.00")),

          
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xffDCFCE7),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "REFUNDED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff16A34A),
                ),
              ),
            ),
          ),

           Expanded(child: Text("Oct 25, 14:20")),

          Expanded(
            child: Row(
              children: const [
                Icon(Icons.receipt_long, size: 18),
                SizedBox(width: 6),
                Text("View Bill"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}