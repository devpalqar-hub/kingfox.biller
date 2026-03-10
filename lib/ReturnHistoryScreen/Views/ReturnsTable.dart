import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Model/ReturnModel.dart';


class ReturnTable extends StatelessWidget {
  final List<ReturnModel> returns;

  const ReturnTable({super.key, required this.returns});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
            decoration: const BoxDecoration(
              color: Color(0xffF8FAFC),
            ),
            child: Row(
              children: const [
                Expanded(child: Text("RETURN ID")),
                Expanded(child: Text("ORIGINAL INVOICE #")),
                Expanded(child: Text("CUSTOMER NAME")),
                Expanded(child: Text("RETURNED ITEMS")),
                Expanded(child: Text("REFUND AMOUNT")),
                Expanded(child: Text("STATUS")),
                Expanded(child: Text("DATE & TIME")),
                Expanded(child: Text("ACTIONS")),
              ],
            ),
          ),
          ...returns.map((r) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(r.id.toString())),
                  Expanded(child: Text(r.items.isNotEmpty ? r.items[0].variant.sku : "-")),
                  Expanded(child: Text(r.customer.name)),
                  Expanded(child: Text("${r.items.length} Item(s)")),
                  Expanded(child: Text("₹${r.totalRefund}")),
                  Expanded(child: Text("Returned")), 
                  Expanded(child: Text(r.createdAt.split("T")[0])), 
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.visibility),
                        ),
                        IconButton(
                          onPressed: () {
                          },
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