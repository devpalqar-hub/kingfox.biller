import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingTable extends StatelessWidget {
  const BillingTable({super.key});

  @override
  Widget build(BuildContext context) {
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
          _data("INV-10245", "Today, 10:45 AM", "3 Items", "₹3,677",
              "CASH", "COMPLETED"),
          _data("INV-10212", "Oct 26, 08:20 PM", "2 Items", "₹2,199",
              "ONLINE", "COMPLETED"),
          _data("INV-10210", "Oct 26, 06:15 PM", "1 Item", "₹899",
              "CASH", "RETURNED"),
          _data("INV-10208", "Oct 26, 04:30 PM", "5 Items", "₹12,450",
              "ONLINE", "COMPLETED"),
        ],
      ),
    );
  }

  Widget _Header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("INVOICE ID"),
        Text("DATE & TIME"),
        Text("ITEMS"),
        Text("AMOUNT"),
        Text("METHOD"),
        Text("STATUS"),
        Text("ACTION"),
      ],
    );
  }

  Widget _data(String id, String date, String items, String amount,
      String method, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id),
          Text(date),
          Text(items),
          Text(amount, style: const TextStyle(color: Colors.green)),
          Text(method),
          Text(status,
              style: TextStyle(
                  color: status == "RETURNED"
                      ? Colors.red
                      : Colors.green)),
          const Icon(Icons.remove_red_eye_outlined)
        ],
      ),
    );
  }
}