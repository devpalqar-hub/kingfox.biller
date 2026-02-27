import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/OfferandSummarySection.dart';
import 'package:kinfox_biller/SalesScreen/Views/PaymentSectionCard.dart';


class BillSummaryCard extends StatelessWidget {
  const BillSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 395.w,
    
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(20.r),
         border: Border.all(color: const Color(0xFFDCE4DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
       
        children: [

          /// Customer Card
           Padding(
             padding:  EdgeInsets.only(right: 16.w),
             child: CustomerVoucherCard(),
           ),

          

          
           OfferAndSummarySection(),

         
         PaymentSectionCard(),
         
        ],
      ),
    );
  }
}