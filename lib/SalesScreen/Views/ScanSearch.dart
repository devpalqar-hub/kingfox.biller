import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';
import 'package:kinfox_biller/SalesScreen/Views/ScanPage.dart';

class ScanSearch extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onReturnTap;

  const ScanSearch({
    super.key,
    required this.controller,
    required this.onReturnTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (productController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffE5E7EB),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final barcode = await Get.to(() => const ScanPage());

                          if (barcode != null) {
                            productController.scanAndAddProduct(
                              barcode,
                              5,
                            );
                          }
                        },
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 20.sp,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 10.w),
                     Expanded(
  child: TextField(
    controller: controller,
    textAlignVertical: TextAlignVertical.center, // ✅ FIX
    onChanged: (value) {
      if (value.isNotEmpty) {
        productController.searchProducts(value);
      } else {
        productController.searchProductsList.clear();
        productController.update();
      }
    },
    onSubmitted: (value) {
      if (value.isNotEmpty) {
        productController.scanAndAddProduct(value, 5);
        controller.clear();

        productController.searchProductsList.clear();
        productController.update();
      }
    },
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: "Scan barcode or search products",
      hintStyle: TextStyle(fontSize: 15.sp),
     
      
      isCollapsed: true,
       isDense: true,

      contentPadding: EdgeInsets.symmetric(vertical: 14.h), // ✅ FIX

      /// ✅ KEEP SIZE CONSTANT
      suffixIcon: SizedBox(
        width: 30.w,
        child: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  controller.clear();
                  productController.searchProductsList.clear();
                  productController.update();
                },
              )
            : const SizedBox(),
      ),
    ),
  ),
)
                    ],
                  ),
                ),
              ),

              SizedBox(width: 15.w),
              ReturnButton(onTap: onReturnTap),
            ],
          ),
        );
      },
    );
  }
}

class ReturnButton extends StatelessWidget {
  final VoidCallback onTap;

  const ReturnButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 45.h, // ✅ prevents collapse
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 10.h, // ✅ reduced for small screens
        ),
        decoration: BoxDecoration(
          color: const Color(0xffFEF2F2),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xffFECACA)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // ✅ wrap content
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.red,
              size: 16.sp, // slightly increased for balance
            ),
            SizedBox(width: 6.w),

            /// ✅ Flexible text to avoid overflow
            Flexible(
              child: Text(
                "Return Item",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}