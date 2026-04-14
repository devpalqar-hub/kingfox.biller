import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:kinfox_biller/OnlineScreen/Model/pickup_order_model.dart';
import 'package:kinfox_biller/OnlineScreen/Service/Online_order_controller.dart';

class OrderDetailScreen extends StatelessWidget {
  final PickupOrder order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.h,
        title: Row(
          children: [
            _title("Order System", 16, FontWeight.w700),
            SizedBox(width: 24.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title("Order Details", 14, FontWeight.w600),
                _subtitle(order.orderNumber),
              ],
            ),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [

        Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [


    Expanded(
      flex: 3,
      child: Column(
        children: [

          
          Row(
            children: [
              Expanded(child: _fixedCard(_statusCard())),
              SizedBox(width: 12.w),
              Expanded(child: _fixedCard(_dateCard())),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(child: _fixedCard(_customerCard())),
              SizedBox(width: 12.w),
              Expanded(child: _fixedCard(_fulfillmentCard())),
            ],
          ),
        ],
      ),
    ),

    SizedBox(width: 16.w),

  
    Expanded(
      flex: 2, // ✅ bigger than before, but not too big
      child: SizedBox(
        height: 252.h,
        child: _amountCard(),
      ),
    ),
  ],
),
            SizedBox(height: 16.h),

         
            Expanded(
              child: SingleChildScrollView(
                child: _itemsSection(),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _bottomBar(),
    );
  }

 
  Widget _fixedCard(Widget child) {
    return SizedBox(
      height: 120.h,
      width: 100.w,

      child: _card(child),
    );
  }


  Widget _statusCard() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        Text(
          "Status Summary",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1E293B),
          ),
        ),

        SizedBox(height: 12.h),


        Row(
         
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(" STATUS"),
                SizedBox(height: 5.h),
                _chip(order.status, _statusColor(order.status)),
              ],
            ),
           SizedBox(width: 100.w,),
       
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("PAYMENT STATUS"),
                SizedBox(height: 6.h),
                _chip(order.paymentStatus, _statusColor(order.paymentStatus)),
              ],
            ),
          ],
        ),
      ],
    );

  Widget _dateCard() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

           Text(
          "ORDER PLACEMENT",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1E293B),
          ),
        ),

          Padding(
            padding:  EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Date:"),
              
            SizedBox(height: 4.h),
            _title(_formatDate(order.createdAt), 14, FontWeight.bold),
            _subtitle("     ${_formatTime(order.createdAt)}"),
            ],
            ),
          ),
        ],
      );


  Widget _amountCard() => _card(
        Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: _label("PAYMENT"),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Total Amount",
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  SizedBox(height: 6.h),
                  Text(
                    "₹${order.finalAmount}",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _subtitle("Paid via ${order.paymentMethod}"),
                ],
              ),
            ),
          ],
        ),
      );


  Widget _customerCard() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Customer", 14, FontWeight.bold),
          SizedBox(height: 5.h),
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                child: Text(
                  order.customer.name.isNotEmpty
                      ? order.customer.name[0].toUpperCase()
                      : "C",
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(order.customer.name, 13, FontWeight.w600),
                    _subtitle(order.customer.phone),
                    _subtitle(order.customer.email),
                  ],
                ),
              )
            ],
          ),
        ],
      );


  Widget _fulfillmentCard() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _title("Fulfillment", 14, FontWeight.bold),
              SizedBox(width: 6.w),
              _chip(order.fulfillmentType, Colors.blue),
            ],
          ),
          SizedBox(height: 6.h),
          _subtitle("Pickup / Delivery details"),
        ],
      );

 
 Widget _itemsSection() => _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Items Information", 14, FontWeight.bold),
          SizedBox(height: 12.h),

          ...order.items.map((item) {
            return Column(
              children: [
                _itemRow(item),
                _divider(),
              ],
            );
          }).toList(),
        ],
      ),
    );

Widget _itemRow(OrderItem item) {
  final product = item.variant.product;
  final variant = item.variant;

  final imageUrl = product.images.isNotEmpty
      ? product.images[0].toString()
      : null;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 65.w,
          height: 65.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.r),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? Icon(Icons.image_not_supported, size: 22.sp)
              : null,
        ),

        SizedBox(width: 25.w),

       
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

             
              _title(product.name, 13, FontWeight.w600),

              SizedBox(height: 5.h),

            
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: [
                  if (variant.size.isNotEmpty)
                    _chipSmall("Size: ${variant.size}"),

                  if (variant.color.isNotEmpty)
                    _chipSmall("Color: ${variant.color}"),

                  if (variant.weight.isNotEmpty)
                    _chipSmall("${variant.weight} g"),
                ],
              ),

              SizedBox(height: 6.h),

      
              _subtitle("Qty: ${item.quantity}"),
            ],
          ),
        ),

        SizedBox(width: 10.w),

      
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

          
            _title("${item.quantity}", 13, FontWeight.bold),
            _subtitle("Qty"),

            SizedBox(height: 10.h),

       
            _title("₹${item.price}", 13, FontWeight.bold),
            _subtitle("Price"),
          ],
        ),
      ],
    ),
  );
}
 

 Widget _bottomBar() => GetBuilder<PickupOrdersController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              SizedBox(width: 8.w),

            
              Expanded(
                child: _subtitle(
                  "Finalize order status after customer verification",
                ),
              ),

              
              GestureDetector(
                onTap: controller.isLoading
                    ? null
                    : () async {
                        await controller.updateOrderStatus(
                          order.id,
                          "DELIVERED",
                        );

                       
                        Get.back();
                      },
                child: controller.isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _actionBtn("Mark as Complete", true),
              ),
            ],
          ),
        );
      },
    );
  Widget _actionBtn(String text, bool filled) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: filled ? const Color(0xff3B82F6) : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: filled ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      );


  Widget _card(Widget child) => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: child,
      );

  Widget _title(String text, double size, FontWeight w) =>
      Text(text, style: TextStyle(fontSize: size.sp, fontWeight: w));

  Widget _subtitle(String text) =>
      Text(text, style: TextStyle(fontSize: 10.sp, color: Colors.grey));

  Widget _label(String text) =>
      Text(text, style: TextStyle(fontSize: 10.sp, color: Colors.grey));

  Widget _chip(String text, Color color) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(text,
            style: TextStyle(color: color, fontSize: 11.sp)),
      );

  Widget _divider() => Divider(height: 20.h);

  Color _statusColor(String status) {
    switch (status) {
      case "SHIPPED":
      case "COMPLETED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.day}-${date.month}-${date.year}";
  }

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final suffix = date.hour >= 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $suffix";
  }

  Widget _chipSmall(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 10.sp),
    ),
  );
}
}