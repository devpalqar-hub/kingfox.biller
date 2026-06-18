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
              if (ctrl.selectedPaymentMethods.length == 2) ...[
                SizedBox(height: 12.h),

                Row(
                  children: [
                    if (ctrl.selectedPaymentMethods.contains("cash"))
                      Expanded(
                        child: Container(
                          height: 30.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: ctrl.cashAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Cash Amount",
                              hintStyle: TextStyle(fontSize: 10.sp),
                              isDense: true,
                              isCollapsed: true,
                            ),
                            onChanged: (_) => ctrl.update(),
                          ),
                        ),
                      ),

                    if (ctrl.selectedPaymentMethods.contains("cash") &&
                        (ctrl.selectedPaymentMethods.contains("card") ||
                            ctrl.selectedPaymentMethods.contains("upi")))
                      SizedBox(width: 10.w),

                    if (ctrl.selectedPaymentMethods.contains("card"))
                      Expanded(
                        child: Container(
                          height: 30.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: ctrl.cardAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Card Amount",
                              hintStyle: TextStyle(fontSize: 10.sp),
                              isDense: true,
                              isCollapsed: true,
                            ),
                            onChanged: (_) => ctrl.update(),
                          ),
                        ),
                      ),

                    if (ctrl.selectedPaymentMethods.contains("card") &&
                        ctrl.selectedPaymentMethods.contains("upi"))
                      SizedBox(width: 10.w),

                    if (ctrl.selectedPaymentMethods.contains("upi"))
                      Expanded(
                        child: Container(
                          height: 30.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: ctrl.upiAmountController, // Fixed
                            keyboardType: TextInputType.number,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "UPI Amount",
                              hintStyle: TextStyle(fontSize: 10.sp),
                              isDense: true,
                              isCollapsed: true,
                            ),
                            onChanged: (_) => ctrl.update(),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 10.h),

                if (ctrl.cart != null && ctrl.cart!.grandFinalTotal != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Remaining Amount : ₹${(ctrl.cart!.grandFinalTotal - ctrl.totalPaid).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
              SizedBox(height: 10.h),
              Text(
                "Order Type",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  _option(ctrl, "Offline", "OFFLINE", istype: true),
                  SizedBox(width: 10.w),
                  _option(ctrl, "Online", "ONLINE", istype: true),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _option(
    AddProductController ctrl,
    String label,
    String value, {
    bool istype = false,
  }) {
    final isSelected = istype
        ? ctrl.selectedOrderType == value
        : ctrl.isPaymentSelected(value);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ctrl.upiAmountController.text = "";
          ctrl.cardAmountController.text = "";
          ctrl.cashAmountController.text = "";
          if (!istype) {
            ctrl.togglePaymentMethod(value);
          } else {
            ctrl.selectedOrderType = value;
            ctrl.update();
          }
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
