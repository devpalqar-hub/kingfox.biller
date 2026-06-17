import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

class ManualDiscountCard extends StatelessWidget {
  const ManualDiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.local_offer_outlined,
      label: 'Discount',
      child: GetBuilder<AddProductController>(
        builder: (ctrl) => Column(
          children: [
            /// Staff Dropdown
            Row(
              children: [
                Expanded(
                  child: _Dropdown(
                    hint: 'Assigned staff',
                    value: ctrl.selectedStaff?.id,
                    items: ctrl.staffList
                        .map(
                          (s) => DropdownMenuItem<int>(
                            value: s.id,
                            child: Text(
                              s.name,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;

                      ctrl.selectStaff(
                        ctrl.staffList.firstWhere(
                          (s) => s.id == v,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: () {
                    ctrl.selectedStaff = null;
                    ctrl.update();
                  },
                  child: Icon(
                    Icons.close,
                    size: 18.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

           Row(
  children: [
    Expanded(
      child: GestureDetector(
        onTap: () {
          ctrl.isPercentageDiscount = false;
          ctrl.update();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: !ctrl.isPercentageDiscount
                ? const Color(0xff1D4ED8)
                : const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              "Amount",
              style: TextStyle(
                color: !ctrl.isPercentageDiscount
                    ? Colors.white
                    : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ),

    SizedBox(width: 8.w),

    Expanded(
      child: GestureDetector(
        onTap: () {
          ctrl.isPercentageDiscount = true;
          ctrl.update();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: ctrl.isPercentageDiscount
                ? const Color(0xff1D4ED8)
                : const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              "Percentage",
              style: TextStyle(
                color: ctrl.isPercentageDiscount
                    ? Colors.white
                    : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ),
  ],
),

            SizedBox(height: 12.h),

            /// Discount Input
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: TextField(
                      controller: ctrl.discountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                     inputFormatters: [
  FilteringTextInputFormatter.allow(
    RegExp(r'^\d*\.?\d{0,2}'),
  ),
  LengthLimitingTextInputFormatter(
    ctrl.isPercentageDiscount ? 6 : 10,
  ),
],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        hintText: ctrl.isPercentageDiscount
                            ? "Discount Percentage"
                            : "Discount Amount",
                            isCollapsed: true,
                            isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                        suffixIcon: ctrl.isPercentageDiscount
                            ? Center(
                                widthFactor: 1,
                                child: Text(
                                  "%",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                /// Apply Button
                _ApplyButton(
  onTap: () async {
    if (ctrl.cart == null || ctrl.cart!.items.isEmpty) {
      return;
    }

    final input = ctrl.discountController.text.trim();

    if (input.isEmpty) return;

    final discount = double.tryParse(input);

    if (discount == null || discount <= 0) {
      return;
    }

    if (ctrl.isPercentageDiscount) {
      await ctrl.getCart(
        manualDiscountPercent: discount,
      );
    } else {
      await ctrl.getCart(
        manualDiscountAmount: discount,
      );
    }
  },
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SharedWidgets.dart
//  Put this in lib/SalesScreen/Views/SharedWidgets.dart
//  Import it wherever _SectionCard, _Dropdown, _InputField, _ApplyButton needed

/// Titled card wrapper used by ManualDiscountCard and VoucherSelectionCard
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, size: 14.sp, color: const Color(0xFF64748B)),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}

/// Slim styled dropdown
class _Dropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          dropdownColor: Colors.white,
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
          ),
          icon: Icon(
            Icons.expand_more,
            size: 16.sp,
            color: const Color(0xFF94A3B8),
          ),
          items: items,
          onChanged: onChanged,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF1E293B)),
        ),
      ),
    );
  }
}

/// Slim text input field
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 12.sp),
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
          prefixIcon: prefixIcon,
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

/// Green apply button
class _ApplyButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ApplyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Apply',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
