import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';
import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OfferandSummarySection.dart';
import 'package:kinfox_biller/SalesScreen/Views/PaymentSectionCard.dart';class BillSummaryCard extends StatelessWidget {
  final CartModel? cart;
  const BillSummaryCard({super.key, this.cart});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final couponController = TextEditingController();

    // Reference to the CustomerVoucherCard
    final customerVoucherCard = CustomerVoucherCard(
      nameController: nameController,
      phoneController: phoneController,
    );

    return GetBuilder<AddProductController>(
      builder: (controller) {
        double subtotal = 0;
        double gstAmount = 0;
        double finalAmount = 0;

        final items = controller.cart?.items ?? [];
        for (var item in items) subtotal += item.lineTotal;

        gstAmount = subtotal * 0.05;
        finalAmount = subtotal + gstAmount;

        controller.subtotal = subtotal;
        controller.gstAmount = gstAmount;
        controller.finalAmount = finalAmount;

        return Container(
          width: 395.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFDCE4DC)),
          ),
          child: Column(
            children: [
              customerVoucherCard, // Display voucher card

              OfferAndSummarySection(
                subtotal: subtotal,
                gstAmount: gstAmount,
                finalAmount: finalAmount,
                couponController: couponController,
              ),

              PaymentSectionCard(
                totalAmount: finalAmount,
                onComplete: (paymentMethod) async {
                  if (controller.selectedCampaign == null) {
                    Get.snackbar("Error", "Please select a voucher");
                    return false;
                  }

                  if (customerVoucherCard.voucherCount <= 0) {
                    Get.snackbar("Error", "Enter a valid voucher count");
                    return false;
                  }

                  return await controller.checkoutCart(
                    paymentMethod: paymentMethod,
                    customerName: nameController.text,
                    customerPhone: phoneController.text,
                    customerEmail: emailController.text,
                    customerAddress: addressController.text,
                    couponCode: couponController.text,
                    campaignId: controller.selectedCampaign!.id, // Selected voucher ID
                    voucherCount: customerVoucherCard.voucherCount, // Voucher count
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}