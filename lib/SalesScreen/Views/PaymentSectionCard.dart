import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/OrderCompleteDailogue.dart';
import '../Service/SalesController.dart';

class PaymentSectionCard extends StatefulWidget {
  final double totalAmount;
 final Future<bool> Function(String paymentMethod) onComplete;

  const PaymentSectionCard({
    super.key,
    required this.totalAmount,
    required this.onComplete,
  });

  @override
  State<PaymentSectionCard> createState() => _PaymentSectionCardState();
}

class _PaymentSectionCardState extends State<PaymentSectionCard> {
  String selectedMethod = "cash";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (controller) {
        return Container(
          width: 480.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
             
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Row(
                  children: [
                    Text(
                      "Grant Total",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: const Color(0xFF475467),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2.h,
                      ),
                    ),
                    SizedBox(width: 90.w),
                    Text(
                      "₹${widget.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: const Color(0xFF2BA153),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.h,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              
              Text(
                "PAYMENT METHOD",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.h,
                  color: const Color(0xFF667085),
                ),
              ),

              SizedBox(height: 15.h),

            
              Row(
                children: [
                  _paymentType(
                    title: "Cash",
                    icon: Icons.payments_outlined,
                    isSelected: selectedMethod == "cash",
                    onTap: () => setState(() => selectedMethod = "cash"),
                  ),
                  SizedBox(width: 10.w),
                  _paymentType(
                    title: "Online",
                    icon: Icons.qr_code,
                    isSelected: selectedMethod == "online",
                    onTap: () => setState(() => selectedMethod = "online"),
                  ),
                ],
              ),

              SizedBox(height: 35.h),

              GestureDetector(
              onTap: () async {
  if (controller.cart == null) return;

  bool success = await widget.onComplete(selectedMethod);

  if (success) {
    String invoiceNumber = "INV-${DateTime.now().millisecondsSinceEpoch}";

    Get.dialog(
      OrderCompleteDialog(
        cart: controller.cart!,
        invoiceNumber: invoiceNumber,
        paymentMethod: selectedMethod,
      ),
      barrierDismissible: false,
    );
  }
},
  child: Container(
    height: 50.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(12.r),
    ),
    alignment: Alignment.center,
    child: Text(
      "Complete Payment",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
              SizedBox(height: 20.h),
            
            ],
          ),
        );
      },
    );
  }

  Widget _paymentType({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECECEC) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFBDBDBD),
            width: 2.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26.sp, color: Colors.black),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
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