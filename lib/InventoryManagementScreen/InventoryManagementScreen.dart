import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Views/InventoryCardRow.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Views/InventoryFilters.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Views/InventoryTable.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      floatingActionButton: Container(
        height: 60.h,
        width: 60.h,
        decoration: const BoxDecoration(
          color: Color(0xff0F172A),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inventory Management",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1E293B),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "Manage your retail stock, SKU levels, and product categories.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.file_download_outlined, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text("Export",
                              style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 30.h),

                /// Cards Row
                const InventoryCardsRow(),

                SizedBox(height: 25.h),

                /// Filters
                const InventoryFilters(),

                SizedBox(height: 20.h),

                /// Table
                const InventoryTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}