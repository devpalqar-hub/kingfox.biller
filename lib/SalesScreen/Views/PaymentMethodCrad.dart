import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (ctrl) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment Method",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  _option(ctrl, "Cash", "cash"),
                  SizedBox(width: 10.w),
                  _option(ctrl, "UPI", "upi"),
                  SizedBox(width: 10.w),
                  _option(ctrl, "Card", "card"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _option(AddProductController ctrl, String label, String value) {
    final isSelected = ctrl.selectedPaymentMethod == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ctrl.selectedPaymentMethod = value;
          ctrl.update();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff1D4ED8) : const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
