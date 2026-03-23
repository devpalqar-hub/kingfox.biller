import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';

class VoucherSelectionCard extends StatelessWidget {

  const VoucherSelectionCard({
    super.key,
  });

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
                  Icon(Icons.card_giftcard, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Gift Vouchers",
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          
              SizedBox(height: 14.h),
          
              /// Dropdown + Count
              Row(
                children: [
                  Expanded(
                    child: Container(
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
          
                          /// ✅ FIXED DROPDOWN
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select Voucher",
                              style: TextStyle(fontSize: 12.sp),
                            ),
          
                            /// 🔥 USE ID
                            value: controller.selectedCampaign?.id,
          
                            items: controller.campaigns.map((campaign) {
                              return DropdownMenuItem<int>(
                                value: campaign.id,
                                child: Text(
                                  campaign.name,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              );
                            }).toList(),
          
                            onChanged: (value) {
                              if (value == null) return;
          
                              final selected = controller.campaigns.firstWhere(
                                (c) => c.id == value,
                              );
          
                              controller.selectCampaign(selected);
                            },
                          ),
                        )
                  ),
          
                  SizedBox(width: 10.w),
          
                  /// Count Box
                  Container(
                    width: 60.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: controller.voucherCountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
          
                  SizedBox(width: 8.w),
          
                  /// Plus Button
                  GestureDetector(
                    onTap: controller.updateVoucherCount,
                    child: Container(
                      height: 38.h,
                      width: 44.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
          
              SizedBox(height: 12.h),
          
              /// Coupon Field + Apply Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 18.sp),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: TextField(
                              controller: controller.couponController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Coupon Code",
                                hintStyle: TextStyle(fontSize: 12.sp),
                                isCollapsed: true,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  SizedBox(width: 10.w),
          
                  /// APPLY BUTTON
                  GestureDetector(
                    onTap: () async {
                      final coupon = controller.couponController.text.trim();
          
                      if (controller.cart == null ||
                          controller.cart!.items.isEmpty) {
                        Get.snackbar("Error", "Cart is empty");
                        return;
                      }
          
                      controller.appliedCoupon = coupon;
          
                      await controller.getCart(couponCode: coupon);
          
                      Get.snackbar(
                        "Success",
                        coupon.isEmpty ? "Cart Updated" : "Coupon Applied",
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
            ],
          );
        }
      ),
    );
  }
}
