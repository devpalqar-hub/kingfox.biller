import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

class ManualDiscountCard extends StatelessWidget {
  const ManualDiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: GetBuilder<AddProductController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                children: [
                  Icon(Icons.discount, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Manual Discount",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              /// 🔥 STAFF DROPDOWN (attendedByStaffId)
Container(
  height: 40.h,
  padding: EdgeInsets.symmetric(horizontal: 14.w),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(color: Colors.grey.shade300),
  ),
  child: DropdownButton<int>(
    isExpanded: true,
    underline: const SizedBox(),
    hint: Text(
      "Select Staff",
      style: TextStyle(fontSize: 12.sp),
    ),

    /// ✅ SELECTED VALUE
    value: controller.selectedStaff?.id,

    /// ✅ STAFF LIST
    items: controller.staffList.map((staff) {
      return DropdownMenuItem<int>(
        value: staff.id,
        child: Text(
          staff.name ?? "Unnamed",
          style: TextStyle(fontSize: 12.sp),
        ),
      );
    }).toList(),

    /// ✅ ON CHANGE
    onChanged: (value) {
      if (value == null) return;

      final selected = controller.staffList.firstWhere(
        (s) => s.id == value,
      );

      controller.selectStaff(selected);
    },
  ),
),

              SizedBox(height: 12.h),

              /// 🔥 DISCOUNT INPUT
              Row(
                children: [
                Expanded(
  child: Container(
    height: 42.h,
    alignment: Alignment.center, // ✅ ensures vertical center
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: TextField(
      controller: controller.discountController,
      keyboardType: TextInputType.number,
      textAlignVertical: TextAlignVertical.center, // ✅ center text
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        isDense: true, 
        hintText: "Enter Discount Amount",
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey.shade500,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero, 
      ),
    ),
  ),
),

                  SizedBox(width: 10.w),

                  /// 🔥 APPLY BUTTON (NO API CALL)
                  GestureDetector(
                    onTap: () async {
                      if (controller.cart == null ||
                          controller.cart!.items.isEmpty) {
                        return;
                      }

                      final input = controller.discountController.text.trim();

                      /// ❌ EMPTY CHECK
                      if (input.isEmpty) {
                        Get.snackbar("Error", "Enter discount amount");
                        return;
                      }

                      final discount = int.tryParse(input);

                      /// ❌ INVALID NUMBER
                      if (discount == null || discount <= 0) {
                        Get.snackbar("Error", "Invalid discount amount");
                        return;
                      }

                      /// ✅ CALL API WITH DISCOUNT
                      await controller.getCart(
                        manualDiscountAmount: discount.toDouble(),
                      );
                    },
                    child: Container(
                      height: 38.h,
                      width: 100.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff6CCF4F),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// 🔥 SHOW APPLIED VALUE (optional but useful)
            ],
          );
        },
      ),
    );
  }
}
