import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';


/// Full-screen modal that renders a pixel-accurate thermal receipt preview.
/// Triggered automatically when [PrinterController.mockMode] is true.
class ReceiptPreviewDialog extends StatelessWidget {
  final CartModel bill;
  final String tableName;
  final String restaurantName;
  final String? restaurantAddress;
  final String? restaurantPhone;

  const ReceiptPreviewDialog({
    super.key,
    required this.bill,
    required this.tableName,
    this.restaurantName = "GastroPOS",
    this.restaurantAddress,
    this.restaurantPhone,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
    final time =
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 340.w,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Dialog header bar ────────────────────────────────
              _DialogTopBar(),

              // ── Scrollable receipt ────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _ReceiptPaper(
                    bill: bill,
                    tableName: tableName,
                    restaurantName: restaurantName,
                    restaurantAddress: restaurantAddress,
                    restaurantPhone: restaurantPhone,
                    date: date,
                    time: time,
                  ),
                ),
              ),

              // ── Bottom action bar ─────────────────────────────────
              _BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dialog top bar ────────────────────────────────────────────────────────────
class _DialogTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF2994A).withOpacity(0.12),
              borderRadius: BorderRadius.circular(7.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.receipt_long_outlined,
              size: 15.sp,
              color: const Color(0xFFF2994A),
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Receipt Preview",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2994A).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        "MOCK MODE",
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFF2994A),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "No printer required",
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.close,
                size: 13.sp,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── The actual receipt paper ──────────────────────────────────────────────────
class _ReceiptPaper extends StatelessWidget {
  final CartModel bill;
  final String tableName;
  final String restaurantName;
  final String? restaurantAddress;
  final String? restaurantPhone;
  final String date;
  final String time;

  const _ReceiptPaper({
    required this.bill,
    required this.tableName,
    required this.restaurantName,
    this.restaurantAddress,
    this.restaurantPhone,
    required this.date,
    required this.time,
  });

  // Thermal paper off-white
  static const Color _paper = Color(0xFFFDFCF8);
  static const Color _ink = Color(0xFF1A1A1A);
  static const Color _inkFade = Color(0xFF6B6B6B);
  static const String _font = 'Courier';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9), // tray background
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
      child: Container(
        decoration: BoxDecoration(
          color: _paper,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Perforation top ────────────────────────────────────
            _Perforation(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 14.h),

                  // ── Restaurant name ────────────────────────────
                  Text(
                    restaurantName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: _font,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: _ink,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (restaurantAddress != null &&
                      restaurantAddress!.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      restaurantAddress!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 9.sp,
                        color: _inkFade,
                      ),
                    ),
                  ],
                  if (restaurantPhone != null &&
                      restaurantPhone!.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      "Tel: $restaurantPhone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 9.sp,
                        color: _inkFade,
                      ),
                    ),
                  ],
                  SizedBox(height: 10.h),
                  _DashedDivider(),
                  SizedBox(height: 8.h),

                  // ── Bill meta rows ─────────────────────────────
                  _MetaRow("Table", tableName, bold: true),
                 //if (bill.session?.sessionNumber != null)
                   // _MetaRow(
                    // // "Bill No",
                      //"#${bill.session!.sessionNumber}",
                     // bold: true,
                  //  ),
                  //if (bill.session?.customerName?.isNotEmpty == true)
                  //  _MetaRow("Customer", bill.session!.customerName!),
                  //if (bill.session?.customerPhone?.isNotEmpty == true)
                   // _MetaRow("Phone", bill.session!.customerPhone!),
                  _MetaRow("Date", "$date  $time"),
                  SizedBox(height: 8.h),
                  _DashedDivider(),
                  SizedBox(height: 8.h),

                  // ── Items header ───────────────────────────────
                  _ItemHeader(),
                  _ThinLine(),
                  SizedBox(height: 4.h),

                  // ── Items ──────────────────────────────────────
                  if (bill.items != null)
                    ...bill.items!.map((item) {
                      final name = item.productName ?? item.productName ?? "Item";
                      return _ItemRow(
                        name: name,
                        qty: item.quantity ?? 1,
                       price: (item.price ?? 0).toStringAsFixed(2),
                       // unitPrice: item.lineTotal,
                      );
                    }),

                  SizedBox(height: 4.h),
                  _ThinLine(),
                  SizedBox(height: 10.h),

                  // ── Subtotals ──────────────────────────────────
                  _TotalRow("Subtotal", "\$${bill.subtotal ?? '0.00'}"),
                  SizedBox(height: 4.h),
                  _TotalRow(
                    "Tax (${bill.gstPercent ?? 0}%)",
                    "\$${bill.gstAmount ?? '0.00'}",
                  ),

                  if (bill.couponDiscountAmount != null &&
                      bill.couponDiscountAmount != "0" &&
                      bill.couponDiscountAmount!= "0.00") ...[
                    SizedBox(height: 4.h),
                    _TotalRow(
                      "Discount",
                      "-\$${bill.couponDiscountAmount}",
                      valueColor: const Color(0xFF10B981),
                    ),
                  ],
                  if (bill.coupon != null) ...[
                    SizedBox(height: 4.h),
                    _TotalRow(
                      "Coupon (${bill.coupon!.code ?? ''})",
                      "-\$${bill.coupon!.discountValue ?? '0.00'}",
                      valueColor: const Color(0xFF10B981),
                    ),
                  ],
                  // if (bill.loyalty?.totalPoints != null &&
                  //     bill.loyalty!.totalPoints != "0") ...[
                  //   SizedBox(height: 4.h),
                  //   _TotalRow(
                  //     "Loyalty pts",
                  //     "${bill.loyalty!.totalPoints} pts",
                  //     valueColor: const Color(0xFFF2994A),
                  //   ),
                  // ],

                  SizedBox(height: 8.h),
                  _DoubleLine(),
                  SizedBox(height: 8.h),

                  // ── Grand Total ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL",
                        style: TextStyle(
                          fontFamily: _font,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: _ink,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        "\$${bill.grandFinalTotal ?? '0.00'}",
                        style: TextStyle(
                          fontFamily: _font,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  _DoubleLine(),
                  SizedBox(height: 16.h),

                  // ── Footer ─────────────────────────────────────
                  Text(
                    "Thank you for dining with us!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: _font,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Please come again  🙏",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: _font,
                      fontSize: 9.sp,
                      color: _inkFade,
                    ),
                  ),
                  SizedBox(height: 18.h),
                ],
              ),
            ),

            // ── Perforation bottom ─────────────────────────────────
            _Perforation(),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _Perforation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14.h,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final count = (constraints.maxWidth / 10).floor();
          return Row(
            children: List.generate(count, (_) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                  height: 7.h,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFCBD5E1),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashW = 5.0;
        const gapW = 3.0;
        final count = (constraints.maxWidth / (dashW + gapW)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dashW,
              height: 1,
              margin: const EdgeInsets.only(right: gapW),
              color: const Color(0xFFCBD5E1),
            ),
          ),
        );
      },
    );
  }
}

