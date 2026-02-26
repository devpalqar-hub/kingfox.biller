import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:kinfox_biller/SalesScreen/CompletePaymentScreen.dart';

class PaymentSectionCard extends StatefulWidget {
  const PaymentSectionCard({super.key});

  @override
  State<PaymentSectionCard> createState() =>
      _PaymentSectionCardState();
}

class _PaymentSectionCardState
    extends State<PaymentSectionCard> {

  String selectedMethod = "cash";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
       borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20.r),
      bottomRight: Radius.circular(20.r),
    ),
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ==========================
          /// TITLE
          /// ==========================
          Padding(
            padding:  EdgeInsets.only(left: 8.0,  ),
            child: Row(
              children: [
                Text(
                  "Grant Total",
                  style: TextStyle(
                    fontSize: 22.sp,
                  color:const Color(0xFF475467),
                  fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                        
                  ),
                ),
                SizedBox(width: 130.w),
                 Text(
                  "₹3,677",
                  style: TextStyle(
                    fontSize: 30.sp,
                  color:const Color(0xFF2BA153),
                  fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                        
                  ),
                ),
                
              ],
            ),
          ),

           SizedBox(height: 60.h),
          Text(
            "PAYMENT METHOD",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: const Color(0xFF667085),
            ),
          ),

          SizedBox(height: 24.h),

          /// ==========================
          /// CASH & ONLINE BUTTONS
          /// ==========================
          Row(
            children: [

              /// CASH BUTTON
               Padding(
                 padding: const EdgeInsets.all(5.0),
                 child: _paymentButton(
                    title: "Cash",
                    icon: Icons.payments_outlined,
                    isSelected: selectedMethod == "cash",
                    onTap: () {
                      setState(() {
                        selectedMethod = "cash";
                      });
                    },
                  ),
               ),
              

              SizedBox(width: 10.w),

              /// ONLINE BUTTON
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: _paymentButton(
                    title: "Online",
                    icon: Icons.qr_code,
                    isSelected: selectedMethod == "online",
                    onTap: () {
                      setState(() {
                        selectedMethod = "online";
                      });
                    },
                  ),
              ),
              
            ],
          ),

          SizedBox(height: 36.h),
          GestureDetector(
  onTap: () {
    Get.to(() => const CompletePaymentScreen());
  },
  child: Container(
    width: double.infinity,
    height: 68.h,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(24.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.print,
          color: Colors.white,
          size: 28.sp,
        ),
        SizedBox(width: 14.w),
        Text(
          "COMPLETE & PRINT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
),
          SizedBox(height: 20.h),

          /// ==========================
          /// F12 QUICK PRINT TEXT
          /// ==========================
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF98A2B3),
                ),
                children: [
                  const TextSpan(
                    text: "Press ",
                  ),
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 1.h),
                      margin: EdgeInsets.symmetric(
                          horizontal: 6.w),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xFFD0D5DD),
                        ),
                      ),
                      child: Text(
                        "F12",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: " for quick print and close",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// REUSABLE PAYMENT BUTTON
  /// ==========================
  Widget _paymentButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 185.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFECECEC)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? Colors.black
                : const Color(0xFFBDBDBD),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 26.sp,
                color: Colors.black),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}