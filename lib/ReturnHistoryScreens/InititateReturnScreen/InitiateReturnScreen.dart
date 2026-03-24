// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:kinfox_biller/ReturnScreens/InititateReturnScreen/Views/InitiateReturnCard.dart';
// import 'package:kinfox_biller/ReturnScreens/InititateReturnScreen/Views/RecentInvoiceSection.dart';
// import 'package:kinfox_biller/ReturnScreens/ReturnScreen.dart';
// import 'package:kinfox_biller/ReturnScreens/Service/ReturnFlowController.dart';

// class InitiateReturnScreen extends StatelessWidget {
//   const InitiateReturnScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Controller for switching screens
//     final ReturnFlowController flowController = Get.put(ReturnFlowController());

//     return Scaffold(
//       backgroundColor: const Color(0xffF1F5F9),
//       body: SafeArea(
//         child: GetBuilder<ReturnFlowController>(
//           builder: (controller) {
//             // Show ReturnScreen if Continue clicked and invoice exists
//             if (controller.showReturnScreen) {
//               return const ReturnScreen();
//             }

//             // Initiate return UI
//             return SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(child: InitiateReturnCard()), // Card with invoice input & Continue
//                   SizedBox(height: 30.h),
//                   const RecentInvoicesSection(),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }