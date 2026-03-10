import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/LoginScreen/Service/AuthController.dart';
import 'package:kinfox_biller/main.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authController) {
          return Row(
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
                    child: SizedBox(
                      width: 420.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logo.png",
                                width: 44.w,
                                height: 44.h,
                                fit: BoxFit.contain,
                              ),
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
                              color: Color(0xff64748B),
                            ),
                          ),

                          SizedBox(height: 30.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "STAFF ID",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Color(0xff64748B),
                              ),
                            ),
                          ),

                          SizedBox(height: 6.h),

                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter ID",
                              prefixIcon: Icon(Icons.person_outline),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "4-DIGIT PIN",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Color(0xff64748B),
                              ),
                            ),
                          ),

                          SizedBox(height: 6.h),

                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Enter PIN",
                              prefixIcon: Icon(Icons.lock_outline),
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

                         
                          GestureDetector(
                            onTap: () async {

                              await authController.login(
                                emailController.text,
                                passwordController.text,
                              );

                              if (accessToken != null) {
                                Get.off(() => Dashboardscreen());
                              }

                            },
                            child: Container(
                              width: double.infinity,
                              height: 55.h,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: authController.isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
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
                              color: Color(0xff64748B),
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
          );
        },
      ),
    );
  }
}