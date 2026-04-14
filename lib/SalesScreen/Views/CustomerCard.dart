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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.closeDropdown();
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          /// INPUT BOX
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_2_outlined),
                    SizedBox(width: 10.w),
                    Text("Customer Selection",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp)),
                  ],
                ),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Expanded(child: _buildCustomerField()),
                    SizedBox(width: 10.w),
                    Expanded(child: _buildPhoneField()),
                  ],
                ),
              ],
            ),
          ),

          /// DROPDOWN LIST
          GetBuilder<CustomerController>(
            builder: (c) {
              if (!c.isDropdownOpen || c.customerList.isEmpty) {
                return const SizedBox();
              }

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
                        nameController.text = customer.name ?? '';
                        phoneController.text = customer.phone ?? '';

                        c.selectedCustomer = customer;
                        c.closeDropdown();

                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 FIELD WITH TOGGLE ARROW
  Widget _buildCustomerField() {
    return GetBuilder<CustomerController>(
      builder: (c) {
        return SizedBox(
          height: 45.h,
          child: TextField(
            controller: nameController,

            onTap: () {
              c.toggleDropdown();
            },

            onChanged: (value) {
              if (value.isEmpty) {
                c.closeDropdown();
                return;
              }

              c.searchCustomers(value);
            },

            decoration: InputDecoration(
              hintText: "Search customer",

              /// 🔥 TOGGLE ARROW
              suffixIcon: IconButton(
                icon: Icon(
                  c.isDropdownOpen
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
                onPressed: () {
                  c.toggleDropdown();
                },
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField() {
    return SizedBox(
      height: 45.h,
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          hintText: "Phone",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}