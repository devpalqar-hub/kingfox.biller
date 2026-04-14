import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OnlineScreen/Model/pickup_order_model.dart';
import 'package:kinfox_biller/OnlineScreen/OrderDetailScreen.dart';
import 'package:kinfox_biller/OnlineScreen/Service/Online_order_controller.dart';


class OnlineOrderTable extends StatelessWidget {
  const OnlineOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PickupOrdersController>(
      init: PickupOrdersController(),
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              /// HEADER
              _header(),

              SizedBox(height: 15.h),

              /// LOADING
              if (controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else

             
                ...controller.orders.map((order) {
                  return _dataRow(order); 
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Expanded(flex: 2, child: Text("ORDER ID")),
        Expanded(flex: 2, child: Text("DATE")),
        Expanded(flex: 2, child: Text("TIME")),
        Expanded(flex: 2, child: Text("AMOUNT")),
        Expanded(flex: 2, child: Text("METHOD")),
        Expanded(flex: 2, child: Text("STATUS")),
        Expanded(flex: 1, child: Text("ITEMS")),
        Expanded(flex: 1, child: Text("ACTION")),
      ],
    );
  }


  Widget _dataRow(PickupOrder order) {
    Color statusColor;

    switch (order.status) {
      case "CONFIRMED":
      statusColor = Colors.orange;
      case "DELIVERED":
        statusColor = Colors.green;
        break;
      case "CANCELLED":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
  
          Expanded(flex: 2, child: Text(order.orderNumber)),

         
          Expanded(flex: 2, child: Text(_formatDate(order.createdAt))),

    
          Expanded(flex: 2, child: Text(_formatTime(order.createdAt))),

         
          Expanded(
            flex: 2,
            child: Text(
              "₹${order.finalAmount}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff22C55E),
              ),
            ),
          ),

        
          Expanded(flex: 2, child: Text(order.paymentMethod)),

        
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),

         
          Expanded(
            flex: 1,
            child: Text(order.items.length.toString()),
          ),


          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Get.to(() => OrderDetailScreen(order: order));
              },
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.visibility,
                  size: 18.sp,
                  color: const Color(0xff3B82F6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.day}-${date.month}-${date.year}";
  }

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final suffix = date.hour >= 12 ? "PM" : "AM";

    return "${hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')} $suffix";
  }
}