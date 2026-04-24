import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:kinfox_biller/SalesScreen/Model/CheckoutModel.dart';
import 'package:kinfox_biller/SalesScreen/Views/PrinterSettingView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kDeviceName = 'printer_device_name';
const _kDeviceAddress = 'printer_device_address';
const _kConnType = 'printer_conn_type'; // "BLE" | "USB"
const _kMockMode = 'printer_mock_mode';

class PrinterController extends GetxController {
  // ── Shop config (set before printing) ─────────────────────────────────────
  String shopName = 'My Shop';
  String branchName = 'Main Branch';
  String shopAddress = '123 Main Street, City - 000000';
  String shopPhone = '+91 98765 43210';
  String shopGstin = '29ABCDE1234F1Z5';
  String? shopLogoPath = "assets/logo.png";

  // ── State ──────────────────────────────────────────────────────────────────
  bool isScanning = false;
  bool isConnected = false;
  bool mockMode = false;
  Printer? selectedPrinter;
  List<Printer> availableDevices = [];
  StreamSubscription<List<Printer>>? _scanSubscription;
  bool _isConnecting = false;

  // Saved (default) printer info from SharedPreferences
  String? savedDeviceName;
  String? savedDeviceAddress;
  ConnectionType? savedConnectionType;

  bool get hasSavedDevice => savedDeviceAddress != null;

  final _plugin = FlutterThermalPrinter.instance;

  bool isDeviceConnected(Printer printer) {
    if (!isConnected || selectedPrinter == null) return false;
    final selected = selectedPrinter!;
    if ((selected.address ?? '').isNotEmpty &&
        (printer.address ?? '').isNotEmpty) {
      return selected.address == printer.address;
    }
    return selected.name == printer.name &&
        selected.connectionType == printer.connectionType;
  }

