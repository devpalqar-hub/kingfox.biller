import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const CustomerCard({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(vertical:15.w,horizontal: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_2_outlined),
              SizedBox(width: 10.w),
              Text(
                "Customer Selection",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          _buildTextField(nameController, "Enter customer name",),
          SizedBox(height: 10.h),
          _buildTextField(phoneController, "Enter phone number"),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      alignment: Alignment.center,
      child: TextField(
     
        controller: controller,
        decoration: InputDecoration(
         
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp),
          isCollapsed: true,
          isDense: true,
        ),
      ),
    );
  }
}