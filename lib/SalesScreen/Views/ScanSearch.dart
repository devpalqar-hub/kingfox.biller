import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';
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
            borderRadius: BorderRadius.circular(20.r),
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
    Get.find<AddProductController>().scanAndAddProduct(barcode, 5);
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
    onChanged: (value) {
      if (value.length >= 3) {
        productController.searchProducts(value);
      } else if (value.isEmpty) {
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
      isCollapsed: true,
      isDense: true,
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () {
                controller.clear();

                productController.searchProductsList.clear();
                productController.update();
              },
            )
          : null,
    ),
  ),
),
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
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        height: 53.h,
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xffFEF2F2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xffFECACA)),
        ),
        child: Row(
          children: [
            Icon(Icons.arrow_back,
                color: Colors.red, size: 14.sp),
            SizedBox(width: 8.w),
            Text(
              "Return Item",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}