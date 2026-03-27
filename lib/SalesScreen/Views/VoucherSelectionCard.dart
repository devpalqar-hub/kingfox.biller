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
              /// TITLE
              Row(
                children: [
                  Icon(Icons.card_giftcard, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Gift Vouchers",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              /// DROPDOWN + COUNT
              Row(
                children: [
                  Expanded(
                    child: Container(
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

                  SizedBox(width: 10.w),

                  /// COUNT FIELD
                  Container(
                    width: 60.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: controller.voucherCountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 14.sp),
                      onChanged: (value) {
                        if (value.isEmpty || value == "0") {
                          controller.voucherCountController.text = "1";
                          controller.voucherCountController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: controller
                                  .voucherCountController.text.length,
                            ),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "1",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: (45.h - 14.sp) / 2,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  /// PLUS BUTTON
                  GestureDetector(
                    onTap: controller.updateVoucherCount,
                    child: Container(
                      height: 40.h,
                      width: 40.w,
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
              if (controller.voucherError != null &&
    controller.voucherError!.isNotEmpty)
  Padding(
    padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
    child: Text(
      controller.voucherError!,
      style: TextStyle(
        color: Colors.red,
        fontSize: 11.sp,
      ),
    ),
  ),

              /// COUPON SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// INPUT
                      Expanded(
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border:
                                Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, size: 18.sp),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: TextField(
                                  controller:
                                      controller.couponController,
                                  textAlignVertical:
                                      TextAlignVertical.center,

                                  /// ✅ FIX: CLEAR ERROR + RESET COUPON
                                  onChanged: (value) {
                                    controller.couponError = null;
                                    controller.appliedCoupon = "";
                                    controller.update();
                                  },

                                  style: TextStyle(fontSize: 14.sp),
                                  decoration: InputDecoration(
                                    hintText: "Coupon Code",
                                    hintStyle:
                                        TextStyle(fontSize: 12.sp),
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(
                                      vertical: (45.h - 14.sp) / 2,
                                    ),
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
                          final coupon = controller
                              .couponController.text
                              .trim();

                          if (controller.cart == null ||
                              controller.cart!.items.isEmpty) {
                            return;
                          }

                          /// ✅ EMPTY CHECK
                          if (coupon.isEmpty) {
                            controller.couponError =
                                "Enter coupon code";
                            controller.update();
                            return;
                          }

                          /// ✅ API CALL (controller handles error)
                          await controller.getCart(
                            couponCode: coupon,
                          );
                        },
                        child: Container(
                          height: 38.h,
                          width: 100.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff6CCF4F),
                            borderRadius:
                                BorderRadius.circular(14.r),
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

                  /// ERROR TEXT
                  if (controller.couponError != null &&
                      controller.couponError!.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.only(top: 6.h, left: 4.w),
                      child: Text(
                        controller.couponError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}