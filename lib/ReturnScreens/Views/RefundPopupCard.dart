import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:kinfox_biller/ReturnScreens/Service/ReturnFlowController.dart';

class RefundSuccessPopup extends StatelessWidget {
  final double totalRefund;
  final String method;
  final String reference;
  final List<RefundItem> items;

  const RefundSuccessPopup({
    super.key,
    required this.totalRefund,
    required this.method,
    required this.reference,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        children: [
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
                // ✅ Check icon
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

                // ✅ Title
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

                // ✅ Subtitle
                Text(
                  "The return transaction has been completed and finalized.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
                SizedBox(height: 28.h),

                // ✅ Refund Details
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
                            "₹${totalRefund.toStringAsFixed(2)}",
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
                      _infoRow("METHOD", method),
                      SizedBox(height: 10.h),
                      _infoRow("REFERENCE", reference),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),

                // ✅ Items returned
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

                // Dynamic list of items
                Column(
                  children: items
                      .map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: _itemRow(item.image, item.name, item.details),
                          ))
                      .toList(),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),

          // Close button
          Positioned(
            top: 12.h,
            right: 12.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                 final controller = Get.find<ReturnFlowController>();
    controller.backToInitiate(); 
    
    controller.update();

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
          padding: EdgeInsets.all(8.w),
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

// ✅ Model class for each returned item
class RefundItem {
  final String image;
  final String name;
  final String details;

  RefundItem({
    required this.image,
    required this.name,
    required this.details,
  });
}