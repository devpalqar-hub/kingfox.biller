import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/OrderCompleteDailogue.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OrderSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/VoucherSelectionCard.dart';

class BillSummaryCard extends StatefulWidget {
  const BillSummaryCard({super.key});

  @override
  State<BillSummaryCard> createState() => _BillSummaryCardState();
}

class _BillSummaryCardState extends State<BillSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (cartController) {
        /// ✅ DEFINE CART HERE
        final cart = cartController.cart;

        /// 🔥 LOADING
        if (cartController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
        

            /// ================= VOUCHER =================
            VoucherSelectionCard(),

            SizedBox(height: 15.h),

            OrderSummaryCard(
              subtotal: cart?.subtotal ?? 0,
              tax: cart?.gstAmount ?? 0,

              exchangeCredit: cart?.returnCredit ?? 0,
              coupon: cart?.couponDiscountAmount ?? 0,
              appliedReturnDiscount: cart?.appliedReturnDiscount ?? 0,
              refundAmount: cart?.refundAmount ?? 0,
              grandTotal: (cart?.couponDiscountAmount ?? 0) > 0
                  ? cart!.finalAmountAfterCoupon
                  : cart?.finalAmount ?? 0,

              onPrint: () async {
                if (cart == null) {
                  Get.snackbar("Error", "Cart is empty");
                  return;
                }

                final success = await cartController.checkoutCart(
                  paymentMethod: "cash",
                  customerName: cartController.nameController.text,
                  customerPhone: cartController.phoneController.text,
                  couponCode: cartController.appliedCoupon,
                  campaignId: cartController.selectedCampaign?.id,
                  voucherCount:
                      int.tryParse(
                        cartController.voucherCountController.text,
                      ) ??
                      0,
                );

                if (success) {
                  Get.dialog(
                    OrderCompleteDialog(
                      cart: cartController.completedOrder!,
                      invoiceNumber: cartController.invoiceNumber ?? "N/A",

                      /// ✅ PASS THESE
                      subtotal: cart.subtotal,
                      tax: cart.gstAmount,
                      discount: cart.couponDiscountAmount,
                      refundAmount: cart.refundAmount,
                      total: cart.grandFinalTotal,
                    ),
                  );

                  /// RESET
                  cartController.couponController.clear();
                  cartController.voucherCountController.clear();

                  cartController.cart = null;
                  cartController.items.clear();
                  cartController.appliedCoupon = "";

                  cartController.update();
                } else {
                 // Get.snackbar("Error", "Checkout Failed");
                }
              },
            ),
          ],
        );
      },
    );
  }
}
