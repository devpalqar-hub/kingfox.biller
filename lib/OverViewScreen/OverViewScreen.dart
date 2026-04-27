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

  String? selectedStatus;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    loadData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        historyController.getInvoices(
          status: selectedStatus,
          from: fromDate != null ? formatDate(fromDate!) : null,
          to: toDate != null ? formatDate(toDate!) : null,
        );
      }
    });
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> loadData() async {
    await historyController.geAnalytics(
      fromDate: fromDate != null ? formatDate(fromDate!) : null,
      toDate: toDate != null ? formatDate(toDate!) : null,
    );
    await historyController.getInvoices(
      refresh: true,
      status: selectedStatus,
      from: fromDate != null ? formatDate(fromDate!) : null,
      to: toDate != null ? formatDate(toDate!) : null,
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
                                  value: selectedStatus,
                                  hint: Text(
                                    "Status",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  underline: const SizedBox(),
                                  items:
                                      [
                                        "DRAFT",
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
                                    setState(() => selectedStatus = value);
                                    loadData();
                                  },
                                ),
                              ),

                              SizedBox(width: 12.w),

                              _dateButton(
                                label: fromDate == null
                                    ? "From"
                                    : formatDate(fromDate!),
                                onTap: () async {
                                  final picked = await _pickDate();
                                  if (picked != null) {
                                    setState(() => fromDate = picked);
                                    loadData();
                                  }
                                },
                              ),

                              SizedBox(width: 10.w),

                              _dateButton(
                                label: toDate == null
                                    ? "To"
                                    : formatDate(toDate!),
                                onTap: () async {
                                  final picked = await _pickDate();
                                  if (picked != null) {
                                    setState(() => toDate = picked);
                                    loadData();
                                  }
                                },
                              ),

                              SizedBox(width: 10.w),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStatus = null;
                                    fromDate = null;
                                    toDate = null;
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
                                    "₹${analytics.summary.netRevenue.toStringAsFixed(2)}",
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
                                    "₹${analytics.summary.totalRefunds.toStringAsFixed(2)}",
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
                                  "₹${(ctrl.analytics?.summary.totalCollectedByHand ?? 0).toDouble().toStringAsFixed(2)}",

                              color: Colors.brown,
                            ),
                          ),

                          SizedBox(width: 20.w),

                          Expanded(
                            child: AnalyticsCard(
                              title: "BY BANK / ONLINE",
                              value:
                                  "₹${ctrl.analytics?.summary.totalCollectedByOnline.toStringAsFixed(2) ?? '0.00'}",
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
