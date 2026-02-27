import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryCardsRow extends StatelessWidget {
  const InventoryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _card("TOTAL SKUS", "1,432", Colors.white, Colors.black)),
        SizedBox(width: 20.w),
        Expanded(child: _card("LOW STOCK ALERTS", "18 Items",
            const Color(0xffFDE68A), Colors.black)),
        SizedBox(width: 20.w),
        Expanded(child: _card("INVENTORY VALUE", "₹14,82,500",
            const Color(0xff0F172A), Colors.white)),
      ],
    );
  }

  Widget _card(String title, String value, Color bg, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor.withOpacity(.7),
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10.h),
          Text(value,
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
        ],
      ),
    );
  }
}