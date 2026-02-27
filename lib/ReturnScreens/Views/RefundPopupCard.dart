import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefundSuccessPopup extends StatelessWidget {
  const RefundSuccessPopup({super.key});

 @override
Widget build(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Stack(
      children: [

        /// ===== YOUR EXISTING UI (UNCHANGED) =====
        Container(
          width: 512.w,
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: const Color(0xffF3F4F6),
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                height: 90.w,
                width: 90.w,
                decoration: const BoxDecoration(
                  color: Color(0xffEF4444),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 44.sp,
                ),
              ),

              SizedBox(height: 22.h),

              Text(
                "Refund Processed\nSuccessfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff0F172A),
                ),
              ),

              SizedBox(height: 14.h),

              Text(
                "The return transaction has been completed and finalized.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xff64748B),
                ),
              ),

              SizedBox(height: 28.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xffE5E7EB),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOTAL REFUND",
                          style: TextStyle(
                            fontSize: 12.sp,
                            letterSpacing: 1.2,
                            color: const Color(0xff64748B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "₹4,398",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xffEF4444),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    Divider(color: Colors.grey.shade400),
                    SizedBox(height: 16.h),

                    _infoRow("METHOD", "Original Payment (Cash)"),
                    SizedBox(height: 10.h),
                    _infoRow("REFERENCE", "RET-98421"),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ITEMS RETURNED",
                  style: TextStyle(
                    fontSize: 12.sp,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff94A3B8),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              _itemRow(
                "assets/denim.png",
                "Slim Fit Denim Shirt",
                "QTY: 1 • SKU: DNM-0024-BL",
              ),

              SizedBox(height: 14.h),

              _itemRow(
                "assets/shoe.png",
                "Performance Mesh Sneakers",
                "QTY: 1 • SKU: SHO-1102-RD",
              ),

              SizedBox(height: 30.h),

              Container(
                height: 64.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  border:
                      Border.all(color: const Color(0xffCBD5E1), width: 2),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "VIEW RETURN RECEIPT",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: const Color(0xff334155),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.receipt_long, size: 20.sp),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// ===== CLOSE BUTTON (ADDED ONLY) =====
        Positioned(
          top: 12.h,
          right: 12.w,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // closes popup
              // if using GetX -> Get.back();
            },
            child: Container(
              height: 36.w,
              width: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 20.sp,
                color: const Color(0xff334155),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
  

  
  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 1.2,
            color: const Color(0xff64748B),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff0F172A),
          ),
        ),
      ],
    );
  }

 
  Widget _itemRow(String image, String title, String sub) {
    return Row(
      children: [
        Container(
          height: 52.w,
          width: 52.w,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Image.asset(image, fit: BoxFit.contain),
        ),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              sub,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff64748B),
              ),
            ),
          ],
        )
      ],
    );
  }
}