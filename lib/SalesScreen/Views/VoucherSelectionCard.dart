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
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 8.h),

              /// 🔥 DROPDOWN + COUNTER
              Row(
                children: [
                  /// DROPDOWN
                  Expanded(
                    child: Container(
                      height: 36.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<int>(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          "Select Voucher",
                          style: TextStyle(fontSize: 11.sp),
                        ),
                        value: controller.selectedCampaign?.id,

                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              "None",
                              style: TextStyle(fontSize: 11.sp),
                            ),
                          ),

                          ...controller.campaigns.map((campaign) {
                            return DropdownMenuItem<int>(
                              value: campaign.id,
                              child: Text(
                                campaign.name,
                                style: TextStyle(fontSize: 11.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                        ],

                        onChanged: (value) {
                          if (value == null) {
                            controller.selectedCampaign = null;
                            controller.voucherCountController.text = "1";
                            controller.update();
                            return;
                          }

                          final selected = controller.campaigns.firstWhere(
                            (c) => c.id == value,
                          );
                          controller.selectCampaign(selected);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  GestureDetector(
                    onTap: () {
                      int current =
                          int.tryParse(
                            controller.voucherCountController.text,
                          ) ??
                          1;

                      if (current > 1) {
                        current--;
                        controller.voucherCountController.text = current
                            .toString();
                        controller.update();
                      }
                    },
                    child: Container(
                      height: 36.h,
                      width: 32.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(Icons.remove, size: 16.sp),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  /// COUNT
                  Container(
                    width: 46.w,
                    height: 36.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      controller.voucherCountController.text,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //  TextField(
                    //   controller: controller.voucherCountController,
                    //   textAlign: TextAlign.center,
                    //   textAlignVertical: TextAlignVertical.center,
                    //   keyboardType: TextInputType.number,
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    //   decoration: const InputDecoration(
                    //     isDense: true,
                    //     border: InputBorder.none,
                    //     contentPadding: EdgeInsets.zero,
                    //   ),
                    // ),
                  ),

                  SizedBox(width: 4.w),

                  /// ➕ PLUS
                  GestureDetector(
                    onTap: controller.updateVoucherCount,
                    child: Container(
                      height: 36.h,
                      width: 32.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(Icons.add, size: 16.sp),
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
                    style: TextStyle(color: Colors.red, fontSize: 10.sp),
                  ),
                ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 38.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: controller.couponController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12.sp),
                        onChanged: (value) {
                          controller.couponError = null;
                          controller.appliedCoupon = "";
                          controller.update();
                        },
                        onSubmitted: (value) async {
                          final coupon = controller.couponController.text
                              .trim();
                          if (controller.cart == null ||
                              controller.cart!.items.isEmpty)
                            return;
                          if (coupon.isEmpty) {
                            controller.couponError = "Enter coupon code";
                            controller.update();
                            return;
                          }
                          await controller.getCart(couponCode: coupon);
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintText: "Coupon Code",
                          hintStyle: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.black,
                          ),

                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  GestureDetector(
                    onTap: () async {
                      final coupon = controller.couponController.text.trim();

                      if (controller.cart == null ||
                          controller.cart!.items.isEmpty)
                        return;

                      if (coupon.isEmpty) {
                        controller.couponError = "Enter coupon code";
                        controller.update();
                        return;
                      }

                      await controller.getCart(couponCode: coupon);
                    },
                    child: Container(
                      height: 36.h,
                      width: 72.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff6CCF4F),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (controller.couponError?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    controller.couponError!,
                    style: TextStyle(color: Colors.red, fontSize: 10.sp),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
