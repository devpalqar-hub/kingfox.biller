import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/CustomerController.dart';

class CustomerCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  CustomerCard({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 15.sp,
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Customer',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _nameField()),
                  SizedBox(width: 8.w),
                  SizedBox(width: 130.w, child: _phoneField()),
                ],
              ),
            ],
          ),
        ),
        GetBuilder<CustomerController>(
          builder: (c) {
            if (!c.isDropdownOpen || c.customerList.isEmpty) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: 64.h,
              left: 12.w,
              right: 12.w + 138.w,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 220.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.09),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    itemCount: c.customerList.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: const Color(0xFFF1F5F9)),
                    itemBuilder: (ctx, i) {
                      final customer = c.customerList[i];
                      final initial = customer.name.isNotEmpty
                          ? customer.name[0]
                          : '?';
                      return ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(
                          vertical: -2,
                          horizontal: 0,
                        ),
                        leading: CircleAvatar(
                          radius: 14.r,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: Text(
                            initial.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        title: Text(
                          customer.name,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        subtitle: Text(
                          customer.phone,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        onTap: () {
                          nameController.text = customer.name;
                          phoneController.text = customer.phone;
                          c.selectedCustomer = customer;
                          c.closeDropdown();
                          FocusScope.of(ctx).unfocus();
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _nameField() {
    return GetBuilder<CustomerController>(
      builder: (c) {
        return SizedBox(
          height: 38.h,
          child: TextField(
            controller: nameController,
            style: TextStyle(fontSize: 13.sp),
            onTap: c.toggleDropdown,
            onChanged: (v) {
              if (v.isEmpty) {
                c.closeDropdown();
              } else {
                c.searchCustomers(v);
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              hintText: 'Search customer…',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF94A3B8),
              ),
              suffixIcon: Icon(
                c.isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 18.sp,
                color: const Color(0xFF94A3B8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _phoneField() {
    return SizedBox(
      height: 38.h,
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 13.sp),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          hintText: 'Phone',
          hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1),
          ),
        ),
      ),
    );
  }
}
