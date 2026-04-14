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

    controller.getInventory(refresh: true);
    controller.getInventoryAnalytics();

    /// 🔥 PAGINATION FIX
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {

        if (!controller.isLoadMore && controller.hasMore) {
          controller.getInventory();
        }
      }
    });
  }

  /// 🔥 REFRESH FIX
  Future<void> _onRefresh() async {
    await controller.getInventory(refresh: true);
    await controller.getInventoryAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SafeArea(
        child: GetBuilder<InventoryController>(
          builder: (ctrl) {
            return RefreshIndicator(
              onRefresh: _onRefresh,

              child: ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: 40.w, vertical: 30.h),

                children: [

                  /// HEADER
                  Text(
                    "Inventory Management",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  InventoryCardsRow(),
                  SizedBox(height: 20.h),

                  InventoryFilters(),
                  SizedBox(height: 20.h),

                  /// 🔥 DATA STATE FIX
                  if (ctrl.isLoading && ctrl.inventories.isEmpty)
                    const Center(child: CircularProgressIndicator())

                  else if (ctrl.inventories.isNotEmpty)
                    InventoryTable()

                  else
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 60.sp, color: Colors.grey),
                            SizedBox(height: 10.h),
                            Text(
                              "No Inventory Found",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// LOAD MORE
                  if (ctrl.isLoadMore)
                    Padding(
                      padding: EdgeInsets.all(20.h),
                      child: const Center(
                          child: CircularProgressIndicator()),
                    ),

                  SizedBox(height: 40.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}