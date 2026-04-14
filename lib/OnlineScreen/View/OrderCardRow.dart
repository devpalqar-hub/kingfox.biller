import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OnlineScreen/Service/Online_order_controller.dart';

class OrderCardsRow extends StatelessWidget {
  const OrderCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PickupOrdersController>(
      builder: (controller) {
        
        if (controller.isAnalyticsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final analytics = controller.analytics;

        
        return Row(
          children: [
            Expanded(
              child: _card(
                "TOTAL ORDERS",
                "${analytics?.totalPickupOrders ?? 0}",
                valueColor: const Color(0xff3B82F6),
              ),
            ),

            SizedBox(width: 20.w),

            Expanded(
              child: _card(
                "PENDING ORDERS",
                "${analytics?.pendingPickupOrders ?? 0}",
                valueColor: const Color(0xffF59E0B),
              ),
            ),

            SizedBox(width: 20.w),

            Expanded(
              child: _card(
                "TOTAL REVENUE",
                "₹${analytics?.totalRevenue ?? 0}",
                valueColor: const Color(0xff22C55E),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _card(
    String title,
    String value, {
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xff64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}