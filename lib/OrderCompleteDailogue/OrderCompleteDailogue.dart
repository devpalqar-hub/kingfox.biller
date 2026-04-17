import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/OrderDetailCard.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/PaymentInformationCard.dart';
import 'package:kinfox_biller/OrderCompleteDailogue/Views/PaymentSummaryCard.dart';

class OrderCompleteDialog extends StatelessWidget {
  final dynamic cart;
  final String invoiceNumber;
  final double subtotal;
  final double tax;
  final double discount;
  final double refundAmount;
  final double total;
  final String cashierName;
  final String counterName;
  final String customerName;
  final double tenderedAmount;

  const OrderCompleteDialog({
    super.key,
    required this.cart,
    required this.invoiceNumber,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.refundAmount,
    required this.total,
    this.cashierName = 'Cashier',
    this.counterName = 'POS-01',
    this.customerName = 'Walk-in',
    this.tenderedAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
      child: Container(
        width: 900.w,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 48,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildMetaBar(),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// LEFT — scrollable line items + payment attribution
                  Expanded(
                    flex: 13,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel(
                            Icons.receipt_long_outlined,
                            'Line Items',
                          ),
                          OrderDetailsCard(cart: cart),
                          SizedBox(height: 12.h),
                          _sectionLabel(
                            Icons.credit_card_outlined,
                            'Payment Attribution',
                          ),
                          PaymentInformationCard(
                            paymentDateTime: DateTime.now(),
                            paidAmount: total,
                            tenderedAmount: tenderedAmount,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// DIVIDER
                  VerticalDivider(
                    width: 0.5,
                    thickness: 0.5,
                    color: const Color(0xFFE2E8F0),
                  ),

                  /// RIGHT — anchored bill summary
                  SizedBox(
                    width: 210.w,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(14.w),
                      child: PaymentSummaryCard(
                        subtotal: subtotal,
                        tax: tax,
                        discount: discount,
                        refundAmount: refundAmount,
                        total: total,
                        tenderedAmount: tenderedAmount,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 46.h,
      color: const Color(0xFF0F172A),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          /// Icon badge
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.12),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: const Color(0xFF22C55E).withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Icon(
              Icons.storefront_outlined,
              color: const Color(0xFF22C55E),
              size: 14.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Payment Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(width: 10.w),

          /// Sale Complete chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.10),
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                color: const Color(0xFF22C55E).withOpacity(0.25),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  'Sale Complete',
                  style: TextStyle(
                    color: const Color(0xFF4ADE80),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Text(
            'Invoice ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 11.sp,
            ),
          ),
          Text(
            invoiceNumber,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
          ),
          SizedBox(width: 14.w),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: Colors.white.withOpacity(0.3),
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBar() {
    return Container(
      height: 34.h,
      color: const Color(0xFF1E293B),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _metaItem('Cashier', cashierName),
          _metaSep(),
          _metaItem('Counter', counterName),
          _metaSep(),
          _metaItem('Date', _formatMetaDate(DateTime.now())),
          _metaSep(),
          _metaItem('Customer', customerName),
          _metaSep(),
          _metaItem('Items', '${cart.items.length} units'),
        ],
      ),
    );
  }

  Widget _metaItem(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.30),
            fontSize: 10.sp,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _metaSep() {
    return Container(
      width: 1,
      height: 14.h,
      color: Colors.white.withOpacity(0.08),
      margin: EdgeInsets.symmetric(horizontal: 14.w),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(color: const Color(0xFFE2E8F0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${cart.items.length} items  ·  GST included  ·  $invoiceNumber',
            style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 10.sp),
          ),
          const Spacer(),
          _footerBtn(
            icon: Icons.file_download_outlined,
            label: 'Export',
            onTap: () {},
          ),
          SizedBox(width: 8.w),
          _footerBtn(icon: Icons.print_outlined, label: 'Print', onTap: () {}),
          SizedBox(width: 8.w),
          _footerBtnPrimary(
            icon: Icons.check_rounded,
            label: 'New Sale',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _footerBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.sp, color: const Color(0xFF64748B)),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF334155),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerBtnPrimary({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.sp, color: const Color(0xFF4ADE80)),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 12.sp, color: const Color(0xFF94A3B8)),
          SizedBox(width: 5.w),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMetaDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$min $ampm';
  }
}
