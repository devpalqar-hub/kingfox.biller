import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OverViewScreen/Service/HistoryController.dart';
import 'package:kinfox_biller/OverViewScreen/Views/BillingTable.dart';
import 'package:kinfox_biller/OverViewScreen/Views/BottomSummaryCrad.dart';
import 'package:kinfox_biller/OverViewScreen/Views/AnalyticsCard.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final Historycontroller historyController = Historycontroller();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await historyController.geAnalytics(); 
    await historyController.getInvoices();
  }

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
                GetBuilder<Historycontroller>(
                  init: historyController,
                  builder: (ctrl) {
                    final analytics = ctrl.analytics;
                    return Row(
                      children: [
                        Expanded(
                          child: AnalyticsCard(
                            title: "TOTAL REVENUE",
                            value:
                                "₹${analytics?.summary.totalRevenue.toStringAsFixed(2) ?? '0'}",
                            subtitle: "+12.5%",
                            color: const Color(0xff22C55E),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: AnalyticsCard(
                            title: "TOTAL ORDERS",
                            value: "${analytics?.summary.totalInvoices ?? 0}",
                            subtitle: "+8.2%",
                            color: const Color(0xff3B82F6),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: AnalyticsCard(
                            title: "AVG. ORDER VALUE",
                            value: analytics != null &&
                                    analytics.summary.totalInvoices > 0
                                ? "₹${(analytics.summary.totalRevenue / analytics.summary.totalInvoices).toStringAsFixed(2)}"
                                : "₹0",
                            subtitle: "0.0%",
                            color: const Color(0xff8B5CF6),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: AnalyticsCard(
                            title: "RETURN RATE",
                            value: analytics != null &&
                                    analytics.summary.totalItemsSold > 0
                                ? "${((analytics.summary.totalReturns / analytics.summary.totalItemsSold) * 100).toStringAsFixed(1)}%"
                                : "0%",
                            subtitle: "+2.1%",
                            color: const Color(0xffEF4444),
                          ),
                        ),
                      ],
                    );
                  },
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
                GetBuilder<Historycontroller>(
                  init: historyController,
                  builder: (ctrl) => BillingHistoryTable(controller: ctrl),
                ),

                SizedBox(height: 20.h),
                GetBuilder<Historycontroller>(
                  init: historyController,
                  builder: (ctrl) {
                    final analytics = ctrl.analytics;
                    return Row(
                      children: [
                        Expanded(
                          child: BottomSummaryCard(
                            title: "TOTAL SALES",
                            value:
                                "₹${analytics?.summary.netRevenue.toStringAsFixed(2) ?? '0'}",
                            color: const Color(0xff22C55E),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: BottomSummaryCard(
                            title: "TRANSACTIONS",
                            value: "${analytics?.summary.totalInvoices ?? 0} Active",
                            color: const Color(0xff1E293B),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: BottomSummaryCard(
                            title: "REFUNDS",
                            value:
                                "₹${analytics?.summary.totalRefunds.toStringAsFixed(2) ?? '0'}",
                            color: const Color(0xffEF4444),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}