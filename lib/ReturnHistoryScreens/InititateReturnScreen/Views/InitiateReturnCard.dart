// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:kinfox_biller/ReturnHistoryScreen/Service/ReturnController.dart';
// import 'package:kinfox_biller/ReturnScreens/Service/ReturnFlowController.dart';

// class InitiateReturnCard extends StatelessWidget {
//   InitiateReturnCard({super.key});

//   final TextEditingController invoiceController = TextEditingController();

//   // Flow controller to switch screens
//   final ReturnFlowController flowController = Get.put(ReturnFlowController());

//   @override
//   Widget build(BuildContext context) {
//     // ReturnsController for API calls
//     final ReturnsController controller = Get.put(ReturnsController());

//     return GetBuilder<ReturnsController>(
//       builder: (_) {
//         return Container(
//           width: 896.w,
//           height: 490.h,
//           padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.05),
//                 blurRadius: 10.r,
//                 offset: const Offset(0, 4),
//               )
//             ],
//           ),
//           child: Column(
//             children: [
//               SizedBox(height: 25.h),
//               Container(
//             height: 60.h,
//             width: 60.w,
//             decoration: BoxDecoration(
//               color: Colors.red.withOpacity(.1),
//               shape: BoxShape.circle,
//             ),
//             child:  Icon(Icons.qr_code_scanner,
//                 color: Colors.red, size: 30.sp),
//           ),
//            SizedBox(height: 20.h),
//           Text(
//             "Initiate Return",
//             style: TextStyle(
//               fontSize: 30.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Text(
//             "Scan the customer's receipt or enter the invoice ID \n manually to retrieve the transaction details.",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.grey,
//               height: 1.5.h,
//               fontSize: 16.sp,
//             ),
//           ),
//           SizedBox(height: 25.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 112.w),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         height: 80.h,
//                         decoration: BoxDecoration(
//                           color: const Color(0xfff1f2f4),
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.search, color: Colors.grey),
//                             SizedBox(width: 10.w),
//                             Expanded(
//                               child: TextField(
//                                 controller: invoiceController,
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       "Scan receipt or enter Invoice ID to begin...",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 18.sp,
//                                   ),
//                                   border: InputBorder.none,
//                                 ),
//                                 keyboardType: TextInputType.number,
//                               ),
//                             ),
//                             SizedBox(width: 20.w),
//                             controller.isLoading
//                                 ? const CircularProgressIndicator()
//                                 : InkWell(
//                                     borderRadius: BorderRadius.circular(12.r),
//                                     onTap: () async {
//   final input = invoiceController.text.trim();

//   if (input.isEmpty) {
//     Get.snackbar("Invalid", "Enter a valid invoice ID");
//     return;
//   }

//   // Call API with the raw string (supports INV-12345 or any combination)
//   await controller.getInvoice(input);

//   if (controller.invoice != null) {
//     flowController.invoice = controller.invoice;
//     flowController.startReturn();
//   } else {
//     Get.snackbar("Error", "Invoice not found");
//   }
// },
//                                     child: Container(
//                                       height: 50.h,
//                                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                                       decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         borderRadius: BorderRadius.circular(12.r),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "Continue",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16.sp,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                   ],
//                 ),
//               ),
//                SizedBox(height: 40.h),
//            Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.check_circle, size: 14.sp, color: Color(0xff94A3B8)),
//               SizedBox(width: 6.w),
//               Text("Valid Receipt", style: TextStyle(color: Color(0xff94A3B8))),
//               SizedBox(width: 20.w),
//               Icon(Icons.check_circle, size: 14.sp, color: Color(0xff94A3B8)  ),
//               SizedBox(width: 6.w),
//               Text("30-Day Window", style: TextStyle(color: Color(0xff94A3B8))),
//               SizedBox(width: 20.w),
//               Icon(Icons.check_circle, size: 14.sp, color: Color(0xff94A3B8)),
//               SizedBox(width: 6.w),
//               Text("Tag Present", style: TextStyle(color: Color(0xff94A3B8))),
//             ],
//           )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }