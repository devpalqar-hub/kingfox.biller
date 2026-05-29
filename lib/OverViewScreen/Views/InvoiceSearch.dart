import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OverViewScreen/Service/HistoryController.dart';

class InvoiceSearch extends StatefulWidget {
  const InvoiceSearch({super.key});

  @override
  State<InvoiceSearch> createState() => _InvoiceSearchState();
}

class _InvoiceSearchState extends State<InvoiceSearch> {
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Historycontroller>(
      builder: (ctrl) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: searchController,

                  onChanged: (value) {
                    if (debounce?.isActive ?? false) {
                      debounce!.cancel();
                    }

                    debounce = Timer(const Duration(milliseconds: 500), () {
                      ctrl.searchQuery = value;

                      ctrl.getInvoices(
                        refresh: true,
                        search: value,
                        orderType: ctrl.orderTypeFilter,
                      );
                    });
                  },

                  decoration: InputDecoration(
                    hintText: "Search Invoice / Customer",
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      child: Icon(Icons.search),
                    ),

                    suffixIcon: IconButton(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        child: Icon(Icons.close),
                      ),
                      onPressed: () {
                        searchController.clear();
                        ctrl.searchQuery = "";

                        ctrl.getInvoices(
                          refresh: true,
                          search: "",
                          orderType: ctrl.orderTypeFilter,
                        );
                      },
                    ),

                    filled: true,
                    fillColor: const Color(0xffF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 150.w,
                child: DropdownButtonFormField<String>(
                  value: ctrl.orderTypeFilter,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffF1F5F9),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "", child: Text("All")),
                    DropdownMenuItem(value: "OFFLINE", child: Text("Offline")),
                    DropdownMenuItem(value: "ONLINE", child: Text("Online")),
                  ],
                  onChanged: (value) {
                    ctrl.orderTypeFilter = value ?? "";
                    ctrl.geAnalytics();
                    ctrl.fetchFilterAnalytics();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
