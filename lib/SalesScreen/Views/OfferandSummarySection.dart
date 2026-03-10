import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferAndSummarySection extends StatelessWidget {
  final double subtotal;
  final double gstAmount;
  final double finalAmount;
  final double voucherDeduction;
  final TextEditingController couponController; 
  final VoidCallback? onApplyCoupon;

  const OfferAndSummarySection({
    super.key,
    required this.subtotal,
    required this.gstAmount,
    required this.finalAmount,
    this.voucherDeduction = 0,
    required this.couponController, 
    this.onApplyCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        width: 440.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        color: const Color(0xFFF5F6F8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "OFFERS & PROMOTIONS",
              style: TextStyle(
                letterSpacing: 2.h,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE2E8F0),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE0E0E0),
                    width: 1.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

         
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.h,vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.r),
                      border: Border.all(
                        color: const Color(0xFFD0D5DD),
                        width: 1.5.w,
                      ),
                    ),
                    child: TextField(
                      controller: couponController, 
                      decoration: InputDecoration(
                        isCollapsed: true,
                        isDense: true,
                        hintText: "Enter code",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFF98A2B3),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                InkWell(
                  onTap: onApplyCoupon,
                  borderRadius: BorderRadius.circular(35.r),
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(35.r),
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
                ),
              ],
            ),

            SizedBox(height: 20.h,),
             Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF101828),
              ),
            ),
            SizedBox(height: 24.sp),

         
            _summaryRow(
              title: "Subtotal",
              value: "₹${subtotal.toStringAsFixed(2)}",
              titleColor: const Color(0xFF475467),
              valueColor: const Color(0xFF101828),
            ),
            SizedBox(height: 18.h),

            
            _summaryRow(
              title: "Voucher Deduction",
              value: "-₹${voucherDeduction.toStringAsFixed(2)}",
              titleColor: Colors.red,
              valueColor: Colors.red,
            ),
            SizedBox(height: 18.h),

           
            _summaryRow(
              title: "GST (5%)",
              value: "₹${gstAmount.toStringAsFixed(2)}",
              titleColor: const Color(0xFF475467),
              valueColor: const Color(0xFF101828),
            ),

            SizedBox(height: 18.h),

           
            _summaryRow(
              title: "Total",
              value: "₹${finalAmount.toStringAsFixed(2)}",
              titleColor: const Color(0xFF101828),
              valueColor: const Color(0xFF16A34A),
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
            fontSize: 20.sp,
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