class _ThinLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 0.8, color: const Color(0xFFCBD5E1));
}

class _DoubleLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Divider(height: 1, thickness: 1.2, color: const Color(0xFF1A1A1A)),
      SizedBox(height: 2.h),
      Divider(height: 1, thickness: 0.6, color: const Color(0xFF1A1A1A)),
    ],
  );
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _MetaRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 3.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 9.sp,
            color: const Color(0xFF6B6B6B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 9.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    ),
  );
}

class _ItemHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        flex: 10,
        child: Text(
          "ITEM",
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 9.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
            letterSpacing: 0.5,
          ),
        ),
      ),
      SizedBox(
        width: 28.w,
        child: Text(
          "QTY",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 9.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
            letterSpacing: 0.5,
          ),
        ),
      ),
      SizedBox(
        width: 52.w,
        child: Text(
          "AMOUNT",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 9.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
            letterSpacing: 0.5,
          ),
        ),
      ),
    ],
  );
}

class _ItemRow extends StatelessWidget {
  final String name;
  final int qty;
  final String price;
  final String? unitPrice;
  const _ItemRow({
    required this.name,
    required this.qty,
    required this.price,
    this.unitPrice,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = name.length > 24 ? "${name.substring(0, 23)}…" : name;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 9.5.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 28.w,
                child: Text(
                  "x$qty",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 9.sp,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ),
              SizedBox(
                width: 52.w,
                child: Text(
                  "\$$price",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          if (unitPrice != null && qty > 1)
            Padding(
              padding: EdgeInsets.only(left: 2.w, top: 1.h),
              child: Text(
                "  \$$unitPrice each",
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 8.sp,
                  color: const Color(0xFF9B9B9B),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _TotalRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 9.sp,
          color: const Color(0xFF6B6B6B),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: valueColor ?? const Color(0xFF1A1A1A),
        ),
      ),
    ],
  );
}

// ── Bottom action bar ─────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          // Copy-to-clipboard hint
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Preview only",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Close
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2F80ED),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, size: 12.sp, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
