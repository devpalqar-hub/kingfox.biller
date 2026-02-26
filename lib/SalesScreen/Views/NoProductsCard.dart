import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoProductsCard extends StatelessWidget {
  const NoProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// Circular Icon Background
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_shopping_cart_outlined,
                size: 60.sp,
                color: const Color(0xFF9CA3AF),
              ),
            ),

            SizedBox(height: 32.h),

            /// Title
            Text(
              "No products added",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),

            SizedBox(height: 16.h),

            /// Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 120.w),
              child: Text(
                "Start scanning items or use the search\nbar to populate the customer's cart.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  height: 1.6,
                  color: const Color(0xFF667085),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}