  // ── Init ───────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initController();
  }

  /// Loads prefs then kicks off auto-connect, ensuring [update()] is always
  /// called at the end so the UI reflects the final state.
  Future<void> _initController() async {
    await _loadPrefs();
    await _autoConnect();
    update(); // ← guaranteed final UI refresh after full init
  }

  // ── SharedPreferences ──────────────────────────────────────────────────────
  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    savedDeviceName = p.getString(_kDeviceName);
    savedDeviceAddress = p.getString(_kDeviceAddress);
    final ct = p.getString(_kConnType);
    savedConnectionType = ct == 'USB' ? ConnectionType.USB : ConnectionType.BLE;
    mockMode = p.getBool(_kMockMode) ?? false;
    update();
  }

  Future<void> _savePrefs(Printer printer) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kDeviceName, printer.name ?? '');
    await p.setString(_kDeviceAddress, printer.address ?? '');
    await p.setString(
      _kConnType,
      printer.connectionType == ConnectionType.USB ? 'USB' : 'BLE',
    );
    savedDeviceName = printer.name;
    savedDeviceAddress = printer.address;
    savedConnectionType = printer.connectionType;
    update();
  }

  Future<void> clearSavedDevice() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kDeviceName);
    await p.remove(_kDeviceAddress);
    await p.remove(_kConnType);
    savedDeviceName = null;
    savedDeviceAddress = null;
    savedConnectionType = null;
    update();
  }

  // ── Auto-connect on start ──────────────────────────────────────────────────
  /// Returns a [Future] that completes once a connection is established or
  /// the scan window expires — callers can await it and then call [update()].
  Future<void> _autoConnect() async {
    if (savedDeviceAddress == null || mockMode) return;
    try {
      // Use a completer so we can await until the printer is actually found
      // and connected (or we time out), rather than fire-and-forget.
      final completer = Completer<void>();

      await _scanSubscription?.cancel();
      _scanSubscription = null;
      isScanning = true;
      availableDevices = [];
      update();

      _scanSubscription = _plugin.devicesStream.listen((printers) async {
        availableDevices = printers;
        update();

        final match = printers.firstWhereOrNull(
          (p) => p.address == savedDeviceAddress,
        );
        if (match != null && !_isConnecting && !isConnected) {
          await connectPrinter(match); // sets isConnected + calls update()
          stopScan();
          if (!completer.isCompleted) completer.complete();
        }
      });

      await _plugin.getPrinters(
        connectionTypes: [ConnectionType.BLE, ConnectionType.USB],
      );

      // Time-box the auto-connect attempt.
      await Future.any([
        completer.future,
        Future.delayed(const Duration(seconds: 10)),
      ]);

      stopScan();
    } catch (e) {
      stopScan();
      log('Auto-connect error: $e');
    }
  }

  // ── Scan ───────────────────────────────────────────────────────────────────
  Future<void> startScan({String? autoConnectAddress}) async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = true;
    availableDevices = [];
    update();

    try {
      _scanSubscription = _plugin.devicesStream.listen((printers) async {
        availableDevices = printers;

        // Keep selected printer in sync with refreshed scan objects.
        if (selectedPrinter != null) {
          final selected = selectedPrinter!;
          for (final device in printers) {
            if (((selected.address ?? '').isNotEmpty &&
                    (device.address ?? '').isNotEmpty &&
                    selected.address == device.address) ||
                (selected.name == device.name &&
                    selected.connectionType == device.connectionType)) {
              selectedPrinter = device;
              break;
            }
          }
        }
        update();

        if (autoConnectAddress != null) {
          final match = printers.firstWhereOrNull(
            (p) => p.address == autoConnectAddress,
          );
          if (match != null && !_isConnecting && !isConnected) {
            await connectPrinter(match);
            stopScan();
          }
        }
      });

      await _plugin.getPrinters(
        connectionTypes: [ConnectionType.BLE, ConnectionType.USB],
      );

      await Future.delayed(const Duration(seconds: 8));
      stopScan();
    } catch (e) {
      stopScan();
      _toast('Scan error: $e');
    }
  }

  void stopScan() {
    _plugin.stopScan();
    _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = false;
    update(); // ← always notify after stopping
  }

  // ── Connect / Disconnect ───────────────────────────────────────────────────
  Future<void> connectPrinter(Printer printer) async {
    if (_isConnecting) return;
    if (isDeviceConnected(printer)) {
      selectedPrinter = printer;
      isConnected = true;
      update();
      return;
    }

    _isConnecting = true;
    update(); // show "connecting…" state immediately
    try {
      await _plugin.connect(printer);
      selectedPrinter = printer;
      isConnected = true;
      _toast('Connected to ${printer.name ?? "printer"}');
    } catch (e) {
      isConnected = false;
      selectedPrinter = null;
      _toast('Connection failed: $e');
    } finally {
      _isConnecting = false;
      update(); // ← always refresh after connect attempt
    }
  }

  Future<void> disconnectPrinter() async {
    if (selectedPrinter == null) return;
    try {
      await _plugin.disconnect(selectedPrinter!);
    } catch (_) {}
    isConnected = false;
    selectedPrinter = null;
    update();
  }

  // ── Persist as default ─────────────────────────────────────────────────────
  Future<void> persistDevice(Printer printer) async {
    await _savePrefs(printer);
    _toast('${printer.name ?? "Printer"} set as default');
  }

  bool isSaved(Printer printer) =>
      printer.address != null && printer.address == savedDeviceAddress;

  // ── Mock mode ──────────────────────────────────────────────────────────────
  Future<void> toggleMockMode() async {
    mockMode = !mockMode;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kMockMode, mockMode);
    update();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String connectionLabel(Printer printer) =>
      printer.connectionType == ConnectionType.USB ? 'USB' : 'BLE';

  void _toast(String msg) => log(msg);

  // ── Open printer-settings dialog ───────────────────────────────────────────
  void openPrinterSettings() {
    Get.dialog(const PrinterSettingsDialog(), barrierDismissible: true);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PRINT RECEIPT
  // ───────────────────────────────────────────────────────────────────────────
  Future<void> printReceipt(CheckoutData data) async {
    if (!mockMode && !isConnected) {
      openPrinterSettings();
      _toast('Please connect a printer first');
      return;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    final moneyFmt = NumberFormat('#,##0.00');
    final dtFmt = DateFormat('dd MMM yyyy  hh:mm a');

    // ── 1. Shop logo ──────────────────────────────────────────────────────
    if (shopLogoPath != null) {
      try {
        Uint8List? rawBytes;

        // Support both asset paths (assets/...) and absolute file paths
        if (shopLogoPath!.startsWith('assets/')) {
          rawBytes = await _loadAssetBytes(shopLogoPath!);
        } else {
          final f = File(shopLogoPath!);
          if (await f.exists()) rawBytes = await f.readAsBytes();
        }

        if (rawBytes != null) {
          final decoded = img.decodeImage(rawBytes);
          if (decoded != null) {
            // Convert to greyscale first — improves thermal print contrast
            final grey = img.grayscale(decoded);
            final resized = img.copyResize(grey, width: 120);
            bytes += generator.imageRaster(
              resized,
              align: PosAlign.center,
              highDensityHorizontal: true,
              highDensityVertical: true,
            );
            bytes += generator.feed(1);
          }
        }
      } catch (e) {
        log('[Printer] Logo load failed: $e'); // graceful — print continues
      }
    }

    // ── 2. Shop name (large) ──────────────────────────────────────────────
    bytes += generator.text(
      shopName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    // ── 3. Address (single line) ──────────────────────────────────────────
    bytes += generator.text(
      shopAddress,
      styles: const PosStyles(align: PosAlign.center),
    );

    // ── 4. Phone & GSTIN on one line ──────────────────────────────────────
    bytes += generator.text(
      'Ph: $shopPhone  |  GSTIN: $shopGstin',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.hr(ch: '=');

    // ── 5. Invoice number & date/time ─────────────────────────────────────
    final inv = data.invoiceNumber ?? '-';
    final firstPay = data.payments.isNotEmpty ? data.payments.first : null;
    final dateStr = firstPay?.paidAt != null
        ? dtFmt.format(DateTime.tryParse(firstPay!.paidAt!) ?? DateTime.now())
        : dtFmt.format(DateTime.now());

    bytes += generator.row([
      PosColumn(
        text: 'Invoice#',
        width: 4,
        styles: const PosStyles(bold: true, align: PosAlign.left),
      ),
      PosColumn(
        text: inv,
        width: 8,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Date',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: dateStr,
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // ── 6. Customer (compact) ─────────────────────────────────────────────
    if (data.customer != null) {
      final c = data.customer!;
      bytes += generator.hr(ch: '-');
      if (c.name != null)
        bytes += generator.row([
          PosColumn(
            text: 'Customer',
            width: 4,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: c.name!,
            width: 8,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      if (c.phone != null)
        bytes += generator.row([
          PosColumn(text: 'Phone', width: 4),
          PosColumn(
            text: c.phone!,
            width: 8,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
    }

    bytes += generator.hr(ch: '=');

    // ── 7. Items table ────────────────────────────────────────────────────
    if (data.items.isNotEmpty) {
      // Header row
      bytes += generator.row([
        PosColumn(
          text: 'Item / Variant',
          width: 4,
          styles: const PosStyles(bold: true, underline: true),
        ),
        PosColumn(
          text: 'MRP',
          width: 2,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            underline: true,
          ),
        ),
        PosColumn(
          text: 'Qty',
          width: 1,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            underline: true,
          ),
        ),
        PosColumn(
          text: 'Rate',
          width: 2,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            underline: true,
          ),
        ),
        PosColumn(
          text: 'Amount',
          width: 3,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            underline: true,
          ),
        ),
      ]);
      bytes += generator.hr(ch: '-');
      double totalSaved = 0;

      for (final item in data.items) {
        final qty = item.quantity ?? 1;
        final lineTotal = item.lineTotal ?? 0;

        // Price logic:
        //   mrp          = item.price        (original / marked price)
        //   sellingPrice = item.sellingPrice  (discounted / actual charged price)
        // If sellingPrice is absent or equals mrp → no discount, show only one price.
        final mrp = item.price;
        final sp = item.sellingPrice;
        final hasDiscount = mrp != null && sp != null && mrp > sp;
        final displayRate = sp ?? mrp ?? (lineTotal / qty); // what was charged

        // Accumulate saved amount
        if (hasDiscount) {
          totalSaved += (mrp! - sp!) * qty;
        }

        // ── Product name + variant concatenated on ONE line (fontB, small) ──
        final variant = [
          item.size,
          item.color,
        ].where((v) => v != null && v.isNotEmpty).join('/');
        final nameVariant = variant.isNotEmpty
            ? '${item.productName ?? "Item"}  [$variant]'
            : (item.productName ?? 'Item');

        // Name+variant row — fontB keeps it compact
        bytes += generator.row([
          PosColumn(
            text: nameVariant,
            width: 4,
            styles: const PosStyles(
              fontType: PosFontType.fontB,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true,
            ),
          ),
          PosColumn(
            text: (mrp != null)
                ? moneyFmt.format(mrp)
                : moneyFmt.format(displayRate),
            width: 2,
            styles: const PosStyles(
              fontType: PosFontType.fontB,
              align: PosAlign.right,
            ),
          ),
          PosColumn(
            text: '$qty',
            width: 1,
            styles: const PosStyles(
              fontType: PosFontType.fontB,
              align: PosAlign.center,
            ),
          ),
          PosColumn(
            text: moneyFmt.format(displayRate),
            width: 2,
            styles: const PosStyles(
              fontType: PosFontType.fontB,
              align: PosAlign.right,
            ),
          ),
          PosColumn(
            text: moneyFmt.format(lineTotal),
            width: 3,
            styles: const PosStyles(
              fontType: PosFontType.fontB,
              align: PosAlign.right,
            ),
          ),
        ]);

        // ── MRP + You Save sub-line (only when discount exists) ─────────────
        if (hasDiscount) {
          final savedPerUnit = mrp! - sp!;
          bytes += generator.row([
            PosColumn(
              text: '  MRP:${moneyFmt.format(mrp)}',
              width: 6,
              styles: const PosStyles(
                fontType: PosFontType.fontB,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              ),
            ),
            PosColumn(
              text: 'Save:${moneyFmt.format(savedPerUnit * qty)}',
              width: 6,
              styles: const PosStyles(
                fontType: PosFontType.fontB,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right,
              ),
            ),
          ]);
        }
      }

      bytes += generator.hr(ch: '-');

      // ── Saved amount (informational, no calculation change) ─────────────
      if (totalSaved > 0) {
        bytes += generator.row([
          PosColumn(
            text: '** You Saved **',
            width: 7,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: moneyFmt.format(totalSaved),
            width: 5,
            styles: const PosStyles(bold: true, align: PosAlign.right),
          ),
        ]);
        bytes += generator.hr(ch: '-');
      }
    }

    // ── 8. Return items ───────────────────────────────────────────────────
    if (data.returnItems.isNotEmpty) {
      bytes += generator.text('Returns', styles: const PosStyles(bold: true));
      bytes += generator.hr(ch: '-');
      for (final ri in data.returnItems) {
        final name = ri.productName ?? 'Return Item';
        final variant = [
          ri.size,
          ri.color,
        ].where((v) => v != null && v.isNotEmpty).join(' / ');
        final credit = (ri.creditPerUnit ?? 0) * (ri.quantity ?? 1);
        bytes += generator.row([
          PosColumn(
            text: '$name${variant.isNotEmpty ? " ($variant)" : ""}',
            width: 8,
          ),
          PosColumn(
            text: '-${moneyFmt.format(credit)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      bytes += generator.hr(ch: '-');
    }

    // ── 9. Totals block ───────────────────────────────────────────────────
    void totRow(
      String label,
      double? val, {
      bool bold = false,
      String prefix = '',
    }) {
      if (val == null) return;
      bytes += generator.row([
        PosColumn(
          text: label,
          width: 7,
          styles: PosStyles(bold: bold),
        ),
        PosColumn(
          text: '$prefix${moneyFmt.format(val)}',
          width: 5,
          styles: PosStyles(bold: bold, align: PosAlign.right),
        ),
      ]);
    }

    totRow('Subtotal', data.subtotal);

    if ((data.discountedSubtotal ?? 0) < (data.subtotal ?? 0)) {
      final disc = (data.subtotal ?? 0) - (data.discountedSubtotal ?? 0);
      totRow('Discount', disc, prefix: '-');
    }

    if ((data.appliedReturnDiscount ?? 0) > 0) {
      totRow('Return Credit', data.appliedReturnDiscount, prefix: '-');
    }

    // ── GST split: SGST 2.5% + CGST 2.5% ─────────────────────────────────
    final gstAmt = data.gstAmount ?? 0;
    if (gstAmt > 0) {
      final half = gstAmt / 2;
      totRow('SGST (${(data.gstPercent ?? 0) / 2}%)', half);
      totRow('CGST (${(data.gstPercent ?? 0) / 2}%)', half);
    }

    bytes += generator.hr(ch: '=');
    totRow('GRAND TOTAL', data.grandFinalTotal, bold: true);
    bytes += generator.hr(ch: '=');

    // ── 10. Payments ──────────────────────────────────────────────────────
    if (data.payments.isNotEmpty) {
      bytes += generator.text(
        'Payment Details',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.hr(ch: '-');
      for (final pay in data.payments) {
        bytes += generator.row([
          PosColumn(text: pay.paymentMethod ?? '-', width: 7),
          PosColumn(
            text: moneyFmt.format(pay.amount ?? 0),
            width: 5,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      if ((data.refundAmount ?? 0) > 0) {
        bytes += generator.hr(ch: '-');
        totRow('Refund', data.refundAmount, bold: true);
      }
      bytes += generator.hr();
    }

    // ── 11. Vouchers issued ───────────────────────────────────────────────
    if (data.availableVouchers.isNotEmpty) {
      bytes += generator.text(
        '---- Vouchers Issued ----',
        styles: const PosStyles(bold: true, align: PosAlign.center),
      );
      for (final v in data.availableVouchers) {
        if (v.voucherCode != null) {
          bytes += generator.text(
            v.campaignName ?? '',
            styles: const PosStyles(align: PosAlign.center),
          );
          bytes += generator.text(
            v.voucherCode!,
            styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
              underline: true,
            ),
          );
          if (v.campaignEndDate != null) {
            try {
              final exp = DateTime.parse(v.campaignEndDate!);
              bytes += generator.text(
                'Valid until: ${DateFormat('dd MMM yyyy').format(exp)}',
                styles: const PosStyles(align: PosAlign.center),
              );
            } catch (_) {}
          }
        }
      }
      bytes += generator.hr();
    }

    // ── 12. Invoice barcode ───────────────────────────────────────────────
    if (data.invoiceNumber != null) {
      bytes += generator.text(
        'Scan to verify',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.barcode(
        Barcode.code128(
          data.invoiceNumber!.replaceAll('INV-', '').characters.toList(),
        ),
        height: 64,
        textPos: BarcodeText.below,
      );
      bytes += generator.feed(1);
    }

    // ── 13. Footer ────────────────────────────────────────────────────────
    bytes += generator.hr(ch: '*');
    bytes += generator.text(
      'Thank you for shopping!',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      shopName,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      'Visit us again  •  $shopPhone',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(3);
    bytes += generator.cut();

    // ── Send ──────────────────────────────────────────────────────────────
    if (mockMode) {
      _showMockPreview(data, bytes);
    } else {
      if (Platform.isMacOS) {
        await _printViaCups(bytes);
      } else {
        await _plugin.printData(selectedPrinter!, bytes, longData: true);
      }
      _toast('Receipt printed ✓');
    }
  }

  // ── CUPS (macOS) ───────────────────────────────────────────────────────────
  String _cupsSafeName(String? name) {
    if (name == null || name.isEmpty) return '';
    return name.trim().replaceAll(RegExp(r'[\s\-]+'), '_');
  }

  Future<void> _printViaCups(List<int> bytes) async {
    final queueName = _cupsSafeName(selectedPrinter!.name);
    if (queueName.isEmpty) throw Exception('No printer name available');

    final baseDir = await getApplicationSupportDirectory();
    final printDir = Directory('${baseDir.path}/thermal_prints');
    if (!await printDir.exists()) await printDir.create(recursive: true);

    final file = File(
      '${printDir.path}/thermal_print_${DateTime.now().millisecondsSinceEpoch}.bin',
    );
    await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);
    log('[Printer] Sending ${bytes.length} bytes to CUPS queue: $queueName');

    final result = await Process.run('/usr/bin/lp', [
      '-d',
      queueName,
      '-o',
      'raw',
      file.path,
    ]);
    try {
      await file.delete();
    } catch (_) {}

    if (result.exitCode != 0) {
      final err = result.stderr.toString().trim();
      log('[Printer] CUPS error: $err');
      throw Exception('CUPS print failed (exit ${result.exitCode}): $err');
    }
    log('[Printer] CUPS accepted job for $queueName');
  }

  // ── Mock preview ───────────────────────────────────────────────────────────
  void _showMockPreview(CheckoutData data, List<int> bytes) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mock Print Preview'),
        content: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Text(
              'Invoice : ${data.invoiceNumber ?? "-"}\n'
              'Items   : ${data.items.length}\n'
              'Total   : ${data.grandFinalTotal ?? 0}\n'
              'Bytes   : ${bytes.length} bytes queued\n\n'
              '(Mock mode — no hardware needed)',
              style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
            ),
          ),
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
      ),
    );
  }

  // ── Asset loader ───────────────────────────────────────────────────────────
  Future<Uint8List> _loadAssetBytes(String path) async {
    final data = await DefaultAssetBundle.of(Get.context!).load(path);
    return data.buffer.asUint8List();
  }
}
