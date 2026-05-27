import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/ReturnScreen/Service/ReturnController.dart';
import 'package:kinfox_biller/ReturnScreen/ProcessItemReturnDailogue.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';
import 'package:kinfox_biller/SalesScreen/Service/CustomerController.dart';
import 'package:kinfox_biller/SalesScreen/Views/BillSummaryCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/CartTable.dart';
import 'package:kinfox_biller/SalesScreen/Views/CustomerCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/NoProductsCard.dart';
import 'package:kinfox_biller/SalesScreen/Views/ScanSearch.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController scanController = TextEditingController();
  late AddProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddProductController(), permanent: true);
    Get.put(CustomerController(), permanent: true);
  }

  @override
  void dispose() {
    scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BarcodeKeyboardListener(
      bufferDuration: const Duration(milliseconds: 70),
      onBarcodeScanned: (code) async {
        FocusScope.of(context).unfocus();

        // final customerCtrl = Get.find<CustomerController>();
        // if (customerCtrl.isDropdownOpen) {
        //   customerCtrl.closeDropdown();
        // }
        // if (controller.searchProductsList.isNotEmpty) {
        //   controller.searchProductsList.clear();
        //   controller.update();
        // }

        await controller.scanFromKeyboard(code, gstPercent: 5);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
              final customerCtrl = Get.find<CustomerController>();
              if (customerCtrl.isDropdownOpen) {
                customerCtrl.closeDropdown();
              }
              if (controller.searchProductsList.isNotEmpty) {
                controller.searchProductsList.clear();
                controller.update();
              }
            },
            child: GetBuilder<AddProductController>(
              builder: (ctrl) {
                // if (ctrl.isLoading) {
                //   return const Center(child: CircularProgressIndicator());
                // }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── LEFT PANEL ────────────────────────────────────────────
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 12.h, 6.w, 12.h),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                ScanSearch(
                                  controller: scanController,
                                  onReturnTap: () => showDialog(
                                    context: Get.context!,
                                    builder: (_) => ProcessItemReturnDialog(),
                                  ),
                                ),
                                SizedBox(height: 94.h),

                                // if (ctrl.session.length == 1)
                                // ── SESSION CARDS ────────────────────────────────────────────────────────
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 15.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              if (ctrl.session.length > 1)
                                                for (var item
                                                    in ctrl.session) ...[
                                                  Builder(
                                                    builder: (context) {
                                                      final isSelected =
                                                          item.billingSessionId ==
                                                          ctrl.selectedSessionId;
                                                      // Format: last 3 digits max, e.g. #007, #42, #1234 → show full if < 3 digits, else show as-is
                                                      final sessionLabel =
                                                          '#${item.billingSessionId.toString().padLeft(3, '0')}';

                                                      return GestureDetector(
                                                        onTap: () =>
                                                            ctrl.changeSession(
                                                              item.billingSessionId,
                                                            ),
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                right: 8.w,
                                                                bottom: 6.h,
                                                              ),
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    10.w,
                                                              ),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 32.h,
                                                          decoration: BoxDecoration(
                                                            color: isSelected
                                                                ? const Color(
                                                                    0xFFEFF6FF,
                                                                  )
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6.r,
                                                                ),
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? const Color(
                                                                      0xFF3B82F6,
                                                                    )
                                                                  : (item.itemCount ==
                                                                        0)
                                                                  ? Color(
                                                                      0xFFF09042,
                                                                    )
                                                                  : const Color(
                                                                      0xFFE2E8F0,
                                                                    ),
                                                              width: isSelected
                                                                  ? 1.5
                                                                  : 1.0,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                      0.03,
                                                                    ),
                                                                blurRadius: 3,
                                                                offset:
                                                                    const Offset(
                                                                      0,
                                                                      1,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                sessionLabel,
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      isSelected
                                                                      ? FontWeight
                                                                            .w700
                                                                      : FontWeight
                                                                            .w600,
                                                                  color:
                                                                      isSelected
                                                                      ? const Color(
                                                                          0xFF1D4ED8,
                                                                        )
                                                                      : (item.itemCount ==
                                                                            0)
                                                                      ? Color(
                                                                          0xFFF09042,
                                                                        )
                                                                      : const Color(
                                                                          0xFF334155,
                                                                        ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 6.w,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () => ctrl
                                                                    .deleteSession(
                                                                      item.billingSessionId,
                                                                    ),
                                                                child: Icon(
                                                                  Icons
                                                                      .close_rounded,
                                                                  size: 13.sp,
                                                                  color:
                                                                      isSelected
                                                                      ? const Color(
                                                                          0xFF3B82F6,
                                                                        )
                                                                      : (item.itemCount ==
                                                                            0)
                                                                      ? Color(
                                                                          0xFFF09042,
                                                                        )
                                                                      : const Color(
                                                                          0xFF94A3B8,
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (ctrl.session
                                              .where((it) => it.itemCount == 0)
                                              .length ==
                                          0)
                                        GestureDetector(
                                          onTap:
                                              ()
                                              //  {
                                              //   print(
                                              //     ctrl.session
                                              //         .where(
                                              //           (it) => it.itemCount == 0,
                                              //         )
                                              //         .length,
                                              //   );
                                              // },
                                              => ctrl.createSession(),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              right: 8.w,
                                              bottom: 6.h,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                            ),
                                            alignment: Alignment.center,
                                            height: 32.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                              border: Border.all(
                                                color: const Color(0xFFE2E8F0),
                                                width: 1.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.02),
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add_rounded,
                                                  size: 15.sp,
                                                  color: const Color(
                                                    0xFF10B981,
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  'New',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xFF10B981,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child:
                                      ctrl.cart == null ||
                                          (ctrl.cart!.items.isEmpty &&
                                              ctrl.cart!.returnItems.isEmpty)
                                      ? const NoProductsCard()
                                      : CartTableWidget(
                                          cart: ctrl.cart!,
                                          onIncrease: (id) {
                                            if (ctrl.isUpdatingQty) return;
                                            final item = ctrl.cart!.items
                                                .firstWhere(
                                                  (e) => e.variantId == id,
                                                );
                                            ctrl.updateCartItemQuantity(
                                              id,
                                              item.quantity + 1,
                                            );
                                          },
                                          onDecrease: (id) {
                                            if (ctrl.isUpdatingQty) return;
                                            final item = ctrl.cart!.items
                                                .firstWhere(
                                                  (e) => e.variantId == id,
                                                );
                                            if (item.quantity > 1) {
                                              ctrl.updateCartItemQuantity(
                                                id,
                                                item.quantity - 1,
                                              );
                                            }
                                          },
                                          onDelete: (id, isReturn) async {
                                            if (ctrl.isUpdatingQty) return;
                                            if (isReturn) {
                                              final rc =
                                                  Get.find<ReturnsController>();
                                              final ok = await rc
                                                  .deleteReturnItemsFromCart([
                                                    id,
                                                  ]);
                                              if (ok) await ctrl.getCart();
                                            } else {
                                              await ctrl.updateCartItemQuantity(
                                                id,
                                                0,
                                              );
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 50.h,
                              left: 0,
                              right: 0,
                              child: CustomerCard(
                                nameController: ctrl.nameController,
                                phoneController: ctrl.phoneController,
                              ),
                            ),
                            if (ctrl.searchProductsList.isNotEmpty)
                              Positioned(
                                top: 48.h,
                                left: 0,
                                right: 84.w,
                                child: _SearchDropdown(
                                  ctrl: ctrl,
                                  scanController: scanController,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // ── RIGHT PANEL ───────────────────────────────────────────
                    SizedBox(
                      width: 320.w,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(6.w, 12.h, 12.w, 12.h),
                        child: const BillSummaryCard(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── SEARCH DROPDOWN ────────────────────────────────────────────────────────────
class _SearchDropdown extends StatelessWidget {
  final AddProductController ctrl;
  final TextEditingController scanController;

  const _SearchDropdown({required this.ctrl, required this.scanController});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 260.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        itemCount: ctrl.searchProductsList.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: const Color(0xFFF1F5F9)),
        itemBuilder: (_, i) => _ProductTile(
          product: ctrl.searchProductsList[i],
          ctrl: ctrl,
          scanController: scanController,
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final dynamic product;
  final AddProductController ctrl;
  final TextEditingController scanController;

  const _ProductTile({
    required this.product,
    required this.ctrl,
    required this.scanController,
  });

  @override
  Widget build(BuildContext context) {
    final inStock = product.inStock as bool;
    return InkWell(
      onTap: inStock
          ? () async {
              await ctrl.scanAndAddProduct(product.barcode, 5);
              ctrl.searchProductsList.clear();
              scanController.clear();
              ctrl.resetVoucherSelection();
            }
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 18.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${product.size}  •  ${product.color}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${product.sellingPrice}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: inStock
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    inStock ? '+ Add' : 'Out',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: inStock
                          ? const Color(0xFF15803D)
                          : const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
