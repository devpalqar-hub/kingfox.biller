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

  /// 🔥 COMMON TEXTFIELD BUILDER
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPhone = false,
  }) {
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

        /// ✅ Keyboard type
        keyboardType:
            isPhone ? TextInputType.number : TextInputType.text,

        /// ✅ Only numbers allowed (strong restriction)
        inputFormatters: isPhone
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : [],

        /// ✅ Keep text centered (no jump issue)
        textAlignVertical: TextAlignVertical.center,

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp),

          /// ✅ Stable padding (fix UI issues)
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}