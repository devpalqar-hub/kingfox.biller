import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OverViewScreen/Service/HistoryController.dart';
import 'package:kinfox_biller/OverViewScreen/Views/BillingTable.dart';
import 'package:kinfox_biller/OverViewScreen/Views/AnalyticsCard.dart';
import 'package:kinfox_biller/OverViewScreen/Views/InvoiceSearch.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final Historycontroller historyController = Get.put(Historycontroller());
  final ScrollController _scrollController = ScrollController();

  // String? selectedStatus;
  // DateTime? fromDate;
  // DateTime? toDate;

  @override
  void initState() {
    super.initState();
    loadData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        historyController.getInvoices(
          status: historyController.selectedStatus,
          from: historyController.fromDate != null
              ? formatDate(historyController.fromDate!)
              : null,
          to: historyController.toDate != null
              ? formatDate(historyController.toDate!)
              : null,
        );
      }
    });
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> loadData() async {
    await historyController.geAnalytics(
      fromDate: historyController.fromDate != null
          ? formatDate(historyController.fromDate!)
          : null,
      toDate: historyController.toDate != null
          ? formatDate(historyController.toDate!)
          : null,
    );
    await historyController.getInvoices(
      refresh: true,
      status: historyController.selectedStatus,
      from: historyController.fromDate != null
          ? formatDate(historyController.fromDate!)
          : null,
      to: historyController.toDate != null
          ? formatDate(historyController.toDate!)
          : null,
    );
  }

  Future<void> _onRefresh() async {
    await loadData();
  }

  Future<DateTime?> _pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: "Select Date",
      cancelText: "Cancel",
      confirmText: "Apply",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff3B82F6),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xff3B82F6)),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 30.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER + FILTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                            ],
                          ),

                          Row(
                            children: [
                              _filterBox(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  isExpanded: false,
                                  value: historyController.selectedStatus,
                                  hint: Text(
                                    "Status",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  underline: const SizedBox(),
                                  items:
                                      [
                                        //   "DRAFT",
                                        "COMPLETED",
                                        "CANCELLED",
                                        "RETURNED",
                                        "PARTIALLY_RETURNED",
                                      ].map((status) {
                                        return DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(
                                      () => historyController.selectedStatus =
                                          value,
                                    );
                                    historyController.update();
                                    loadData();
                                  },
                                ),
                              ),

                              SizedBox(width: 12.w),

                              _dateButton(
                                label: historyController.fromDate == null
                                    ? "From"
                                    : formatDate(historyController.fromDate!),
                                onTap: () async {
                                  final picked = await _pickDate();
                                  if (picked != null) {
                                    setState(
                                      () => historyController.fromDate = picked,
                                    );
                                    historyController.update();
                                    loadData();
                                  }
                                },
                              ),

                              SizedBox(width: 10.w),

                              _dateButton(
                                label: historyController.toDate == null
                                    ? "To"
                                    : formatDate(historyController.toDate!),
                                onTap: () async {
                                  final picked = await _pickDate();
                                  if (picked != null) {
                                    setState(
                                      () => historyController.toDate = picked,
                                    );
                                    historyController.update();
                                    loadData();
                                  }
                                },
                              ),

                              SizedBox(width: 10.w),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    historyController.selectedStatus = null;
                                    historyController.fromDate = null;
                                    historyController.toDate = null;
                                  });
                                  loadData();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    "Clear",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 25.h),

                      if (analytics == null)
                        _analyticsLoading()
                      else
                        Row(
                          children: [
                            Expanded(
                              child: AnalyticsCard(
                                title: "TOTAL REVENUE",
                                value:
                                    "₹${analytics.summary.totalRevenue.toStringAsFixed(2)}",
                                color: const Color(0xff22C55E),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: AnalyticsCard(
                                title: "TOTAL ORDERS",
                                value: "${analytics.summary.totalOrders}",
                                color: const Color(0xff3B82F6),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: AnalyticsCard(
                                title: "TOTAL SALES",
                                value:
                                    "₹${analytics.summary.totalSales.toStringAsFixed(2)}",
                                color: const Color(0xff22C55E),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: AnalyticsCard(
                                title: "REFUNDS",
                                value:
                                    "₹${analytics.summary.refundAmount.toStringAsFixed(2)}",
                                color: const Color(0xffEF4444),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 20.h),

                      Row(
                        children: [
                          Expanded(
                            child: AnalyticsCard(
                              title: "BY HAND",
                              value:
                                  "₹${(ctrl.analytics?.summary.paymentBreakdown.cash ?? 0).toDouble().toStringAsFixed(2)}",

                              color: Colors.brown,
                            ),
                          ),

                          SizedBox(width: 20.w),
                          Expanded(
                            child: AnalyticsCard(
                              title: "BY CARD",
                              value:
                                  "₹${(ctrl.analytics?.summary.paymentBreakdown.card ?? 0).toDouble().toStringAsFixed(2)}",

                              color: Colors.brown,
                            ),
                          ),

                          SizedBox(width: 20.w),

                          Expanded(
                            child: AnalyticsCard(
                              title: "BY UPI",
                              value:
                                  "₹${(ctrl.analytics?.summary.paymentBreakdown.upi ?? 0).toDouble().toStringAsFixed(2)}",
                              color: const Color.fromARGB(255, 85, 184, 231),
                            ),
                          ),

                          SizedBox(width: 20.w),

                          Expanded(
                            child: AnalyticsCard(
                              title: "TOTAL GST",
                              value:
                                  "₹${(ctrl.analytics?.summary.totalGstCollected ?? 0).toDouble().toStringAsFixed(2)}",
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      InvoiceSearch(),
                      SizedBox(height: 20.h),
                      BillingHistoryTable(controller: ctrl),

                      if (ctrl.isLoadMore)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
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

  Widget _filterBox({required Widget child}) {
    return Container(
      height: 40.h,
      constraints: BoxConstraints(minWidth: 100.w),
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

  Widget _dateButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: _filterBox(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.sp),
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
