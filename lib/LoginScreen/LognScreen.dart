import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/ReturnScreens/ReturnScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.asset(
                  "assets/moon.png", 
                  width: 500.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          
          Expanded(
            child: Container(
              color: const Color(0xffF1F5F9),
              child: Center(
                child: Container(
                  width: 420.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                          
                            decoration: BoxDecoration(
                             
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Image.asset(
                  "assets/logo.png", 
                  width: 44.w,
                  height: 44.h,
                  fit: BoxFit.contain
                          ),),
                          SizedBox(width: 10.w),
                          Text(
                            "KINGFOX",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        "Biller Login",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        "Enter your credentials to access the terminal",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xff64748B),
                        ),
                      ),

                      SizedBox(height: 30.h),

                     
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "STAFF ID",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xff64748B),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter ID",
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 18.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      
                      Text(
                        "4-DIGIT PIN",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xff64748B),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          4,
                          (index) => Container(
                            height: 55.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffE2E8F0),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                   
                      GestureDetector(
                        onTap: (){Get.to(() =>  Dashboardscreen());  },
                        child: Container(
                          width: double.infinity,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Text(
                              "Login to Billing",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Text(
                        "Forgot PIN?",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xff64748B),
                        ),
                      ),

                      SizedBox(height: 25.h),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}