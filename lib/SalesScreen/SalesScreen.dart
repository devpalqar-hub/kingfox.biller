import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/ReturnScreen/Service/ReturnController.dart';
import 'package:kinfox_biller/ReturnScreen/ProcessItemReturnDailogue.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';
import 'package:kinfox_biller/SalesScreen/Views/BillSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/CartTable.dart';
import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/NoProductsCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/ScanSearch.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController scanController = TextEditingController();
  late AddProductController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller with permanent flag to prevent disposal on config changes
    controller = Get.put(AddProductController(), permanent: true);
  }

  @override
  void dispose() {
    // Only dispose the local scanController, not the permanent AddProductController
    scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      body: SafeArea(
        child: GetBuilder<AddProductController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 860.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ScanSearch(
                                controller: scanController,
                                onReturnTap: () {
                                  showDialog(
                                    context: Get.context!,
                                    builder: (_) => ProcessItemReturnDialog(),
                                  );
                                },
                              ),

                              SizedBox(height: 12.h),

                               CustomerCard(
              nameController: controller.nameController,
              phoneController: controller.phoneController,
            ),
                               
                              if (controller.searchProductsList.isNotEmpty)
                                Padding(
                                  padding:  EdgeInsets.only(top:10.h),
                                  child: Container(
                                    
                                    constraints: BoxConstraints(maxHeight: 300.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.searchProductsList.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            controller.searchProductsList[index];
                                        return _buildProductItem(
                                          product,
                                          controller,
                                        );
                                      },
                                    ),
                                  ),
                                ),

                              SizedBox(height: 12.h),

                              if (controller.cart == null ||
                                  (controller.cart!.items.isEmpty &&
                                      controller.cart!.returnItems.isEmpty))
                                const NoProductsCard()
                              else
                                CartTableWidget(
                                  cart: controller.cart!,

                                  onIncrease: (variantId) {
                                    if (controller.isUpdatingQty) return;

                                    final item = controller.cart!.items
                                        .firstWhere(
                                          (e) => e.variantId == variantId,
                                        );

                                    controller.updateCartItemQuantity(
                                      item.variantId,
                                      item.quantity + 1,
                                    );
                                  },

                                  onDecrease: (variantId) {
                                    if (controller.isUpdatingQty) return;

                                    final item = controller.cart!.items
                                        .firstWhere(
                                          (e) => e.variantId == variantId,
                                        );

                                    if (item.quantity > 1) {
                                      controller.updateCartItemQuantity(
                                        item.variantId,
                                        item.quantity - 1,
                                      );
                                    }
                                  },

                                  onDelete: (variantId, isReturn) async {
                                    if (controller.isUpdatingQty) return;

                                    if (isReturn) {
                                      final returnController =
                                          Get.find<ReturnsController>();

                                      final success = await returnController
                                          .deleteReturnItemsFromCart([
                                            variantId,
                                          ]);

                                      /// ✅ IMPORTANT: REFRESH CART AFTER DELETE
                                      if (success) {
                                        await controller.getCart();
                                      }
                                    } else {
                                      /// NORMAL ITEM DELETE
                                      await controller.updateCartItemQuantity(
                                        variantId,
                                        0,
                                      );
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),

                        SizedBox(width: 25.w),

                        BillSummaryCard(),
                      ],
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(product, AddProductController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4.r, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 55.h,
            width: 55.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.image_outlined, color: Colors.grey, size: 28.sp),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Size: ${product.size} | ${product.color}",
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${product.sellingPrice}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 6.h),

              InkWell(
                onTap: () async {
                  await controller.scanAndAddProduct(product.barcode, 5);
                  controller.searchProductsList.clear();
                  scanController.clear();
                  controller.resetVoucherSelection();
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
