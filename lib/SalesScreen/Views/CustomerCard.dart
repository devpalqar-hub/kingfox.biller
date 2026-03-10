import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerVoucherCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController voucherController;
  final VoidCallback? onApplyCoupon;
  final VoidCallback? onEnterPhone;

  const CustomerVoucherCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.voucherController,
    this.onApplyCoupon, 
    this.onEnterPhone, 
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
           Row(
            children: [
              Icon(Icons.confirmation_number_outlined,
                  size: 16, color: Colors.grey),
              SizedBox(width: 6.w),
              Text(
                "Customer Name",
                style: TextStyle(
                    fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
           SizedBox(height: 8.h),
          _buildTextField(nameController, ".................."),

           SizedBox(height: 18.h),

          // Phone Number
           Row(
            children: [
              Icon(Icons.phone_outlined, size: 16.sp, color: Colors.grey),
              SizedBox(width: 6.w),
              Text(
                "Phone no",
                style: TextStyle(
                    fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
           SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                  child: _buildTextField(phoneController, "0000000000",
                      isPhone: true)),
              SizedBox(width: 10.w),
              InkWell(
                onTap: onEnterPhone,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C7A89),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: const Center(
                    child: Text(
                      "Enter",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),

           SizedBox(height: 18.h),

         
           Row(
            children: [
              Icon(Icons.confirmation_number_outlined,
                  size: 16, color: Colors.grey),
              SizedBox(width: 6.h),
              Text(
                "Select Voucher",
                style: TextStyle(
                    fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
           SizedBox(height: 8.w),
          Row(
            children: [
              Expanded(
                  child:
                      _buildTextField(voucherController, "Enter coupon code")),
            SizedBox(width: 10.w),
              InkWell(
                onTap: onApplyCoupon,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2BA153),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child:  Center(
                    child: Text(
                      "Apply",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize:12.sp,
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

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPhone = false}) {
    return Container(
    
      padding: EdgeInsets.symmetric(horizontal: 14.h,vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp),
          isDense: true,
        
         
        ),
      ),
    );
  }
}