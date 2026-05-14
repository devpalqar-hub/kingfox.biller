import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/CustomerController.dart';

class CustomerCard extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const CustomerCard({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final FocusNode _nameFocusNode = FocusNode();
  bool _isSelecting = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _commitSelection(CustomerController c, dynamic customer) {
    if (_isSelecting) return;
    _isSelecting = true;

    widget.nameController.text = customer.name;
    widget.nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: customer.name.length),
    );
    widget.phoneController.text = customer.phone;

    c.selectedCustomer = customer;
    c.closeDropdown();
    c.update();

    _nameFocusNode.unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isSelecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      builder: (c) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card ─────────────────────────────
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(child: _nameField(c)),
                      SizedBox(width: 8.w),
                      SizedBox(width: 250, child: _phoneField()),
                    ],
                  ),
                ],
              ),
            ),

            // ── Dropdown (INLINE like ScanSearch) ─────────────
            if (c.isDropdownOpen && c.customerList.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                constraints: BoxConstraints(maxHeight: 220.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: _DropdownList(
                  customers: List.unmodifiable(c.customerList),
                  onSelect: (customer) => _commitSelection(c, customer),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _nameField(CustomerController c) {
    return SizedBox(
      height: 40.h,
      child: TextField(
        controller: widget.nameController,
        focusNode: _nameFocusNode,
        style: TextStyle(fontSize: 13.sp),
        onTap: () {
          if (!_isSelecting) c.toggleDropdown();
        },
        onChanged: (v) {
          if (_isSelecting) return;
          v.isEmpty ? c.closeDropdown() : c.searchCustomers(v);
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          hintText: 'Search customer…',
          hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
          suffixIcon: Icon(
            c.isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 18.sp,
            color: const Color(0xFF94A3B8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFF2563EB)),
          ),
        ),
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      height: 38.h,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: widget.phoneController,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 14),

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12),
        ],
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,

          // prefix: Text(
          //   "+91 ",
          //   style: TextStyle(fontSize: 14, color: Colors.black),
          // ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
            //  vertical: 10.h,
          ),
          hintText: 'Enter Phone Number',
          hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
        ),
      ),
    );
  }
}

// ── Dropdown List ─────────────────────────────
class _DropdownList extends StatelessWidget {
  final List customers;
  final void Function(dynamic customer) onSelect;

  const _DropdownList({required this.customers, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      itemCount: customers.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
      itemBuilder: (_, i) {
        final customer = customers[i];
        final initial = customer.name.isNotEmpty ? customer.name[0] : '?';

        return InkWell(
          onTap: () => onSelect(customer),
          child: ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -2, horizontal: 0),
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
            title: Text(customer.name, style: TextStyle(fontSize: 13.sp)),
            subtitle: Text(
              customer.phone,
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF64748B)),
            ),
          ),
        );
      },
    );
  }
}
