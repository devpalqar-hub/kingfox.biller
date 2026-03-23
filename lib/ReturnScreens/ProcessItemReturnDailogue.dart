import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/ReturnHistoryScreen/Service/ReturnController.dart';

class ProcessItemReturnDialog extends StatelessWidget {
  ProcessItemReturnDialog({super.key});

  final ReturnsController controller = Get.put(ReturnsController());
  final TextEditingController invoiceController = TextEditingController();
    

TextEditingController internalNoteController = TextEditingController();

  final List<String> returnReasons = [
  "Sizing issue / Too large",
  "Sizing issue / Too small",
  "Damaged item",
  "Defective product",
  "Wrong item delivered",
  "Quality not as expected",
  "Item no longer needed",
  "Changed mind",
  "Received late",
  "Other",
];



  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Container(
        width: 860.w,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              Container(
                height: 64.h,
                decoration: const BoxDecoration(color: Color(0xff0F49BD)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back,
                              size: 20.sp, color: Colors.white),
                          SizedBox(width: 10.w),
                          Text(
                            "Process Item Return",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 520.w),
                  
                  ],
                ),
              ),
          
              SizedBox(height: 20.h),
          
              /// STEP 1
              _sectionTitle("1", "LOCATE ORIGINAL ORDER"),
          
              SizedBox(height: 10.h),
          
           Padding(
  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
  child: Row(
    children: [
      Expanded(
        child: Container(
          height: 45.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              SizedBox(width: 15.w),
              Icon(Icons.receipt_long_outlined),
              SizedBox(width: 10.w),

              Expanded(
                child: TextField(
                  controller: invoiceController,

                  /// ❌ REMOVE onChanged logic completely

                  decoration: InputDecoration(
                    hintText: "2345",
                    prefixText: "INV-", // ✅ only UI prefix
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(width: 10.w),

      GestureDetector(
        onTap: () {
          final raw = invoiceController.text.trim();

          if (raw.isNotEmpty) {
            final fullInvoice = "INV-$raw"; // ✅ ADD PREFIX HERE ONLY
            controller.getInvoice(fullInvoice);
          } else {
            Get.snackbar("Error", "Enter invoice number");
          }
        },
        child: Container(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xff0F49BD),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                "Fetch Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),
              SizedBox(height: 20.h),
          
              /// STEP 2
              _sectionTitle("2", "ORIGINAL ORDER ITEMS"),
          
              SizedBox(height: 10.h),
          
              GetBuilder<ReturnsController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  }
          
                  if (controller.invoice == null) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No invoice loaded"),
                    );
                  }
          
                  return _orderItemsTable(controller);
                },
              ),
          
              SizedBox(height: 20.h),
          
              /// STEP 3
              _sectionTitle("3", "ITEMS BEING RETURNED"),
          
              SizedBox(height: 10.h),
          
              GetBuilder<ReturnsController>(
                builder: (controller) {
                  return _returnItemCard(controller);
                },
              ),
          
              SizedBox(height: 15.h),
          
              Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                
          
                SizedBox(height: 10.h),
          
                GetBuilder<ReturnsController>(
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
          children: [
            /// DROPDOWN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("REASON FOR RETURN"),
                  SizedBox(height: 5.h),
                  _dropdownField(controller),
                ],
              ),
            ),
          
            SizedBox(width: 10.w),
          
            /// INPUT (ONLY FOR "OTHER")
            if (controller.selectedReason == "Other")
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("INTERNAL NOTE"),
                    SizedBox(height: 5.h),
                    _inputField(
                      controller.internalNoteController,
                      "Add details about condition...",
                    ),
                  ],
                ),
              ),
          ],
                ),
              );
            },
          )
              ],
            ),
          ),
              SizedBox(height: 40.h),
               
               Divider(height: 1.h),
          
              /// FOOTER
            
                       _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= TABLE =================

  Widget _orderItemsTable(ReturnsController controller) {
   final invoice = controller.invoice;
if (invoice == null) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            _tableHeader(),

            ...invoice.items.map((item) {
              final variant = item.variant;
              final product = variant?.product;

              return _tableRow(
                controller,
                product?.name ?? "",
                variant?.sku ?? "",
                item.quantity.toString(),
                "₹${item.subtotal}",
                item.variantId,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: Colors.grey.shade100,
      child: const Row(
        children: [
          Expanded(flex: 4, child: Text("Item Details")),
          Expanded(child: Text("Qty")),
          Expanded(child: Text("Price")),
          Expanded(child: Text("Action")),
        ],
      ),
    );
  }

  Widget _tableRow(
    ReturnsController controller,
    String name,
    String sku,
    String qty,
    String price,
    int variantId,
  ) {
    final selected = controller.isItemSelected(variantId);

    return Container(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        const TextStyle(fontWeight: FontWeight.w500)),
                Text("SKU: $sku",
                    style: TextStyle(fontSize: 11.sp)),
              ],
            ),
          ),
          Expanded(child: Text(qty)),
          Expanded(child: Text(price)),
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.toggleItemSelection(variantId);
                 maxQty: int.parse(qty);
              },
              child: Text(
                selected ? "Selected" : "Add to Return",
                style: TextStyle(
                  color: selected ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= RETURN ITEMS =================
           Widget _returnItemCard(ReturnsController controller) {
  if (controller.selectedItems.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("No items selected"),
    );
  }

  final invoice = controller.invoice;

  final selectedItems = invoice!.items
      .where((item) => controller.selectedItems.contains(item.variantId))
      .toList();

  return Column(
    children: [
      /// HEADER (UNCHANGED)
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                "Product",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade800,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Return Qty",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade800,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Subtotal",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade800,
                ),
              ),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),

      /// LIST
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
          ),
          child: Column(
            children: selectedItems.map((item) {
              final variant = item.variant;
              final product = variant?.product;

              final qty = controller.returnQty[item.variantId] ?? 1;

              return Row(
                children: [
                  /// PRODUCT
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          variant?.sku ?? "",
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),

                  /// QTY
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.decreaseQty(item.variantId);
                          },
                          child: _qtyBtn(Icons.remove),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(qty.toString()),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.increaseQty(
                              item.variantId,
                              item.quantity,
                            );
                          },
                          child: _qtyBtn(Icons.add),
                        ),
                      ],
                    ),
                  ),

                  /// SUBTOTAL
                  Expanded(
  flex: 2,
  child: Builder(
    builder: (_) {
      final price = double.tryParse(item.price.toString()) ?? 0.0;

      return Text(
        "₹${(qty * price).toStringAsFixed(2)}",
        style: const TextStyle(color: Colors.red),
      );
    },
  ),
),

                  /// DELETE
                  GestureDetector(
                    onTap: () {
                      controller.toggleItemSelection(item.variantId);
                    },
                    child:
                        const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

Widget _sectionTitle(String step, String title) { return Padding( padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h), child: Row( children: [ CircleAvatar(radius: 12.r, child: Text(step)), SizedBox(width: 10.w), Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), ], ), ); }
Widget _qtyBtn(IconData icon) {
   return Container( padding:
    EdgeInsets.all(6.w),
     decoration: BoxDecoration(
       border: Border.all(color: Colors.red), 
       borderRadius: BorderRadius.circular(6.r), ),
        child: Icon(icon, size: 14.sp, color: Colors.red), ); }
  
  Widget _dropdownField(ReturnsController controller) {
  return GetBuilder<ReturnsController>(
    builder: (_) {
      return Container(
        height: 45.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedReason,

            hint: const Text("Select reason"), // ✅ DEFAULT TEXT

            isExpanded: true,

            items: [
              /// 🔥 ADD PLACEHOLDER ITEM
              const DropdownMenuItem<String>(
                value: null,
                child: Text(
                  "Select reason",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              ...controller.returnReasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
            ],

            onChanged: (value) {
              controller.selectedReason = value;
              controller.update();
            },
          ),
        ),
      );
    },
  );
}

  Widget _inputField(TextEditingController controller, String hint) {
  return Container(
    height: 45.h,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
      ),
    ),
  );
}

Widget _buildFooter(BuildContext context) {
  return GetBuilder<ReturnsController>(
    builder: (controller) {
      final total = controller.totalReturnAmount;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// TOTAL SECTION
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "REFUND TOTAL",
                  style: TextStyle(
                    color: const Color(0xff94A3B8),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 5.h),

                Text(
                  controller.selectedItems.isEmpty
                      ? "No items to return"
                      : "₹ ${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff0F49BD),
                  ),
                ),
              ],
            ),

            /// BUTTONS
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40.h,
                    width: 100.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),

                SizedBox(width: 10.w),

                GestureDetector(
                               onTap: controller.selectedItems.isEmpty
    ? null
    : () async {
        final success = await controller.addReturnItemsToCart();

        if (success) {
          controller.clearReturnData();
          Navigator.of(Get.context!, rootNavigator: true).pop();
        }
      },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: controller.selectedItems.isEmpty
                          ? Colors.grey
                          : const Color(0xff0F49BD),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.shopping_cart_outlined,
                            color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Add Returns to Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}}