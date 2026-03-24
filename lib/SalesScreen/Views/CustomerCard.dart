import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

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
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              const Icon(Icons.person_2_outlined),
              SizedBox(width: 10.w),
              Text(
                "Customer Selection",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// INPUT ROW
          Row(
            children: [
              /// NAME FIELD
              Expanded(
                child: _buildTextField(
                  controller: nameController,
                  hint: "Enter customer name",
                  
                ),
              ),

              SizedBox(width: 10.w),

              /// PHONE FIELD
              Expanded(
                child: _buildTextField(
                  controller: phoneController,
                  hint: "Enter phone number",
                  isPhone: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  bool isPhone = false,
}) {
  return SizedBox(
    height: 45.h,
    child: TextField(
      controller: controller,

      keyboardType:
          isPhone ? TextInputType.number : TextInputType.text,

      inputFormatters: isPhone
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [],

      /// ✅ Vertically center text & hint
      textAlignVertical: TextAlignVertical.center,

      style: TextStyle(fontSize: 14.sp),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp),

        /// ✅ Perfect vertical centering
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
  vertical: (45.h - 14.sp) / 2, // dynamic centering
          horizontal: 14.w,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    ),
  );
}}