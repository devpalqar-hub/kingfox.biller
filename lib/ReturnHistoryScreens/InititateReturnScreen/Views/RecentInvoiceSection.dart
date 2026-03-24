// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:kinfox_biller/ReturnScreens/Service/ReturnFlowController.dart';
// import 'package:kinfox_biller/ReturnScreens/InititateReturnScreen/Views/InvoiceCard.dart';
// import 'package:kinfox_biller/ReturnHistoryScreen/ReturnHistoryScreen.dart';

// class RecentInvoicesSection extends StatelessWidget {
//   const RecentInvoicesSection({super.key});

//   @override
//   Widget build(BuildContext context) {


//     return GetBuilder<ReturnFlowController>(
//       builder: (controller) {

//         if (controller.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.recentInvoices.isEmpty) {
//           return const Center(child: Text("No recent invoices"));
//         }

//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 170.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               /// HEADER
//               Row(
//                 children: [
//                   const Icon(Icons.history, color: Colors.red),
//                   SizedBox(width: 8.w),

//                   Text(
//                     "Recent Invoices",
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),

//                   const Spacer(),

//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => ReturnHistoryScreen());
//                     },
//                     child: Text(
//                       "View all history",
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16.sp,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 20.h),

//               /// INVOICE LIST
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: controller.recentInvoices.length,
//                 itemBuilder: (context, index) {

//                   final invoice = controller.recentInvoices[index];

//                   return InvoiceCard(
//                     id: invoice.invoiceNumber ?? "N/A",
//                     date: invoice.createdAt ?? "",
//                     customer: invoice.customer?.name ?? "Walk-in ",
//                     amount: "₹${invoice.finalAmount ?? 0}",
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }