import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';

class CartCard extends StatelessWidget {
  final List<CartItemModel> items;
  final int? cartId;

  const CartCard({
    super.key,
    required this.items,
    
    this.cartId,

  });

  @override
  
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              
              children: [
                Text(
                  "Current Order (${items.length} Items)",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 330.w,),
                Text(
                  "Order ID: #POS-${cartId ?? '---'}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                  SizedBox(width: 20.w,),
                IconButton(
                 icon: Icon(Icons.close),
                  onPressed: () {
                  Get.defaultDialog(
                  title: "Clear Cart",
                   middleText: "Are you sure you want to remove all items?",
                   textConfirm: "Yes",
                   textCancel: "No",
                    onConfirm: () {
                      Get.find<AddProductController>().deleteCart();
                      Get.back();
                         },
                             );
                                 },
                                  )
              ],
            ),
          ),

          const Divider(height: 1),

        
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

         
          ...items.map((item) {
            return Column(
              children: [
                _cartItem(
  variantId: item.variantId ?? 0,
  title: item.productName ?? "",
  subtitle: "Size: ${item.size ?? "-"} | ${item.color ?? "-"}",
  sku: item.sku ?? "",
  quantity: item.quantity ?? 1,
  price: "₹${item.price ?? 0}",
  total: "₹${item.lineTotal ?? 0}",
),
                const Divider(height: 1),
              ],
            );
          }).toList(),
        ],
      ),
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

  Widget _cartItem({
    required String title,
    required String subtitle,
    required String sku,
    required int quantity,
    required String price,
    required String total,
    required int variantId,
    

  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      child: Row(
        children: [

        
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
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
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

       
          Expanded(
            flex: 2,
            child: Text(
              sku,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF667085),
              ),
            ),
          ), 
                                   Expanded(
  flex: 2,
  child: Row(
    children: [
      Text(
        quantity.toString(),
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
            onTap: () {
              Get.find<AddProductController>()
                  .updateCartItemQuantity(variantId, quantity + 1);
            },
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 18.sp,
              color: Colors.grey,
            ),
          ),

          InkWell(
            onTap: () {
              if (quantity > 1) {
                Get.find<AddProductController>()
                    .updateCartItemQuantity(variantId, quantity - 1);
              }
            },
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ],
  ),
),
      
                

        
          Expanded(
            flex: 1,
            child: Text(
              price,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF475467),
              ),
            ),
          ),

         
          Expanded(
            flex: 1,
            child: Text(
              total,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF16A34A),
              ),
            ),
          ),

          
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