import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';

class CartTableWidget extends StatelessWidget {
  final CartModel cart;
  final Function(int variantId) onIncrease;
  final Function(int variantId) onDecrease;
  final Function(int variantId) onDelete;

  const CartTableWidget({
    super.key,
    required this.cart,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
   
    final List<dynamic> rows = [
      ...cart.items,
      ...cart.returnItems,
    ];

    return Container(
      height: 500.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Expanded(
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 900,
              headingRowHeight: 45.h,
              dataRowHeight: 70.h,
              headingRowColor:
                  WidgetStateProperty.all(Colors.grey.shade100),
              columns: [
                DataColumn2(
                  size: ColumnSize.L,
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: _headerText("ITEM DETAILS"),
                  ),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  numeric: true,
                  label: Align(
                    alignment: Alignment.centerRight,
                    child: _headerText("PRICE"),
                  ),
                ),
                DataColumn2(
                  size: ColumnSize.L,
                  label: Align(
                    alignment: Alignment.center,
                    child: _headerText("QTY"),
                  ),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  numeric: true,
                  label: Align(
                    alignment: Alignment.center,
                    child: _headerText("TOTAL"),
                  ),
                ),
                DataColumn2(
                  size: ColumnSize.L,
                  label: Align(
                    alignment: Alignment.center,
                    child: _headerText("ACTION"),
                  ),
                ),
              ],

              /// ✅ ROWS
              rows: List.generate(rows.length, (index) {
                final row = rows[index];
                final bool isReturn = row is ReturnItemModel;

              
                final String name =
                    isReturn ? "Returned Item" : row.productName;

                final String sku =
                    isReturn ? "" : row.sku;

                final double price =
                    isReturn ? row.creditPerUnit : row.price;

                final int qty = row.quantity;

                final double total = isReturn
                    ? row.creditPerUnit * row.quantity
                    : row.lineTotal;

                final int variantId = row.variantId;

                return DataRow(
                  cells: [
                    /// ITEM DETAILS
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isReturn
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                          if (!isReturn)
                            Text(
                              "SKU: $sku",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),

                    /// PRICE
                    DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: _value(
                          "${isReturn ? "-₹" : "₹"}${price.toStringAsFixed(2)}",
                        ),
                      ),
                    ),

                    /// QTY
                    DataCell(
                      Center(
                        child: isReturn
                            ? Text(
                                "$qty",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _qtyBtn(
                                      "-", () => onDecrease(variantId)),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "$qty",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  _qtyBtn(
                                      "+", () => onIncrease(variantId)),
                                ],
                              ),
                      ),
                    ),

                    /// TOTAL
                    DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: _value(
                          "${isReturn ? "-₹" : "₹"}${total.toStringAsFixed(2)}",
                          isBold: true,
                        ),
                      ),
                    ),

                  
                   DataCell(
  Center(
    child: IconButton(
      onPressed: () => onDelete(variantId),
      icon: Icon(
        Icons.delete_outline,
        color: isReturn ? Colors.red : Colors.red,
      ),
    ),
  ),
),
                  ],
                );
              }),
            ),
          ),

          Divider(),
          _footer(rows.length),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _value(String text, {bool isBold = false}) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }

  Widget _qtyBtn(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26.w,
        height: 26.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _footer(int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Items Count: $count",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          Row(
            children: [
              Icon(Icons.refresh, size: 16.sp, color: Colors.blue),
              SizedBox(width: 4.w),
              Text(
                "View Recent Transactions",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}