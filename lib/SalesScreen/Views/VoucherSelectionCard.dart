import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

class VoucherSelectionCard extends StatelessWidget {
  const VoucherSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: GetBuilder<AddProductController>(
        builder: (ctrl) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vouchers & Coupons",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ), // Increased
              SizedBox(height: 8.h),

              /// Voucher Dropdown & Counter
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 34.h, // Increased
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: Text(
                            "Select Voucher",
                            style: TextStyle(fontSize: 13.sp),
                          ), // Increased
                          value: ctrl.selectedCampaign?.id,
                          icon: Icon(Icons.expand_more, size: 18.sp),
                          items: [
                            DropdownMenuItem<int>(
                              value: null,
                              child: Text(
                                "None",
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ), // Increased
                            ...ctrl.campaigns.map(
                              (c) => DropdownMenuItem<int>(
                                value: c.id,
                                child: Text(
                                  c.name,
                                  style: TextStyle(fontSize: 13.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ), // Increased
                          ],
                          onChanged: (val) {
                            if (val == null) {
                              ctrl.selectedCampaign = null;
                              ctrl.voucherCountController.text = "1";
                            } else {
                              ctrl.selectCampaign(
                                ctrl.campaigns.firstWhere((c) => c.id == val),
                              );
                            }
                            ctrl.update();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _qtyBtn(Icons.remove, () {
                    int curr =
                        int.tryParse(ctrl.voucherCountController.text) ?? 1;
                    if (curr > 1) {
                      ctrl.voucherCountController.text = (--curr).toString();
                      ctrl.update();
                    }
                  }),
                  Container(
                    width: 38.w,
                    height: 34.h, // Increased
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      ctrl.voucherCountController.text,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ), // Increased
                  ),
                  _qtyBtn(Icons.add, ctrl.updateVoucherCount),
                ],
              ),
              if (ctrl.voucherError?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    ctrl.voucherError!,
                    style: TextStyle(color: Colors.red, fontSize: 11.sp),
                  ),
                ),

              SizedBox(height: 8.h),

              /// Coupon Input
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 34.h, // Increased
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: ctrl.couponController,
                        style: TextStyle(fontSize: 13.sp), // Increased
                        onChanged: (_) {
                          ctrl.couponError = null;
                          ctrl.appliedCoupon = "";
                          ctrl.update();
                        },
                        onSubmitted: (_) => _applyCoupon(ctrl),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Coupon Code",
                          hintStyle: TextStyle(fontSize: 13.sp), // Increased
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => _applyCoupon(ctrl),
                    child: Container(
                      height: 34.h,
                      width: 70.w, // Increased
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff16A34A),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ), // Increased
                    ),
                  ),
                  if (ctrl.appliedCoupon.isNotEmpty ||
                      ctrl.couponController.text.isNotEmpty) ...[
                    SizedBox(width: 6.w),
                    InkWell(
                      onTap: () {
                        ctrl.couponError = "";
                        ctrl.couponController.clear();
                        ctrl.appliedCoupon = "";
                        ctrl.update();
                        ctrl.getCart();
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 22.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
              if (ctrl.couponError?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    ctrl.couponError!,
                    style: TextStyle(color: Colors.red, fontSize: 11.sp),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        width: 34.w, // Increased
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 16.sp),
      ),
    );
  }

  void _applyCoupon(AddProductController ctrl) async {
    final code = ctrl.couponController.text.trim();
    if (ctrl.cart == null || ctrl.cart!.items.isEmpty) return;
    if (code.isEmpty) {
      ctrl.couponError = "Enter coupon code";
      ctrl.update();
      return;
    }
    await ctrl.getCart(couponCode: code);
  }
}
