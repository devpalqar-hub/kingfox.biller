import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Views/ReturnsTable.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Views/SummaryCard.dart';

class ReturnHistoryScreen extends StatelessWidget {
  const ReturnHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Returns History",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff0F172A),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Track and manage all customer return transactions",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xff64748B),
                      ),
                    ),
                  ],
                ),

                 Container(
                  width: 320.w,
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xff94A3B8)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                                "Search Return ID or Original Invoice...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 28.h),

            
            Row(
              children: const [
                Expanded(
                  child: SummaryCard(
                    title: "TOTAL RETURNS TODAY",
                    value: "12",
                    subtitle: "₹14,250.00",
                    icon: Icons.inventory_2_outlined,
                    badge: "TODAY",
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: SummaryCard(
                    title: "TOP RETURN REASON",
                    value: "Size Issue",
                    icon: Icons.bar_chart,
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: SummaryCard(
                    title: "PENDING RESTOCKS",
                    value: "08 Items",
                    subtitle: "Requiring quality check",
                    icon: Icons.assignment,
                    badge: "ACTION NEEDED",
                    danger: true,
                  ),
                ),
              ],
            ),

            SizedBox(height: 26.h),

            const Expanded(child: ReturnTable()),
          ],
        ),
      ),
    );
  }
}