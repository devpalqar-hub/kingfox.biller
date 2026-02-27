import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Views/ReturnData.dart';


class ReturnTable extends StatelessWidget {
  const ReturnTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [

          /// HEADER
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

          const ReturnData(),
      
        ],
      ),
    );
  }
}