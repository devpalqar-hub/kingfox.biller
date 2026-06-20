import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

class ManualDiscountCard extends StatelessWidget {
  const ManualDiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: GetBuilder<AddProductController>(
        builder: (ctrl) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 16.sp,
                  color: const Color(0xFF64748B),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Discount & Staff",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ), // Increased
              ],
            ),
            SizedBox(height: 8.h),

            /// Staff Dropdown
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 34.h, // Increased
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: ctrl.selectedStaff?.id,
                        hint: Text(
                          "Assigned staff",
                          style: TextStyle(fontSize: 13.sp),
                        ), // Increased
                        icon: Icon(Icons.expand_more, size: 18.sp),
                        items: ctrl.staffList
                            .map(
                              (s) => DropdownMenuItem<int>(
                                value: s.id,
                                child: Text(
                                  s.name,
                                  style: TextStyle(fontSize: 13.sp),
                                ), // Increased
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            ctrl.selectStaff(
                              ctrl.staffList.firstWhere((s) => s.id == v),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                if (ctrl.selectedStaff != null) ...[
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      ctrl.selectedStaff = null;
                      ctrl.update();
                    },
                    child: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.h),

            /// Type & Input Row
            Row(
              children: [
                // Toggle Amount/Percentage
                Container(
                  height: 34.h, // Increased
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F5F9),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      _toggleBtn(ctrl, "Amt", false),
                      _toggleBtn(ctrl, "%", true),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Input
                Expanded(
                  child: Container(
                    height: 34.h, // Increased
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: ctrl.discountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 14.sp), // Increased
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                        LengthLimitingTextInputFormatter(
                          ctrl.isPercentageDiscount ? 6 : 10,
                        ),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        hintText: ctrl.isPercentageDiscount ? "0.0 %" : "0.00",
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF94A3B8),
                        ), // Increased
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Apply Button
                GestureDetector(
                  onTap: () async {
                    if (ctrl.cart == null || ctrl.cart!.items.isEmpty) return;
                    var discount =
                        double.tryParse(ctrl.discountController.text.trim()) ??
                        0;
                    if (ctrl.isPercentageDiscount) {
                      await ctrl.getCart(manualDiscountPercent: discount);
                    } else {
                      await ctrl.getCart(manualDiscountAmount: discount);
                    }
                  },
                  child: Container(
                    height: 34.h, // Increased
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      "Apply",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ), // Increased
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(AddProductController ctrl, String label, bool isPercent) {
    bool isSelected = ctrl.isPercentageDiscount == isPercent;
    return GestureDetector(
      onTap: () {
        ctrl.isPercentageDiscount = isPercent;
        ctrl.update();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff1D4ED8) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13.sp, // Increased
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
