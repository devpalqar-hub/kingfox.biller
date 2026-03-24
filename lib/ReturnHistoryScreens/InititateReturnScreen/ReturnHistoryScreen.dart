// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:kinfox_biller/ReturnHistoryScreen/Service/ReturnController.dart';
// import 'package:kinfox_biller/ReturnHistoryScreen/Views/ReturnsTable.dart';
// import 'package:kinfox_biller/ReturnHistoryScreen/Views/SummaryCard.dart';

// class ReturnHistoryScreen extends StatelessWidget {
//   const ReturnHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF1F5F9),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             /// ================= HEADER =================
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Returns History",
//                   style: TextStyle(
//                     fontSize: 28.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),

//                 /// SEARCH
//                 Container(
//                   width: 320.w,
//                   height: 44.h,
//                   padding: EdgeInsets.symmetric(horizontal: 14.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30.r),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.search),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: TextField(
//                           decoration: const InputDecoration(
//                             hintText: "Search...",
//                             border: InputBorder.none,
//                           ),
//                           onChanged: (value) {
//                             // Optional: add search logic here
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 26.h),

//             /// ================= SUMMARY =================
//             Row(
//               children: const [
//                 Expanded(
//                   child: SummaryCard(
//                     title: "TOTAL RETURNS",
//                     value: "12",
//                     subtitle: "₹14,250",
//                     icon: Icons.inventory_2_outlined,
//                   ),
//                 ),
//                 SizedBox(width: 18),
//                 Expanded(
//                   child: SummaryCard(
//                     title: "TOP REASON",
//                     value: "Size Issue",
//                     icon: Icons.bar_chart,
//                   ),
//                 ),
//                 SizedBox(width: 18),
//                 Expanded(
//                   child: SummaryCard(
//                     title: "PENDING",
//                     value: "08",
//                     subtitle: "Items",
//                     icon: Icons.assignment,
//                     danger: true,
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 26.h),

//             /// ================= TABLE =================
//             Expanded(
//               child: GetBuilder<ReturnsController>(
               
              
//                 builder: (controller) {
//                   if (controller.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (controller.recentInvoices.isEmpty) {
//                     return const Center(child: Text("No returns found"));
//                   }

//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: ReturnTable(
//                       invoices: controller.recentInvoices, // ✅ IMPORTANT FIX
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }