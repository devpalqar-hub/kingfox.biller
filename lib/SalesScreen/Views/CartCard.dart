import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';

class CartCard extends StatelessWidget {
  final int? cartId;

  CartCard({super.key, this.cartId});

  final AddProductController controller = Get.find<AddProductController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (_) {
        final cartItems = controller.cart?.items ?? [];

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  children: [
                    Text(
                      "Current Order (${cartItems.length} Items)",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Order ID: #POS-${cartId ?? '---'}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Clear Cart",
                          middleText: "Are you sure you want to remove all items?",
                          textConfirm: "Yes",
                          textCancel: "No",
                          onConfirm: () {
                            controller.deleteCart();
                            Get.back();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              /// TABLE HEADERS
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _header("PRODUCT DETAILS")),
                    Expanded(flex: 2, child: _header("SKU")),
                    Expanded(flex: 2, child: _header("QUANTITY")),
                    Expanded(flex: 1, child: _header("PRICE")),
                    Expanded(flex: 1, child: _header("TOTAL")),
                    SizedBox(width: 32.w),
                  ],
                ),
              ),
              const Divider(height: 1),

              /// CART ITEMS using ListView.builder to preserve state
              SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Column(
                      key: ValueKey(item.variantId), // stable key!
                      children: [
                        _cartItem(item),
                        const Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _cartItem(CartItemModel item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      child: Row(
        children: [
          /// PRODUCT DETAILS
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.checkroom,
                    size: 28.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Size: ${item.size} | ${item.color}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// SKU
          Expanded(
            flex: 2,
            child: Text(
              item.sku,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF667085),
              ),
            ),
          ),

          /// QUANTITY
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  item.quantity.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 15.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: controller.isUpdatingQty
                          ? null
                          : () {
                              controller.updateCartItemQuantity(
                                  item.variantId, item.quantity + 1);
                            },
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 18.sp,
                        color: controller.isUpdatingQty
                            ? Colors.grey.shade400
                            : Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: item.quantity > 1 && !controller.isUpdatingQty
                          ? () {
                              controller.updateCartItemQuantity(
                                  item.variantId, item.quantity - 1);
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18.sp,
                        color: item.quantity > 1 && !controller.isUpdatingQty
                            ? Colors.grey
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// PRICE
          Expanded(
            flex: 1,
            child: Text(
              "₹${item.price}",
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF475467),
              ),
            ),
          ),

          /// TOTAL
          Expanded(
            flex: 1,
            child: Text(
              "₹${item.lineTotal}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF16A34A),
              ),
            ),
          ),

          /// DELETE ICON
          SizedBox(
            width: 32.w,
            child: Icon(
              Icons.delete_outline,
              size: 20.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}