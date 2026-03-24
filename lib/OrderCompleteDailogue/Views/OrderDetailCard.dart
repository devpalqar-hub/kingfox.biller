import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';

class OrderDetailsCard extends StatelessWidget {
  final CartModel cart;
  const OrderDetailsCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 730.w,
      height: 320.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 20.sp, color: const Color(0xFF1D2939)),
              SizedBox(width: 10.w),
              Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D2939),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          /// Table headers
          Row(
            children: [
              SizedBox(width: 200.w, child: Text("ITEM", style: _headerStyle())),
              SizedBox(width: 120.w, child: Text("SIZE", style: _headerStyle())),
              SizedBox(width: 80.w, child: Text("QTY", style: _headerStyle())),
              SizedBox(width: 120.w, child: Text("PRICE", style: _headerStyle())),
              SizedBox(width: 120.w, child: Text("TOTAL", style: _headerStyle())),
            ],
          ),

          SizedBox(height: 20.h),

          /// Items list
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _CartItem(
                    title: item.productName,
                    sku: "SKU: ${item.sku}",
                    size: item.size,
                    qty: item.quantity.toString(),
                    price: "₹${item.price}",
                    total: "₹${item.lineTotal}",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _CartItem({
    required String title,
    required String sku,
    required String size,
    required String qty,
    required String price,
    required String total,
  }) {
    return Row(
      children: [
        /// ITEM
        SizedBox(
          width: 200.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D2939),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                sku,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),

        /// SIZE
        SizedBox(
          width: 120.w,
          child: Text(size, style: _valueStyle()),
        ),

        /// QTY
        SizedBox(
          width: 80.w,
          child: Text(qty, style: _valueStyle()),
        ),

        /// PRICE
        SizedBox(
          width: 120.w,
          child: Text(price, style: _valueStyle()),
        ),

        /// TOTAL
        SizedBox(
          width: 120.w,
          child: Text(
            total,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2E9F4B),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF667085),
    );
  }

  TextStyle _valueStyle() {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF1D2939),
    );
  }
}