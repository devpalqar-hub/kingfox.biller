import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Service/ReturnController.dart';
import 'package:kinfox_biller/ReturnScreens/InititateReturnScreen/InitiateReturnScreen.dart';
import 'package:kinfox_biller/ReturnScreens/Service/ReturnFlowController.dart';
import 'package:kinfox_biller/ReturnScreens/Views/RefundPopupCard.dart';

class ReturnSummaryCard extends StatelessWidget {
  const ReturnSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnsController>(
      builder: (controller) {
        final invoice = controller.invoice;

        final selectedCount = controller.selectedItems.length;
        final totalItemsCount = invoice?.items?.length ?? 0;

        return Container(
          width: 320.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xffE32626),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RETURN SUMMARY",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: .8,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "TRANSACTION REF: ${invoice?.invoiceNumber ?? "-"}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              /// BODY
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _summaryRow("SELECTED ITEMS", "$selectedCount"),
                    _summaryRow("SUB TOTAL", "₹${invoice?.subtotal ?? "0.00"}"),
                    _summaryRow("TAX REFUND", "₹${invoice?.tax ?? "0.00"}"),
                    _summaryRow("DISCOUNT", "₹${invoice?.discount ?? "0.00"}", red: true),

                    SizedBox(height: 14.h),
                    Divider(color: Colors.grey.shade300),
                    SizedBox(height: 14.h),

                    /// TOTAL
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "TOTAL REFUND AMOUNT",
                            style: TextStyle(
                              fontSize: 12.sp,
                              letterSpacing: 1.4,
                              color: const Color(0xff8A97A8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "₹${invoice?.finalAmount ?? "0.00"}",
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xffE32626),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// REFUND METHOD
                    Text(
                      "REFUND METHOD",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xff8A97A8),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _methodButton("Online", selected: true)),
                        SizedBox(width: 12.w),
                        Expanded(child: _methodButton("Cash")),
                      ],
                    ),

                    SizedBox(height: 22.h),

                    /// PROCESS REFUND
                    GestureDetector(
                      onTap: () {
                        if (selectedCount == 0) {
                          Get.snackbar("Error", "Please select at least one item");
                          return;
                        }

                        final returnType = selectedCount == totalItemsCount
                            ? "INVOICE"
                            : "PARTIAL_RETURN";

                        // Prepare dynamic refund items
                        List<RefundItem> refundItems = controller.selectedItems.map((variantId) {
                          final item = invoice?.items
                              ?.firstWhere((e) => e.variant?.id == variantId);
                           return RefundItem(
  image: item?.variant?.color ?? "assets/placeholder.png",
  name: item?.variant?.product?.name ?? "Item",
  details: "QTY: ${item?.quantity ?? 1} • SKU: ${item?.variant?.sku ?? "-"}",
);
                        }).toList();

                        
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => RefundSuccessPopup(
                            totalRefund: double.tryParse(invoice?.finalAmount ?? "0.0") ?? 0.0,
                            method: "Cash", 
                            reference: "RET-${invoice?.invoiceNumber ?? "0000"}",
                            items: refundItems,
                          ),
                        );

                        
                        for (var variantId in controller.selectedItems) {
                          final item = invoice?.items
                              ?.firstWhere((e) => e.variant?.id == variantId);
                          if (item != null) {
                            controller.createReturn(
                              invoiceId: invoice!.id!,
                              variantId: variantId,
                              quantity: item.quantity ?? 1,
                              reason: "Customer Request",
                              returnType: returnType,
                            );
                          }
                        }

                        controller.selectedItems.clear();
                        controller.update();
                      },
                      child: Container(
                        height: 58.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffE32626),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "PROCESS REFUND  »",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    
                  GestureDetector(
                           onTap: () {
                     final controller = Get.find<ReturnFlowController>();
                    controller.backToInitiate(); 
                    controller.update();   
                         },
                        child: Container(
                         height: 52.h,
                          decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                            borderRadius: BorderRadius.circular(30.r),
                           ),
                            alignment: Alignment.center,
                             child: Text( "Cancel & Go Back",
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xff64748B),
      ),
    ),
  ),
),
                    SizedBox(height: 16.h),
                     Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.red, size: 18.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "Refunds will be processed to the original payment method.",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryRow(String title, String value, {bool red = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              letterSpacing: 1,
              color: const Color(0xff667085),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: red ? const Color(0xffE32626) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodButton(String text, {bool selected = false}) {
    return Container(
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xffDDE3DF) : Colors.transparent,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: selected ? Colors.black : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff344054),
        ),
      ),
    );
  }
}