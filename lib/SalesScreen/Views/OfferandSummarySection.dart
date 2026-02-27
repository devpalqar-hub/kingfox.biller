import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferAndSummarySection extends StatelessWidget {
  const OfferAndSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0,),
      child: Container(
        width: 440.w,
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        color: const Color(0xFFF5F6F8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
       //offers sectn
      
             Text(
              "OFFERS & PROMOTIONS",
              style: TextStyle(
                letterSpacing: 2.h,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE2E8F0),
              ),
            ),
      
            SizedBox(height: 8.h),
      
            
            Container(
              width: double.infinity,
              height: 1.h,
              decoration:  BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1.w,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
      
            SizedBox(height: 20.h),
      
            /// Coupon Label
             Row(
              children: [
                Icon(Icons.local_offer_outlined,
                    size: 20.sp, color: Color(0xFF667085)),
                SizedBox(width: 8),
                Text(
                  "Coupon Code",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
      
             SizedBox(height: 14.h),
      
        
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60.h,
                    padding:  EdgeInsets.symmetric(horizontal: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.r),
                      border: Border.all(
                        color: const Color(0xFFD0D5DD),
                        width: 1.5.w,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child:  Text(
                      "Enter code",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: 14.w),
                Container(
                  height: 60.h,
                  padding:
                       EdgeInsets.symmetric(horizontal: 28.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(35).r,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      
          SizedBox(height: 40.h),
      
            /// ==============================
            /// ORDER SUMMARY SECTION
            /// ==============================
      
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101828),
              ),
            ),
      
             SizedBox(height: 24.sp),
      
            /// Subtotal
            _summaryRow(
              title: "Subtotal",
              value: "₹3,797",
              titleColor: const Color(0xFF475467),
              valueColor: const Color(0xFF101828),
            ),
      
             SizedBox(height: 18.h),
      
            /// Voucher Deduction
            _summaryRow(
              title: "Voucher Deduction",
              value: "-₹100",
              titleColor: Colors.red,
              valueColor: Colors.red,
            ),
      
            SizedBox(height: 18.h),
      
            /// GST
            _summaryRow(
              title: "GST (5%)",
              value: "₹180",
              titleColor: const Color(0xFF475467),
              valueColor: const Color(0xFF101828),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            color: titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}