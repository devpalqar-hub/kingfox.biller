import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/OrderDetailCard.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/PaymentInformationCard.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/PaymentSummaryCard.dart';

class OrderCompleteDialog extends StatelessWidget {
  final CartModel cart;
  final String invoiceNumber;

  /// ✅ ADD THESE
  final double subtotal;
  final double tax;
  final double discount;
  final double refundAmount;
  final double total;

  const OrderCompleteDialog({
    super.key,
    required this.cart,
    required this.invoiceNumber,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.refundAmount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 40.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Container(
              width: 1320.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xffF1F5F9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: const Color(0xFFE6F4EA),
                      child: Icon(
                        Icons.check,
                        size: 40.sp,
                        color: Colors.green,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      "Order Completed Successfully",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Invoice Number: $invoiceNumber",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 15.h),

                    SizedBox(
                      width: 1100.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 750.w,
                            child: Column(
                              children: [
                                OrderDetailsCard(cart: cart),
                                SizedBox(height: 20.h),
                               PaymentInformationCard(
  paymentDateTime: DateTime.now(),
  paidAmount: total,
),
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          SizedBox(
                            width: 320.w,
                            child:PaymentSummaryCard(
  subtotal: subtotal,
  tax: tax,
  discount: discount,
  refundAmount: refundAmount,
  total: total,
),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
