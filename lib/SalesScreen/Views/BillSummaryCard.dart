import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';
import 'package:kinfox_biller/SalesScreen/Views/ManualDiscountCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OrderSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/PaymentMethodCrad.dart';
import 'package:kinfox_biller/SalesScreen/Views/VoucherSelectionCard.dart';

class BillSummaryCard extends StatelessWidget {
  const BillSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (ctrl) {
        final cart = ctrl.cart;

        return Column(
          children: [
            // ── Scrollable area ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  children: [
                    const ManualDiscountCard(),
                    SizedBox(height: 8.h),
                    const VoucherSelectionCard(),
                    SizedBox(height: 8.h),
                    const PaymentMethodCard(),
                    SizedBox(height: 8.h),
                    OrderSummaryCard(
                      subtotal: cart?.subtotal ?? 0,
                      tax: cart?.gstAmount ?? 0,
                      exchangeCredit: cart?.returnCredit ?? 0,
                      coupon: cart?.couponDiscountAmount ?? 0,
                      appliedReturnDiscount: cart?.appliedReturnDiscount ?? 0,
                      refundAmount: cart?.refundAmount ?? 0,
                      grandTotal: cart?.grandFinalTotal ?? 0,
                      onPrint: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Fixed bottom: Grand Total + Print Button ──────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 16.h),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 20.h,
                  ),
                  SizedBox(height: 3.h),

                  // Grand Total Label
                  const Text(
                    "GRAND TOTAL",
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff64748B),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Amount
                  Text(
                    "₹${(cart?.grandFinalTotal ?? 0).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1D4ED8),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Print Button
                  GestureDetector(
                    onTap: () async {
                      if (cart == null) return;

                      final ok = await ctrl.checkoutCart(
                        paymentMethod: ctrl.selectedPaymentMethod,
                        customerName: ctrl.nameController.text,
                        customerPhone: ctrl.phoneController.text,
                        couponCode: ctrl.appliedCoupon,
                        campaignId: ctrl.selectedCampaign?.id,
                        voucherCount:
                            int.tryParse(ctrl.voucherCountController.text) ?? 0,
                      );

                      if (ok) {
                        ctrl.couponController.clear();
                        ctrl.voucherCountController.text = "0";
                        ctrl.cart = null;
                        ctrl.items.clear();
                        ctrl.appliedCoupon = '';
                        ctrl.update();
                      }
                    },
                    child: Container(
                      height: 42.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff1D4ED8),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.print, color: Colors.white, size: 22.sp),
                          SizedBox(width: 10.w),
                          Text(
                            "PRINT ( F1 )",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
