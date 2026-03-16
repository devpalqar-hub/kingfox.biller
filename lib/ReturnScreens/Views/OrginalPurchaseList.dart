import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:kinfox_biller/ReturnScreens/Service/ReturnController.dart';

class OriginalPurchaseList extends StatelessWidget {
  const OriginalPurchaseList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnController>(
      builder: (controller) {

        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.invoice?.items ?? [];

        return Container(
          width: 830.w,
          decoration: BoxDecoration(
            color: const Color(0xffF3F4F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [

              /// HEADER
              Container(
                height: 70.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Original Purchase List",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${items.length} ITEMS TOTAL",
                      style: TextStyle(
                        fontSize: 12.sp,
                        letterSpacing: 1.3,
                        color: const Color(0xff94A3B8),
                      ),
                    )
                  ],
                ),
              ),

              _divider(),

              /// ITEMS FROM API
              ...List.generate(items.length, (index) {

                final item = items[index];

                return Column(
                  children: [

                    _itemTile(
                      title: item.variant?.product?.name ?? "No Product",
                      sku: "SKU: ${item.variant?.sku ?? "-"}",
                      price: "₹${item.price ?? "0"}",
                      maxQty: item.quantity ?? 1,
                    ),

                    if (index != items.length - 1) _divider(),
                  ],
                );
              })
            ],
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Container(
      height: 1.h,
      color: const Color(0xffE5E7EB),
    );
  }

  Widget _itemTile({
    required String title,
    required String sku,
    required String price,
    required int maxQty,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// PRODUCT IMAGE PLACEHOLDER
          Container(
            height: 84.w,
            width: 84.w,
            decoration: BoxDecoration(
              color: const Color(0xffF1F5F9),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: const Icon(Icons.inventory),
          ),

          SizedBox(width: 18.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE + PRICE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            sku,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff16A34A),
                          ),
                        ),
                        Text(
                          "Unit Price",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff94A3B8),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 14.h),

                /// PURCHASED QTY
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Purchased: $maxQty",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xff94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}