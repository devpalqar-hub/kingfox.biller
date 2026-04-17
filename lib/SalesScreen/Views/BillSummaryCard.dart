import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/OrderCompleteDailogue.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';
import 'package:kinfox_biller/SalesScreen/Views/ManualDiscountCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OrderSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/VoucherSelectionCard.dart';

class BillSummaryCard extends StatelessWidget {
  const BillSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (ctrl) {
        // if (ctrl.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        final cart = ctrl.cart;
        return SingleChildScrollView(
          child: Column(
            children: [
              const ManualDiscountCard(),
              SizedBox(height: 8.h),
              const VoucherSelectionCard(),
              SizedBox(height: 8.h),
              OrderSummaryCard(
                subtotal: cart?.subtotal ?? 0,
                tax: cart?.gstAmount ?? 0,
                exchangeCredit: cart?.returnCredit ?? 0,
                coupon: cart?.couponDiscountAmount ?? 0,
                appliedReturnDiscount: cart?.appliedReturnDiscount ?? 0,
                refundAmount: cart?.refundAmount ?? 0,
                grandTotal: cart?.grandFinalTotal ?? 0,
                onPrint: () async {
                  if (cart == null) {
                    Get.snackbar('Error', 'Cart is empty');
                    return;
                  }
                  final ok = await ctrl.checkoutCart(
                    paymentMethod: 'cash',
                    customerName: ctrl.nameController.text,
                    customerPhone: ctrl.phoneController.text,
                    couponCode: ctrl.appliedCoupon,
                    campaignId: ctrl.selectedCampaign?.id,
                    voucherCount:
                        int.tryParse(ctrl.voucherCountController.text) ?? 0,
                  );
                  if (ok) {
                    Get.dialog(
                      OrderCompleteDialog(
                        cart: ctrl.completedOrder!,
                        invoiceNumber: ctrl.invoiceNumber ?? 'N/A',
                        subtotal: cart.subtotal,
                        tax: cart.gstAmount,
                        discount: cart.couponDiscountAmount,
                        refundAmount: cart.refundAmount,
                        total: cart.grandFinalTotal,
                      ),
                    );
                    ctrl.couponController.clear();
                    ctrl.voucherCountController.clear();
                    ctrl.cart = null;
                    ctrl.items.clear();
                    ctrl.appliedCoupon = '';
                    ctrl.update();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
