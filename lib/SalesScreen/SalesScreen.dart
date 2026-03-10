import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';
import 'package:kinfox_biller/SalesScreen/Views/BillSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/CartCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/NoProductsCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/ScanSearch.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  final TextEditingController scanController = TextEditingController();
  final AddProductController controller = Get.put(AddProductController());

  @override
  void initState() {
    super.initState();
    controller.getCart();
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
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// LEFT SIDE
                        SizedBox(
                          width: 780.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// Scan Search
                              ScanSearch(
                                controller: scanController,
                                onReturnTap: () {},
                              ),

                              SizedBox(height: 10.h),

                              /// Search Result List
                              if (controller.searchProductsList.isNotEmpty)
                                Container(
                                  width: 780.w,
                                  constraints: BoxConstraints(maxHeight: 300.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.searchProductsList.length,
                                    itemBuilder: (context, index) {
                                      final product =
                                          controller.searchProductsList[index];
                                      return _buildProductItem(product, controller);
                                    },
                                  ),
                                ),

                              SizedBox(height: 20.h),

                              /// CART SECTION
                              if (controller.cart == null ||
                                  controller.cart!.items.isEmpty)
                                const NoProductsCard()
                              else
                                CartCard(
                                  items: controller.cart!.items,
                                  cartId: controller.cart!.cartId,
                                ),
                            ],
                          ),
                        ),

                        SizedBox(width: 16.w),

                        /// BILL SUMMARY
                        const BillSummaryCard(),
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
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [

          /// Product Image
          Container(
            height: 55.h,
            width: 55.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.image_outlined,
              color: Colors.grey,
              size: 28.sp,
            ),
          ),

          SizedBox(width: 12.w),

          /// Product Details
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
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          /// Price + Add Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${product.sellingPrice}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 6.h),

              InkWell(
                onTap: () async {
                  await controller.scanAndAddProduct(product.barcode, 5);
                  controller.searchProductsList.clear();
                  scanController.clear();
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add_shopping_cart,
                          color: Colors.white, size: 16.sp),
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