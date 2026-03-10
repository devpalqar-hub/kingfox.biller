import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Service/InventoryController.dart';

class InventoryTable extends StatefulWidget {
  const InventoryTable({super.key});

  @override
  State<InventoryTable> createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {

  final InventoryController controller = Get.put(InventoryController());

  @override
  void initState() {
    super.initState();
    controller.getInventory();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<InventoryController>(
      builder: (ctrl) {

        if (ctrl.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.inventories.isEmpty) {
          return const Center(child: Text("No inventory found."));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [

              _header(),

              SizedBox(height: 15.h),

              ...ctrl.inventories.map((item) {

                final productName = item.variant?.product?.name ?? "";
                final sku = item.variant?.sku ?? "";
                final sizeColor =
                    "${item.variant?.size ?? ""} / ${item.variant?.color ?? ""}";
                final stock = item.stockQuantity ?? 0;
                final price = item.variant?.sellingPrice ?? "0";
                final branch = item.branch?.name ?? "";

                return _data(
                  productName,
                  branch,
                  sku,
                  sizeColor,
                  '$stock Units',
                  '₹$price',
                  stock > 10
                      ? Colors.green
                      : stock > 0
                          ? Colors.orange
                          : Colors.red,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("PRODUCT"),
        Text("BRANCH"),
        Text("SKU"),
        Text("SIZE / COLOR"),
        Text("STOCK LEVEL"),
        Text("PRICE"),
      ],
    );
  }

  Widget _data(
      String product,
      String branch,
      String sku,
      String sizeColor,
      String stock,
      String price,
      Color stockColor) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(product),

          Text(branch),

          Text(sku),

          Text(sizeColor),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: stockColor.withOpacity(.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              stock,
              style: TextStyle(
                color: stockColor,
                fontSize: 12.sp,
              ),
            ),
          ),

          Text(
            price,
            style: TextStyle(
              color: const Color(0xff22C55E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}