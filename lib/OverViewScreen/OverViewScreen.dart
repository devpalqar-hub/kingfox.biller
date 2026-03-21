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
  final Historycontroller historyController =
      Get.put(Historycontroller());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();

    /// 🔥 SCROLL LISTENER (LOAD MORE)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        historyController.getInvoices(); // load next page
      }
    });
  }

  void loadData() async {
    await historyController.geAnalytics();
    await historyController.getInvoices(refresh: true);
  }

  /// 🔥 PULL TO REFRESH
  Future<void> _onRefresh() async {
    await historyController.geAnalytics();
    await historyController.getInvoices(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: GetBuilder<Historycontroller>(
          builder: (ctrl) {
            final analytics = ctrl.analytics;

            return RefreshIndicator(
              onRefresh: _onRefresh,

              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ================= HEADER =================
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

                      /// ================= ANALYTICS =================
                      if (analytics == null)
                        _analyticsLoading()
                      else
                        Row(
                          children: [
                            Expanded(
                              child: AnalyticsCard(
                                title: "TOTAL REVENUE",
                                value:
                                    "₹${analytics.summary.netRevenue.toStringAsFixed(2)}",
                                color: const Color(0xff22C55E),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: AnalyticsCard(
                                title: "TOTAL ORDERS",
                                value:
                                    "${analytics.summary.totalOrders}",
                                color: const Color(0xff3B82F6),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: AnalyticsCard(
                                title: "AVG. ORDER VALUE",
                                value:
                                    "₹${analytics.summary.averageOrderValue.toStringAsFixed(2)}",
                                color: const Color(0xff8B5CF6),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: AnalyticsCard(
                                title: "RETURN RATE",
                                value:
                                    "${analytics.summary.returnRate.toStringAsFixed(2)}%",
                                color: const Color(0xffEF4444),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 50.h),

                      /// ================= BILLING HISTORY =================
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

                      /// ================= TABLE =================
                      BillingHistoryTable(controller: ctrl),

                      /// 🔥 LOAD MORE INDICATOR (BOTTOM ONLY)
                      if (ctrl.isLoadMore)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),

                      SizedBox(height: 30.h),

                      /// ================= BOTTOM SUMMARY =================
                      if (analytics != null)
                        Row(
                          children: [
                            Expanded(
                              child: BottomSummaryCard(
                                title: "TOTAL SALES",
                                value:
                                    "₹${analytics.summary.totalSales.toStringAsFixed(2)}",
                                color: const Color(0xff22C55E),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: BottomSummaryCard(
                                title: "TRANSACTIONS",
                                value:
                                    "${analytics.summary.transactionsCount} Active",
                                color: const Color(0xff1E293B),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: BottomSummaryCard(
                                title: "REFUNDS",
                                value:
                                    "₹${analytics.summary.totalRefunds.toStringAsFixed(2)}",
                                color: const Color(0xffEF4444),
                              ),
                            ),
                          ],
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


  Widget _analyticsLoading() {
    return Row(
      children: List.generate(
        4,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 20.w),
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}