import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/DashBoard/Service/DashBoardController.dart';


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          color: Colors.white,
          child: Row(
            children: [
              Image.asset(
                  "assets/logo.png", 
                  height: 30.h,
                  fit: BoxFit.contain,
                ),
              SizedBox(width: 20.w),
              Text(
                "KingFox",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(width: 40.w),

              _tab(controller, "Sales", 0),
              _tab(controller, "Overview & History", 1),
              _tab(controller, "Inventory", 2),
              _tab(controller, "Returns", 3),

                  const Spacer(),


Row(
  children: [
   
    Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xffEEF2EE),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
             Icon(
              Icons.person,
              size: 18.sp,
              color: Colors.black,
            ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Abhiram",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
            ],
          ),
        ],
      ),
    ),

    SizedBox(width: 12.w), 
            CircleAvatar(
  radius: 20.r,
  backgroundColor: Colors.grey.shade300,
  child: Icon(
    Icons.person,
    size: 22.sp,
    color: Colors.white,
  ),
),
  ],
),
              
            ],
          ),
        );
      },
    );
  }

  Widget _tab(
      DashboardController controller,
      String title,
      int index,
      ) {
    final selected = controller.currentTab == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: selected
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
            color:
                selected ? Colors.black : Color(0XFF64748B),
          ),
        ),
      ),
    );
  }
}