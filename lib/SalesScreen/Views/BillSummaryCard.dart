import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/OrderCompleteDailogue.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';
import 'package:kinfox_biller/SalesScreen/Service/PreviewController.dart';
import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OrderSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/VoucherSelectionCard.dart';

class BillSummaryCard extends StatefulWidget {
  const BillSummaryCard({super.key});

  @override
  State<BillSummaryCard> createState() => _BillSummaryCardState();
}

class _BillSummaryCardState extends State<BillSummaryCard> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final voucherCountController = TextEditingController();
 

  final previewController = Get.put(PreviewController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (cartController) {
        return Column(
          children: [
            /// Customer
            CustomerCard(
              nameController: nameController,
              phoneController: phoneController,
            ),

            SizedBox(height: 15.h),

            /// Voucher + Coupon
            VoucherSelectionCard(
              voucherCountController: voucherCountController,
            ),

            SizedBox(height: 15.h),

            /// 🔥 ONLY THIS PART LISTENS TO PREVIEW
            GetBuilder<PreviewController>(
              builder: (previewController) {
                final data = previewController.preview;

                if (previewController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return OrderSummaryCard(
  subtotal: data?.subtotal ?? 0,
  tax: data?.gstAmount ?? 0,
  exchangeCredit: 0,
  coupon: data?.discount ?? 0,
  storeDiscount: 0,
  grandTotal: data?.finalAmount ?? 0,
                                                       onPrint: () async {
  final cartController = Get.find<AddProductController>();

  final success = await cartController.checkoutCart(
    paymentMethod: "cash",
    customerName: nameController.text,
    customerPhone: phoneController.text,
    couponCode: cartController.appliedCoupon,
    campaignId: cartController.selectedCampaign?.id,
    voucherCount:
        int.tryParse(voucherCountController.text) ?? 0,
  );

  if (success) {
   
  Get.dialog(
    OrderCompleteDialog(
      cart: cartController.completedOrder!,
      invoiceNumber: cartController.invoiceNumber ?? "N/A",
    ),
    barrierDismissible: false,
  );

    

    
    cartController.cart = null;
    cartController.items.clear();
    cartController.appliedCoupon = "";
     previewController.preview = null;
    cartController.update();
    previewController.update();
  } else {
    Get.snackbar("Error", "Checkout Failed");
  }
},
);
              },
            ),
          ],
        );
      },
    );
  }
}