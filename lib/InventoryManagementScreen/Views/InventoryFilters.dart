import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryFilters extends StatelessWidget {
  const InventoryFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search SKU or Product",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          _filterbutton("All"),
          SizedBox(width: 10.w),
          _filterbutton("Low Stock"),
          SizedBox(width: 10.w),
          _filterbutton("Out of Stock"),
        ],
      ),
    );
  }

  Widget _filterbutton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: text == "All" ? Colors.black : const Color(0xffE2E8F0),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: text == "All" ? Colors.white : Colors.black,
            fontSize: 12.sp),
      ),
    );
  }
}