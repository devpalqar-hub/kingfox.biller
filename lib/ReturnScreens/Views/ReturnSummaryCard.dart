import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/ReturnScreens/Views/RefundPopupCard.dart';

class ReturnSummaryCard extends StatelessWidget {
  const ReturnSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffE32626),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "RETURN SUMMARY",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: .8,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "TRANSACTION REF: INV-10245",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// ================= BODY (WHITE) =================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _summaryRow("SELECTED ITEMS", "02"),
                _summaryRow("TAX REFUND (12%)", "₹471.21"),
                _summaryRow("ADJUSTMENT FEES", "- ₹0.00", red: true),

                SizedBox(height: 14.h),
                Divider(color: Colors.grey.shade300),
                SizedBox(height: 14.h),

                /// TOTAL
                Center(
                  child: Column(
                    children: [
                      Text(
                        "TOTAL REFUND AMOUNT",
                        style: TextStyle(
                          fontSize: 12.sp,
                          letterSpacing: 1.4,
                          color: const Color(0xff8A97A8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "₹4,398",
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffE32626),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                /// REFUND METHOD
                Text(
                  "REFUND METHOD",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff8A97A8),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Expanded(child: _methodButton("Online", selected: true)),
                    SizedBox(width: 12.w),
                    Expanded(child: _methodButton("Cash")),
                  ],
                ),

                SizedBox(height: 22.h),

               GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RefundSuccessPopup(),
    );
  },
  child: Container(
    height: 58.h,
    decoration: BoxDecoration(
      color: const Color(0xffE32626),
      borderRadius: BorderRadius.circular(30.r),
    ),
    alignment: Alignment.center,
    child: Text(
      "PROCESS REFUND  »",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
      ),
    ),
  ),
),

                SizedBox(height: 14.h),

                
                Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F2F4),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel & Go Back",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff64748B),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                /// INFO TEXT
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.red, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "Refunds will be processed to the original payment "
                        "method (Cash) by default unless Store Credit is selected.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xff64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool red = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              letterSpacing: 1,
              color: const Color(0xff667085),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: red ? const Color(0xffE32626) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodButton(String text, {bool selected = false}) {
    return Container(
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xffDDE3DF) : Colors.transparent,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: selected ? Colors.black : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff344054),
        ),
      ),
    );
  }
}