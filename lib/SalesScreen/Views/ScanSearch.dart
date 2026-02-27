import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanSearch extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onReturnTap;

  const ScanSearch({
    super.key,
    required this.controller,
    required this.onReturnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),

      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50.h,
             // width: 785.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xffE5E7EB),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 20.sp,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Scan barcode or search products",
                         isCollapsed: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 15.w),
          ReturnButton(onTap: onReturnTap),
        ],
      ),
    );
  }
}

class ReturnButton extends StatelessWidget {
  final VoidCallback onTap;

  const ReturnButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          color: const Color(0xffE53935),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              "RETURN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}