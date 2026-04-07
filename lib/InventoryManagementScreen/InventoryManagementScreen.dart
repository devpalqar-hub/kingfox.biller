import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Service/InventoryController.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Views/InventoryCardRow.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Views/InventoryFilters.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Views/InventoryTable.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState
    extends State<InventoryManagementScreen> {

  final InventoryController controller = Get.put(InventoryController());
      

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// 🔥 FIRST LOAD
    controller.getInventory(refresh: true);
    controller.getInventoryAnalytics();

    /// 🔥 LOAD MORE ON SCROLL
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        controller.getInventory();
      }
    });
  }

  /// 🔥 PULL TO REFRESH
  Future<void> _onRefresh() async {
    await controller.getInventory(refresh: true);
    await controller.getInventoryAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      // floatingActionButton: Container(
      //   height: 60.h,
      //   width: 60.h,
      //   decoration: const BoxDecoration(
      //     color: Color(0xff0F172A),
      //     shape: BoxShape.circle,
      //   ),
      //   child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      // ),

      body: SafeArea(
        child: GetBuilder<InventoryController>(
          builder: (ctrl) {

            return RefreshIndicator(
              onRefresh: _onRefresh,

              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),

                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.w, vertical: 30.h),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ================= HEADER =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                        ],
                      ),

                      SizedBox(height: 30.h),

                      /// ================= CARDS =================
                      InventoryCardsRow(),

                      SizedBox(height: 25.h),

                      /// ================= FILTERS =================
                      InventoryFilters(),

                      SizedBox(height: 20.h),

                      /// ================= TABLE =================
                      InventoryTable(),

                      /// 🔥 LOAD MORE INDICATOR (BOTTOM)
                      if (ctrl.isLoadMore)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}