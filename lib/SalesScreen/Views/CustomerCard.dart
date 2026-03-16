import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerVoucherCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  //final TextEditingController emailController;
  //final TextEditingController addressController;
  final TextEditingController voucherController;
  final VoidCallback? onApplyCoupon;
  final VoidCallback? onEnterPhone;
  final VoidCallback? onEnterEmail;
  final VoidCallback? onEnterAddress;

  const CustomerVoucherCard({
    super.key,
    required this.nameController,
    required this.phoneController,
   // required this.emailController,
   // required this.addressController,
    required this.voucherController,
    this.onApplyCoupon,
    this.onEnterPhone,
    this.onEnterEmail,
    this.onEnterAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFDCE4DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          _buildLabel("Customer Name", Icons.person_outline),
          SizedBox(height: 8.h),
          _buildTextField(nameController, "Enter customer name"),

          SizedBox(height: 10.h),

          // Phone
          _buildLabel("Phone no", Icons.phone_outlined),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(phoneController, "0000000000", isPhone: true),
              ),
              SizedBox(width: 10.w),
              _buildEnterButton(onEnterPhone),
            ],
          ),

          SizedBox(height: 10.h),

          // Email
         // _buildLabel("Email", Icons.email_outlined),
          //SizedBox(height: 8.h),
        //  Row(
         //   children: [
           //   Expanded(
           //     child: _buildTextField(emailController, "Enter email", isEmail: true),
            //  ),
             // SizedBox(width: 10.w),
             // _buildEnterButton(onEnterEmail),
          //  ],
          //),

          //SizedBox(height: 18.h),

          // Address
          //_buildLabel("Address", Icons.location_on_outlined),
         // SizedBox(height: 8.h),
         // Row(
           // children: [
             // Expanded(
               // child: _buildTextField(addressController, "Enter address"),
             // ),
             // SizedBox(width: 10.w),
             // _buildEnterButton(onEnterAddress),
           // ],
          //),

         // SizedBox(height: 18.h),

          // Voucher
          _buildLabel("Select Voucher", Icons.confirmation_number_outlined),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(voucherController, "Enter coupon code"),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: onApplyCoupon,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2BA153),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      "Apply",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPhone = false, bool isEmail = false}) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isPhone
            ? TextInputType.phone
            : isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp),
          isDense: true,
          isCollapsed: true,
        ),
      ),
    );
  }

  Widget _buildEnterButton(VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          color: const Color(0xFF6C7A89),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child:  Center(
          child: Text(
            "Enter",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}