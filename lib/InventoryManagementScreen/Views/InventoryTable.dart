import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Service/BarcodeController.dart';
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
                  item.variant!.barcode ?? "00",
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
      children: const [
        Expanded(flex: 2, child: Text("PRODUCT")),
        Expanded(flex: 2, child: Text("BRANCH")),
        Expanded(flex: 2, child: Text("SKU")),
        Expanded(flex: 2, child: Text("SIZE / COLOR")),
        Expanded(flex: 2, child: Text("STOCK LEVEL")),
        Expanded(flex: 1, child: Text("PRICE")),
        Visibility(visible: false, child: Icon(Icons.print)),
      ],
    );
  }
}

Widget _data(
  String product,
  String branch,
  String sku,
  String sizeColor,
  String stock,
  String price,
  Color stockColor,
  String barcode,
) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.h),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text(product)),
        Expanded(flex: 2, child: Text(branch)),
        Expanded(flex: 2, child: Text(sku)),
        Expanded(flex: 2, child: Text(sizeColor)),

        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: stockColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                stock,
                style: TextStyle(color: stockColor, fontSize: 12.sp),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            price,
            style: TextStyle(
              color: const Color(0xff22C55E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            BarcodePrinterController ctrl = Get.put(BarcodePrinterController());
            ctrl.openBarcodePrinter(
              BarcodePrintJob(
                barcodeValue: barcode,
                productName: product,
                variantName: sizeColor,
                price: double.parse(price.replaceAll("₹", "")),
                count: 48,
              ),
            );
          },
          child: Icon(Icons.print),
        ),
      ],
    ),
  );
}
