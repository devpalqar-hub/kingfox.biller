import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/OverViewScreen/Service/HistoryController.dart';

class BillingHistoryTable extends StatelessWidget {
  final Historycontroller controller;

  const BillingHistoryTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Historycontroller>(
      builder: (ctrl) {
        if (ctrl.isInvoicesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.invoices.isEmpty) {
          return const Center(child: Text("No invoices found."));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _Header(),
              SizedBox(height: 20.h),
              ...ctrl.invoices.map((inv) => _InvoiceRow(inv)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _Header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(child: Text("INVOICE ID", overflow: TextOverflow.ellipsis)),
        Expanded(child: Text("DATE & TIME", overflow: TextOverflow.ellipsis)),
        Expanded(child: Text("ITEMS", overflow: TextOverflow.ellipsis)),
        Expanded(child: Text("AMOUNT", overflow: TextOverflow.ellipsis)),
        Expanded(child: Text("METHOD", overflow: TextOverflow.ellipsis)),
        Expanded(child: Text("STATUS", overflow: TextOverflow.ellipsis)),
        Expanded(child: Text("ACTION", overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _InvoiceRow(InvoiceModel inv) {
    final createdAt = inv.createdAt ?? '';
    String date = '';
    String time = '';

    if (createdAt.contains('T')) {
      final parts = createdAt.split('T');
      date = parts[0];
      time = parts.length > 1 ? parts[1].split(".")[0] : '';
    }

    final itemsCount = inv.items?.fold<int>(
            0, (prev, item) => prev + (item.quantity ?? 0)) ??
        0;
    final amount = inv.finalAmount ?? '0';
    final method = (inv.payments?.isNotEmpty ?? false)
        ? inv.payments![0].paymentMethod ?? '-'
        : '-';
    final status = inv.status ?? '-';
    final invoiceNumber = inv.invoiceNumber ?? '-';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(invoiceNumber, overflow: TextOverflow.ellipsis)),
          Expanded(child: Text("$date, $time", overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text("$itemsCount Item${itemsCount > 1 ? 's' : ''}",
                  overflow: TextOverflow.ellipsis)),
          Expanded(
            child: Text("₹$amount",
                style: const TextStyle(color: Colors.green),
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(child: Text(method, overflow: TextOverflow.ellipsis)),
          Expanded(
            child: Text(status,
                style: TextStyle(
                    color: status == "RETURNED" ? Colors.red : Colors.green),
                overflow: TextOverflow.ellipsis),
          ),
          const Expanded(child: Icon(Icons.remove_red_eye_outlined)),
        ],
      ),
    );
  }
}