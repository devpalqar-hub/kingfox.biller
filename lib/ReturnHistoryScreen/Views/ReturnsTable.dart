import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kinfox_biller/ReturnScreens/Model/InvoiceModel.dart';



class ReturnTable extends StatelessWidget {
  final List<RecentInvoiceModel> invoices;

  const ReturnTable({
    super.key,
    required this.invoices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [

          ...invoices.map((invoice) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    child: Row(
      children: [

        /// RETURN ID
        Expanded(
          child: Text("RET-${invoice.id ?? "-"}"),
        ),

        /// ORIGINAL INVOICE
        Expanded(
          child: Text(invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : "-"),
        ),

        /// CUSTOMER NAME
        Expanded(
          child: Text(invoice.customer.name.isNotEmpty ? invoice.customer.name : "-"),
        ),

        /// ITEMS COUNT
        Expanded(
          child: Text("${invoice.items.isNotEmpty ? invoice.items.length : 0} Items"),
        ),

        /// REFUND AMOUNT
        Expanded(
          child: Text("₹${invoice.finalAmount.isNotEmpty ? invoice.finalAmount : "0"}"),
        ),

        /// STATUS
        const Expanded(child: Text("Returned")),

        /// DATE
        Expanded(
          child: Text(
            invoice.createdAt != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(invoice.createdAt)
                : "-",
          ),
        ),

        /// ACTIONS
        Expanded(
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}).toList(),
        ],
      ),
    );
  }
}