import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';

class OrderDetailsCard extends StatelessWidget {
  final CartModel cart;
  const OrderDetailsCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Table header row
          Container(
            color: const Color(0xFFF8FAFC),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Text('PRODUCT', style: _headerStyle()),
                ),
                SizedBox(
                  width: 48.w,
                  child: Text(
                    'SIZE',
                    style: _headerStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 34.w,
                  child: Text(
                    'QTY',
                    style: _headerStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 64.w,
                  child: Text(
                    'RATE',
                    style: _headerStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 72.w,
                  child: Text(
                    'AMOUNT',
                    style: _headerStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE2E8F0)),

          /// Item rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 0.5,
              thickness: 0.5,
              color: Color(0xFFE2E8F0),
            ),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _ItemRow(
                name: item.productName,
                sku: 'SKU: ${item.sku}',
                size: item.size,
                qty: item.quantity.toString(),
                rate: '₹${item.price}',
                amount: '₹${item.lineTotal}',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _ItemRow({
    required String name,
    required String sku,
    required String size,
    required String qty,
    required String rate,
    required String amount,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  sku,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 48.w,
            child: Text(size, style: _valueStyle(), textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 34.w,
            child: Text(qty, style: _valueStyle(), textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 64.w,
            child: Text(rate, style: _valueStyle(), textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 72.w,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF15803D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF94A3B8),
    letterSpacing: 0.6,
  );

  TextStyle _valueStyle() => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF334155),
  );
}
