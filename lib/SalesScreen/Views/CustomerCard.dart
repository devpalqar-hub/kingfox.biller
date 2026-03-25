import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/CustomerController.dart';
import 'package:kinfox_biller/SalesScreen/Model/CustomerModel.dart';

class CustomerCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  CustomerCard({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                  /// 🔽 NAME FIELD (DROPDOWN)
                  Expanded(child: _buildCustomerDropdown()),

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
        ),

        /// 🔽 DROPDOWN LIST UI
        GetBuilder<CustomerController>(
          builder: (c) {
            if (c.customerList.isEmpty) return const SizedBox();

            return Container(
              margin: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              constraints: BoxConstraints(maxHeight: 200.h),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: c.customerList.length,
                itemBuilder: (context, index) {
                  final customer = c.customerList[index];

                  return ListTile(
                    title: Text(customer.name ?? ''),
                    subtitle: Text(customer.phone ?? ''),
                    onTap: () {
                      /// ✅ Fill values
                      nameController.text = customer.name ?? '';
                      phoneController.text = customer.phone ?? '';

                      /// ✅ Close dropdown
                      c.customerList.clear();
                      c.update();
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🔥 MAIN DROPDOWN FIELD
  Widget _buildCustomerDropdown() {
    return SizedBox(
      height: 45.h,
      child: TextField(
        controller: nameController,

        /// 🔽 LOAD ALL CUSTOMERS ON CLICK
        onTap: () {
          controller.searchCustomers();
        },

        /// 🔍 SEARCH API
        onChanged: (value) {
          controller.searchCustomers(value);
        },

        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14.sp),

        decoration: InputDecoration(
          hintText: "Search / Enter customer",
          prefixIcon: const Icon(Icons.arrow_drop_down),

          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: (45.h - 14.sp) / 2,
            horizontal: 14.w,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  /// NORMAL TEXT FIELD
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
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: (45.h - 14.sp) / 2,
            horizontal: 14.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}