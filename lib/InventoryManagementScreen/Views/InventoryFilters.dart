import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Service/InventoryController.dart';

class InventoryFilters extends StatelessWidget {
  InventoryFilters({super.key});

  final InventoryController controller = Get.put(InventoryController());

  final List<String> filters = [
    "All",
    "Low Stock",
    "Out of Stock"
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryController>(
      builder: (ctrl) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              
              /// 🔍 SEARCH
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
                  onChanged: (value) {
                    /// 👉 You can connect search API here later
                  },
                ),
              ),

              SizedBox(width: 20.w),

              /// 🔥 FILTER BUTTONS
              ...filters.map((filter) {
                final isSelected = ctrl.selectedFilter == filter;

                return Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      ctrl.selectedFilter = filter;

                      /// 🔥 MAP UI FILTER → API PARAM
                      String? status;

                      if (filter == "Low Stock") {
                        status = "LOW_STOCK";
                      } else if (filter == "Out of Stock") {
                        status = "OUT_OF_STOCK";
                      } else {
                        status = null;
                      }

                      /// 🔥 CALL API WITH FILTER
                      ctrl.getInventory(
                        refresh: true,
                        stockStatus: status,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black
                            : const Color(0xffE2E8F0),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}