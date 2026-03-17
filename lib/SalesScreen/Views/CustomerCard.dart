
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:kinfox_biller/SalesScreen/Model/LuckyDrawModel.dart';
import 'package:kinfox_biller/SalesScreen/Service/SalesController.dart';

class CustomerVoucherCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback? onEnterPhone;
  final TextEditingController voucherCountController = TextEditingController();

  CustomerVoucherCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    this.onEnterPhone,
  });

  final AddProductController controller = Get.put(AddProductController());
  int get voucherCount {
    return int.tryParse(voucherCountController.text) ?? 0;
  }

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

          // Voucher Dropdown
          _buildLabel("Select Voucher", Icons.confirmation_number_outlined),
          SizedBox(height: 8.h),
          GetBuilder<AddProductController>(
            builder: (controller) {
              if (controller.isLoading) {
                return _buildInfoBox("Loading vouchers...");
              }

              if (controller.campaigns.isEmpty) {
                return _buildInfoBox("No vouchers available");
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<LuckyDrawCampaign>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text("Select a voucher"),
                  value: controller.selectedCampaign,
                  items: controller.campaigns.map((campaign) {
                    return DropdownMenuItem<LuckyDrawCampaign>(
                      value: campaign,
                      child: Text(campaign.name),
                    );
                  }).toList(),
                  onChanged: (LuckyDrawCampaign? newValue) {
                    controller.selectCampaign(newValue);
                  },
                ),
              );
            },
          ),

          SizedBox(height: 10.h),

          // Voucher Count
          _buildLabel("Number of Vouchers", Icons.confirmation_num_outlined),
          SizedBox(height: 8.h),
          _buildTextField(voucherCountController, "Enter voucher count", isNumber: true),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      height: 40.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
      {bool isPhone = false, bool isNumber = false}) {
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
        keyboardType: isNumber
            ? TextInputType.number
            : (isPhone ? TextInputType.phone : TextInputType.text),
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
        child: Center(
          child: Text(
            "Enter",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}