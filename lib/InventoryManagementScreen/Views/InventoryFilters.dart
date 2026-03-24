import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Service/InventoryController.dart';

class InventoryFilters extends StatefulWidget {
  const InventoryFilters({super.key});

  @override
  State<InventoryFilters> createState() => _InventoryFiltersState();
}

class _InventoryFiltersState extends State<InventoryFilters> {

  final InventoryController controller = Get.find();

  final TextEditingController searchController = TextEditingController();

  Timer? debounce;

  final List<String> filters = [
    "All",
    "Low Stock",
    "Out of Stock"
  ];

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

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

              /// 🔍 SEARCH FIELD
              Expanded(
                child: TextField(
                  controller: searchController,

                  onChanged: (value) {

                    if (debounce?.isActive ?? false) {
                      debounce!.cancel();
                    }

                    debounce = Timer(
                      const Duration(milliseconds: 500),
                      () {

                        String? status;
                        if (ctrl.selectedFilter == "Low Stock") {
                          status = "LOW_STOCK";
                        } else if (ctrl.selectedFilter == "Out of Stock") {
                          status = "OUT_OF_STOCK";
                        }

                        if (value.isEmpty) {
                          ctrl.searchQuery = "";
                          ctrl.getInventory(
                            refresh: true,
                            stockStatus: status,
                          );
                        } else {
                          ctrl.getInventoryBySearch(
                            refresh: true,
                            search: value,
                          );
                        }
                      },
                    );
                  },

                  decoration: InputDecoration(
                    hintText: "Search SKU or Product",
                    prefixIcon: const Icon(Icons.search),

                    /// ✅ CLEAR ONLY ON CLICK
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {

                        /// 🔥 CLEAR TEXTFIELD ONLY HERE
                        searchController.clear();

                        /// 🔥 RESET SEARCH STATE
                        controller.searchQuery = "";

                        String? status;
                        if (ctrl.selectedFilter == "Low Stock") {
                          status = "LOW_STOCK";
                        } else if (ctrl.selectedFilter == "Out of Stock") {
                          status = "OUT_OF_STOCK";
                        }

                        /// 🔥 LOAD NORMAL INVENTORY
                        controller.getInventory(
                          refresh: true,
                          stockStatus: status,
                        );
                      },
                    ),

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

              /// 🔥 FILTER BUTTONS
              ...filters.map((filter) {
                final isSelected = ctrl.selectedFilter == filter;

                return Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: GestureDetector(
                    onTap: () {

                      ctrl.selectedFilter = filter;

                      String? status;
                      if (filter == "Low Stock") {
                        status = "LOW_STOCK";
                      } else if (filter == "Out of Stock") {
                        status = "OUT_OF_STOCK";
                      }

                      /// 🔥 KEEP SEARCH STATE
                      if (ctrl.searchQuery.isEmpty) {
                        ctrl.getInventory(
                          refresh: true,
                          stockStatus: status,
                        );
                      } else {
                        ctrl.getInventoryBySearch(
                          refresh: true,
                          search: ctrl.searchQuery,
                        );
                      }
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
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
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