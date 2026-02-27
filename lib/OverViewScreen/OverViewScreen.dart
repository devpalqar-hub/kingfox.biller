import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/OverViewScreen/Views/BillingTable.dart';
import 'package:kinfox_biller/OverViewScreen/Views/BottomSummaryCrad.dart';
import 'package:kinfox_biller/OverViewScreen/Views/AnalyticsCard.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  "Executive Overview",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1E293B),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Real-time performance metrics for FashionPOS retail outlets.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
                SizedBox(height: 25.h),

                /// Metric Cards
                Row(
                  children: [
                    Expanded(
                      child: AnalyticsCard(
                        title: "TOTAL REVENUE",
                        value: "₹4,82,900",
                        subtitle: "+12.5%",
                        color: const Color(0xff22C55E),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AnalyticsCard(
                        title: "TOTAL ORDERS",
                        value: "1,245",
                        subtitle: "+8.2%",
                        color: const Color(0xff3B82F6),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AnalyticsCard(
                        title: "AVG. ORDER VALUE",
                        value: "₹3,878",
                        subtitle: "0.0%",
                        color: const Color(0xff8B5CF6),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AnalyticsCard(
                        title: "RETURN RATE",
                        value: "2.4%",
                        subtitle: "+2.1%",
                        color: const Color(0xffEF4444),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50.h),

              
                Text(
                  "Billing History",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1E293B),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Review and manage all retail transactions, refunds, and returns.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
                SizedBox(height: 20.h),

                
                BillingTable(),

                SizedBox(height: 20.h),

                
                Row(
                  children: [
                    Expanded(
                      child: BottomSummaryCard(
                        title: "TOTAL SALES",
                        value: "₹1,24,560",
                        color: const Color(0xff22C55E),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: BottomSummaryCard(
                        title: "TRANSACTIONS",
                        value: "42 Active",
                        color: const Color(0xff1E293B),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: BottomSummaryCard(
                        title: "REFUNDS",
                        value: "₹3,400",
                        color: const Color(0xffEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}