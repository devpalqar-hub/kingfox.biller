import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';
import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OfferandSummarySection.dart';
import 'package:kinfox_biller/SalesScreen/Views/PaymentSectionCard.dart';

class BillSummaryCard extends StatelessWidget {
  const BillSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final voucherController = TextEditingController();
    final couponController = TextEditingController(); 

    return GetBuilder<AddProductController>(
      builder: (controller) {
        return Container(
          width: 395.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFDCE4DC)),
          ),
          child: Column(
            children: [
              CustomerVoucherCard(
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController,
                addressController: addressController,
                voucherController: voucherController,
              ),

              
              OfferAndSummarySection(
                subtotal: controller.subtotal,
                gstAmount: controller.gstAmount,
                finalAmount: controller.finalAmount, 
                couponController: couponController,
                
              ),

            
              PaymentSectionCard(
                totalAmount: controller.finalAmount,
                onComplete: (paymentMethod) async {
                  await controller.checkoutCart(
                    paymentMethod: paymentMethod,
                    customerName: nameController.text,
                    customerPhone: phoneController.text,
                    customerEmail: emailController.text,
                    customerAddress: addressController.text,
                    voucherCodes: [voucherController.text],
                    couponCode: couponController.text,

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