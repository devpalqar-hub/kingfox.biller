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
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
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
  // ── Shop config (set before printing) ──────────────────────────────────────
  String shopName = 'My Shop';
  String branchName = 'Main Branch';
  String? shopLogoPath = "assets/logo.png"; // local asset path or null

  // ── State ───────────────────────────────────────────────────────────────────
  bool isScanning = false;
  bool isConnected = false;
  bool mockMode = false;
  Printer? selectedPrinter;
  List<Printer> availableDevices = [];
  StreamSubscription<List<Printer>>? _scanSubscription;

  // Saved (default) printer info from SharedPreferences
  String? savedDeviceName;
  String? savedDeviceAddress;
  ConnectionType? savedConnectionType;

  bool get hasSavedDevice => savedDeviceAddress != null;

  final _plugin = FlutterThermalPrinter.instance;

  // ── Init ────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadPrefs().then((_) => _autoConnect());
  }

  // ── SharedPreferences ───────────────────────────────────────────────────────
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

  // ── Auto-connect on start ───────────────────────────────────────────────────
  Future<void> _autoConnect() async {
    if (savedDeviceAddress == null || mockMode) return;
    try {
      await startScan(autoConnectAddress: savedDeviceAddress);
    } catch (_) {}
  }

  // ── Scan ────────────────────────────────────────────────────────────────────
  Future<void> startScan({String? autoConnectAddress}) async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = true;
    availableDevices = [];
    update();

    try {
      _scanSubscription = _plugin.devicesStream.listen((printers) async {
        availableDevices = printers;
        update();

        if (autoConnectAddress != null) {
          final match = printers.firstWhereOrNull(
            (p) => p.address == autoConnectAddress,
          );
          if (match != null) {
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
    update();
  }

  // ── Connect / Disconnect ────────────────────────────────────────────────────
  Future<void> connectPrinter(Printer printer) async {
    try {
      await _plugin.connect(printer);
      selectedPrinter = printer;
      isConnected = true;
      update();
      _toast('Connected to ${printer.name ?? "printer"}');
    } catch (e) {
      _toast('Connection failed: $e');
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

  // ── Persist as default ──────────────────────────────────────────────────────
  Future<void> persistDevice(Printer printer) async {
    await _savePrefs(printer);
    _toast('${printer.name ?? "Printer"} set as default');
  }

  bool isSaved(Printer printer) =>
      printer.address != null && printer.address == savedDeviceAddress;

  // ── Mock mode ───────────────────────────────────────────────────────────────
  Future<void> toggleMockMode() async {
    mockMode = !mockMode;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kMockMode, mockMode);
    update();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String connectionLabel(Printer printer) =>
      printer.connectionType == ConnectionType.USB ? 'USB' : 'BLE';

  void _toast(String msg) {
    log(msg);
  }

  // ── Open printer-settings dialog ────────────────────────────────────────────
  void openPrinterSettings() {
    Get.dialog(const PrinterSettingsDialog(), barrierDismissible: true);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRINT RECEIPT
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> printReceipt(CheckoutData data) async {
    // If no printer connected and not mock mode → open settings first
    if (!mockMode && !isConnected) {
      openPrinterSettings();
      _toast('Please connect a printer first');
      return;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    final fmt = NumberFormat('#,##0.00');
    final dtFmt = DateFormat('dd MMM yyyy  hh:mm a');

    //  ── Logo / shop image ──────────────────────────────────────────────────
    if (shopLogoPath != null) {
      final imgBytes = await _loadAssetBytes(shopLogoPath!);
      final decoded = img.decodeImage(imgBytes);
      if (decoded != null) {
        final resized = img.copyResize(decoded, width: 200);
        bytes += generator.imageRaster(
          resized,
          align: PosAlign.center,
          highDensityHorizontal: true,
        );
      }
    }

    // ── Shop header ────────────────────────────────────────────────────────
    bytes += generator.text(
      shopName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      branchName,
      styles: const PosStyles(align: PosAlign.center, bold: false),
    );
    bytes += generator.hr();

    // ── Invoice & date ─────────────────────────────────────────────────────
    final inv = data.invoiceNumber ?? '-';
    bytes += generator.text(
      'Invoice: $inv',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    final firstPay = data.payments.isNotEmpty ? data.payments.first : null;
    final dateStr = firstPay?.paidAt != null
        ? dtFmt.format(DateTime.tryParse(firstPay!.paidAt!) ?? DateTime.now())
        : dtFmt.format(DateTime.now());
    bytes += generator.text(
      dateStr,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr();

    // ── Customer ───────────────────────────────────────────────────────────
    if (data.customer != null) {
      final c = data.customer!;
      bytes += generator.text(
        'Customer: ${c.name ?? ""}${c.phone != null ? " | Ph: ${c.phone}" : ""}${c.email != null ? " | ${c.email}" : ""}',
        styles: const PosStyles(bold: true),
      );
      bytes += generator.hr(ch: '-');
    }

    // ── Items ──────────────────────────────────────────────────────────────
    if (data.items.isNotEmpty) {
      bytes += generator.row([
        PosColumn(text: 'Item', width: 6, styles: const PosStyles(bold: true)),
        PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: 'Price',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]);
      bytes += generator.hr(ch: '-');

      for (final item in data.items) {
        final name = item.productName ?? 'Item';
        final variant = [
          item.size,
          item.color,
        ].where((v) => v != null).join(' / ');
        final qty = item.quantity ?? 0;
        final total = item.lineTotal ?? 0;

        bytes += generator.row([
          PosColumn(text: name, width: 6),
          PosColumn(
            text: '$qty',
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: fmt.format(total),
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        if (variant.isNotEmpty) {
          bytes += generator.text(
            '  $variant',
            styles: const PosStyles(
              fontType: PosFontType.fontB,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
        }
      }
      bytes += generator.hr();
    }

    // ── Return items ───────────────────────────────────────────────────────
    if (data.returnItems.isNotEmpty) {
      bytes += generator.text('Returns', styles: const PosStyles(bold: true));
      bytes += generator.hr(ch: '-');
      for (final ri in data.returnItems) {
        final name = ri.productName ?? 'Return Item';
        final variant = [ri.size, ri.color].where((v) => v != null).join(' / ');
        final credit = (ri.creditPerUnit ?? 0) * (ri.quantity ?? 1);
        bytes += generator.row([
          PosColumn(
            text: '$name${variant.isNotEmpty ? " ($variant)" : ""}',
            width: 8,
          ),
          PosColumn(
            text: '-${fmt.format(credit)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      bytes += generator.hr();
    }

    // ── Totals ─────────────────────────────────────────────────────────────
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
          text: '$prefix${fmt.format(val)}',
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
    totRow(
      'GST (${data.gstPercent?.toStringAsFixed(0) ?? "0"}%)',
      data.gstAmount,
    );
    bytes += generator.hr(ch: '=');
    totRow('TOTAL', data.grandFinalTotal, bold: true);
    bytes += generator.hr(ch: '=');

    // ── Payments ───────────────────────────────────────────────────────────
    if (data.payments.isNotEmpty) {
      bytes += generator.text('Payments', styles: const PosStyles(bold: true));
      for (final pay in data.payments) {
        bytes += generator.row([
          PosColumn(text: pay.paymentMethod ?? '-', width: 7),
          PosColumn(
            text: fmt.format(pay.amount ?? 0),
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

    // ── Vouchers ───────────────────────────────────────────────────────────
    if (data.availableVouchers.isNotEmpty) {
      bytes += generator.text(
        'Vouchers Issued',
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

    // ── Invoice barcode ────────────────────────────────────────────────────
    if (data.invoiceNumber != null) {
      bytes += generator.text(
        'Scan to verify',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.barcode(
        Barcode.code128(data.invoiceNumber!.codeUnits),
        height: 64,
        textPos: BarcodeText.below,
      );
    }

    // ── Footer ─────────────────────────────────────────────────────────────
    bytes += generator.text(
      'Thank you for shopping!',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      shopName,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(2);
    bytes += generator.cut();
    print(bytes);
    print(selectedPrinter);
    // ── Send ───────────────────────────────────────────────────────────────
    if (mockMode) {
      _showMockPreview(data, bytes);
    } else {
      if (Platform.isMacOS) {
        _printViaCups(bytes);
      } else
        await _plugin.printData(selectedPrinter!, bytes, longData: true);
      _toast('Receipt printed ✓');
    }
  }

  String _cupsSafeName(String? name) {
    if (name == null || name.isEmpty) return '';
    return name.trim().replaceAll(RegExp(r'[\s\-]+'), '_');
  }

  Future<void> _printViaCups(List<int> bytes) async {
    final queueName = _cupsSafeName(selectedPrinter!.name);
    if (queueName.isEmpty) throw Exception("No printer name available");

    // Use ApplicationSupport dir — guaranteed to exist in macOS sandbox
    final baseDir = await getApplicationSupportDirectory();
    final printDir = Directory('${baseDir.path}/thermal_prints');
    if (!await printDir.exists()) await printDir.create(recursive: true);

    final file = File(
      '${printDir.path}/thermal_print_${DateTime.now().millisecondsSinceEpoch}.bin',
    );
    await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);

    log("[Printer] Sending ${bytes.length} bytes to CUPS queue: $queueName");

    final result = await Process.run('/usr/bin/lp', [
      '-d',
      queueName,
      '-o',
      'raw',
      file.path,
    ]);

    // Clean up temp file
    try {
      await file.delete();
    } catch (_) {}

    if (result.exitCode != 0) {
      final err = result.stderr.toString().trim();
      log("[Printer] CUPS error: $err");
      throw Exception("CUPS print failed (exit ${result.exitCode}): $err");
    }

    log("[Printer] CUPS accepted job for $queueName");
  }

  // ── Mock preview dialog ─────────────────────────────────────────────────────
  void _showMockPreview(CheckoutData data, List<int> bytes) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mock Print Preview'),
        content: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Text(
              'Invoice: ${data.invoiceNumber ?? "-"}\n'
              'Items: ${data.items.length}\n'
              'Total: ${data.grandFinalTotal ?? 0}\n'
              'Bytes: ${bytes.length} bytes queued\n\n'
              '(Mock mode — no hardware needed)',
              style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
            ),
          ),
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
      ),
    );
  }

  // ── Asset loader ────────────────────────────────────────────────────────────
  Future<Uint8List> _loadAssetBytes(String path) async {
    final data = await DefaultAssetBundle.of(Get.context!).load(path);
    return data.buffer.asUint8List();
  }
}
