import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

class VoucherSelectionCard extends StatelessWidget {
  const VoucherSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
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
              /// TITLE
              Text(
                "Voucher Selection",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 12.h),

              /// 🔥 DROPDOWN + COUNTER
              Row(
                children: [
                  /// DROPDOWN
                  Expanded(
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Voucher",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        value: controller.selectedCampaign?.id,
                        items: controller.campaigns.map((campaign) {
                          return DropdownMenuItem<int>(
                            value: campaign.id,
                            child: Text(
                              campaign.name,
                              style: TextStyle(fontSize: 12.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          final selected = controller.campaigns
                              .firstWhere((c) => c.id == value);
                          controller.selectCampaign(selected);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  /// ➖ MINUS
                  GestureDetector(
                    onTap: () {
                      int current = int.tryParse(
                              controller.voucherCountController.text) ??
                          1;

                      if (current > 1) {
                        current--;
                        controller.voucherCountController.text =
                            current.toString();
                        controller.update();
                      }
                    },
                    child: Container(
                      height: 42.h,
                      width: 36.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(Icons.remove, size: 18.sp),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  /// COUNT
                  Container(
                    width: 55.w,
                    height: 42.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: controller.voucherCountController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  /// ➕ PLUS
                  GestureDetector(
                    onTap: controller.updateVoucherCount,
                    child: Container(
                      height: 42.h,
                      width: 36.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(Icons.add, size: 18.sp),
                    ),
                  ),
                ],
              ),

              /// ERROR
              if (controller.voucherError?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    controller.voucherError!,
                    style: TextStyle(color: Colors.red, fontSize: 11.sp),
                  ),
                ),

              SizedBox(height: 14.h),

              /// 🔥 COUPON SECTION
              Row(
                children: [
                  /// INPUT
                  Expanded(
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      alignment: Alignment.center,
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
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(fontSize: 13.sp),
                              onChanged: (value) {
                                controller.couponError = null;
                                controller.appliedCoupon = "";
                                controller.update();
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Coupon Code",
                                hintStyle:
                                    TextStyle(fontSize: 12.sp),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  /// APPLY BUTTON
                  GestureDetector(
                    onTap: () async {
                      final coupon =
                          controller.couponController.text.trim();

                      if (controller.cart == null ||
                          controller.cart!.items.isEmpty) return;

                      if (coupon.isEmpty) {
                        controller.couponError = "Enter coupon code";
                        controller.update();
                        return;
                      }

                      await controller.getCart(
                        couponCode: coupon,
                      );
                    },
                    child: Container(
                      height: 42.h,
                      width: 90.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff6CCF4F),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// COUPON ERROR
              if (controller.couponError?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    controller.couponError!,
                    style: TextStyle(color: Colors.red, fontSize: 11.sp),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}