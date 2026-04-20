import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OnlineScreen/Service/Online_order_controller.dart';
import 'package:kinfox_biller/OnlineScreen/View/OnlineOrderTable.dart';
import 'package:kinfox_biller/OnlineScreen/View/OrderCardRow.dart';

class OnlineOrderScreen extends StatelessWidget {
  const OnlineOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PickupOrdersController());

    return GetBuilder<PickupOrdersController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xffF5F7FA),

          body: SafeArea(
            child: SingleChildScrollView(
              physics:  AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

               
                    Wrap(
                      spacing: 20.w,
                      runSpacing: 15.h,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [

                        /// TITLE SECTION
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Online Orders",
                              style: TextStyle(
                                fontSize: 24.sp, 
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1E293B),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: 300.w,
                              child: Text(
                                "Manage and track all customer orders in real time.",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xff64748B),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 650.w,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                           
                            SizedBox(
                              width: 160.w,
                              child: _filterBox(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  value: controller.selectedStatus,
                                  isExpanded: true,
                                  hint: Text(
                                    "Status",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  underline: const SizedBox(),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "CONFIRMED",
                                      child: Text("Confirmed"),
                                    ),
                                    DropdownMenuItem(
                                      value: "DELIVERED",
                                      child: Text("Delivered"),
                                    ),
                                     DropdownMenuItem(
                                      value: "CANCELLED",
                                      child: Text("Cancelled"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    controller.changeStatus(value);
                                  },
                                ),
                              ),
                            ),

                            SizedBox(width: 10.w),

                           
                            GestureDetector(
                             onTap: () async {
  await controller.changeStatus(null);
},
                              child: _clearBtn(),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    /// CARDS
                    const OrderCardsRow(),

                    SizedBox(height: 20.h),

controller.orders.isEmpty
    ? Center(
        child: Padding(
          padding: EdgeInsets.only(top: 60.h),
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 70,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 10.h),
              Text(
                "No Orders Found",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "You don’t have any online orders yet.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      )
    : const OnlineOrderTable(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _filterBox({required Widget child}) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _clearBtn() {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          "Clear",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}