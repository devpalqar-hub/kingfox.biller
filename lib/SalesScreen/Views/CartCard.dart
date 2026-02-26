import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartCard extends StatelessWidget {
  const CartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [

          /// HEADER
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current Order (2 Items)",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Order ID: #POS-8829",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// TABLE HEADER
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(flex: 3, child: _header("PRODUCT DETAILS")),
                Expanded(flex: 2, child: _header("SKU")),
                Expanded(flex: 2, child: _header("QUANTITY")),
                Expanded(flex: 1, child: _header("PRICE")),
                Expanded(flex: 1, child: _header("TOTAL")),
                SizedBox(width: 32.w), // delete column space
              ],
            ),
          ),

          const Divider(height: 1),

          _cartItem(
            title: "Slim Fit Denim Shirt",
            subtitle: "Size: M | Blue",
            sku: "DNM-001",
            quantity: 2,
            price: "₹1,499",
            total: "₹2,998",
          ),

          const Divider(height: 1),

          _cartItem(
            title: "Casual Cotton T-Shirt",
            subtitle: "Size: L | Black",
            sku: "COT-042",
            quantity: 1,
            price: "₹799",
            total: "₹799",
          ),
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
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 20.w, vertical: 22.h),
      child: Row(
        children: [

          /// PRODUCT
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius:
                        BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.checkroom,
                      size: 28.sp,
                      color: const Color(0xFF9CA3AF)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
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

          /// SKU
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

          /// QUANTITY
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _qtyButton(Icons.remove, Colors.red),
                SizedBox(width: 10.w),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 10.w),
                _qtyButton(Icons.add, Colors.green),
              ],
            ),
          ),

          /// PRICE
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

          /// TOTAL
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

  Widget _qtyButton(IconData icon, Color color) {
    return Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD0D5DD),
        ),
      ),
      child: Icon(icon, color: color, size: 16.sp),
    );
  }
}