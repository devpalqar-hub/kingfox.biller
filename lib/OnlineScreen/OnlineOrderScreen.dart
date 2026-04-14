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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Online Orders",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff1E293B),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Manage and track all customer orders in real time.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),

          
                      Row(
                        children: [
                          SizedBox(
                            width: 180.w,
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
                                    value: "PENDING",
                                    child: Text("PENDING"),
                                  ),
                                  DropdownMenuItem(
                                    value: "SHIPPED",
                                    child: Text("SHIPPED"),
                                  ),
                                ],
                                onChanged: (value) {
                                  controller.changeStatus(value);
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 12.w),

                          GestureDetector(
                            onTap: () {
                              controller.changeStatus(null);
                            },
                            child: _clearBtn(),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  const OrderCardsRow(),

                  SizedBox(height: 25.h),

                  const OnlineOrderTable(),
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
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
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
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
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