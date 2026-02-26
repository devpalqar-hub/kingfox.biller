import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Views/BillSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/CartCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/NoProductsCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/ScanSearch.dart';


class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF2ED),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 780.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                
                          ScanSearch(
                            controller: TextEditingController(),
                            onReturnTap: () {
                              print("Return clicked");
                            },
                          ),
                
                          SizedBox(height: 20.h),
                           NoProductsCard(),
                           SizedBox(height: 20.h),
                            CartCard(),
                        ],
                      ),
                    ),
                
                    SizedBox(width: 16.w),
                    const BillSummaryCard(),
                     
                  ],
                  
                ),
                 SizedBox(height: 40.h),
              ],
            ),
            
          ),
          
        ),
      ),
    );
  }
}