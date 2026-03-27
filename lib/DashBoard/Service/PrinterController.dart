import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/DashBoard/Views/Printers/ReceiptPreviewDialog.dart';
import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';


class PrinterController extends GetxController {
  // ── Plugin instance ───────────────────────────────────────────────────────
  final _plugin = FlutterThermalPrinter.instance;

  // ── Observable state ──────────────────────────────────────────────────────
  List<Printer> availableDevices = [];
  Printer? selectedPrinter;
  bool isScanning = false;
  bool isPrinting = false;
  bool mockMode = false; // ← Toggle for receipt preview without hardware
  String? savedDeviceAddress;
  String? savedDeviceName;
  ConnectionType savedConnectionType = ConnectionType.BLE;

  StreamSubscription<List<Printer>>? _scanSub;

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const _kAddress = 'tp_address';
  static const _kName = 'tp_name';
  static const _kConnType = 'tp_conn_type';
  static const _kMock = 'tp_mock_mode';

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _plugin.bleConfig = const BleConfig(
      connectionStabilizationDelay: Duration(seconds: 3),
    );
    _loadSaved();
  }

  @override
  void onClose() {
    _scanSub?.cancel();
    super.onClose();
  }

  // ── Mock mode ─────────────────────────────────────────────────────────────
  Future<void> toggleMockMode() async {
    mockMode = !mockMode;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kMock, mockMode);
    update();
    _snack(mockMode ? "Mock printer enabled" : "Mock printer disabled");
  }

  // ── Persistence ───────────────────────────────────────────────────────────
  Future<void> _loadSaved() async {
    final p = await SharedPreferences.getInstance();
    savedDeviceAddress = p.getString(_kAddress);
    savedDeviceName = p.getString(_kName);
    mockMode = p.getBool(_kMock) ?? false;
    savedConnectionType = p.getString(_kConnType) == 'USB'
        ? ConnectionType.USB
        : ConnectionType.BLE;
    update();
    if (savedDeviceAddress != null) _autoConnect();
  }

  Future<void> persistDevice(Printer printer) async {
    final p = await SharedPreferences.getInstance();
    final addr = _addrOf(printer);
    await p.setString(_kAddress, addr);
    await p.setString(_kName, printer.name ?? '');
    await p.setString(
      _kConnType,
      printer.connectionType == ConnectionType.USB ? 'USB' : 'BLE',
    );
    savedDeviceAddress = addr;
    savedDeviceName = printer.name;
    savedConnectionType = printer.connectionType ?? ConnectionType.BLE;
    update();
  }

  Future<void> clearSavedDevice() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kAddress);
    await p.remove(_kName);
    await p.remove(_kConnType);
    if (selectedPrinter != null) {
      try {
        await _plugin.disconnect(selectedPrinter!);
      } catch (_) {}
    }
    savedDeviceAddress = null;
    savedDeviceName = null;
    selectedPrinter = null;
    update();
    _snack("Printer removed");
  }

  // ── Auto-connect ──────────────────────────────────────────────────────────
  Future<void> _autoConnect() async {
    await startScan(silent: true);
    await Future.delayed(const Duration(seconds: 5));
    final match = availableDevices.firstWhereOrNull(
      (p) => _addrOf(p) == savedDeviceAddress,
    );
    if (match != null) await connectPrinter(match, persist: false);
    await stopScan();
  }

  // ── Scan ──────────────────────────────────────────────────────────────────
  Future<void> startScan({bool silent = false}) async {
    if (!silent) {
      isScanning = true;
      availableDevices = [];
      update();
    }
    _scanSub?.cancel();

    await _plugin.getPrinters(
      connectionTypes: [ConnectionType.BLE, ConnectionType.USB],
    );

    _scanSub = _plugin.devicesStream.listen((devices) {
      availableDevices = devices
          .where((d) => d.name != null && d.name!.isNotEmpty)
          .toList();
      if (!silent) {
        isScanning = false;
        update();
      }
    });
  }

  Future<void> stopScan() async {
    _plugin.stopScan();
    _scanSub?.cancel();
    isScanning = false;
    update();
  }

  // ── Connect / Disconnect ──────────────────────────────────────────────────
  Future<bool> connectPrinter(Printer printer, {bool persist = true}) async {
    try {
      await _plugin.connect(printer);
      selectedPrinter =
          availableDevices.firstWhereOrNull(
            (p) => _addrOf(p) == _addrOf(printer),
          ) ??
          printer;
      selectedPrinter = selectedPrinter!.copyWith(isConnected: true);
      if (persist) await persistDevice(printer);
      update();
      return true;
    } catch (e) {
      log("Printer connect error: $e");
      _snack("Connection failed", isError: true);
      return false;
    }
  }

  Future<void> disconnectPrinter() async {
    if (selectedPrinter != null) {
      try {
        await _plugin.disconnect(selectedPrinter!);
      } catch (_) {}
      selectedPrinter = null;
      update();
    }
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  /// True when a real printer is connected OR mock mode is on
  bool get canPrint => isConnected || mockMode;

  bool get isConnected => selectedPrinter?.isConnected == true;
  bool get hasSavedDevice => savedDeviceAddress != null;
  bool isSaved(Printer p) => _addrOf(p) == savedDeviceAddress;

  String _addrOf(Printer p) {
    if (p.connectionType == ConnectionType.USB) {
      return '${p.vendorId}:${p.productId}';
    }
    return p.address ?? p.name ?? '';
  }

  String connectionLabel(Printer p) {
    switch (p.connectionType) {
      case ConnectionType.USB:
        return 'USB';
      case ConnectionType.BLE:
        return 'BLE';
      case ConnectionType.NETWORK:
        return 'WiFi';
      default:
        return 'BT';
    }
  }

  // ── Print Bill (real + mock) ───────────────────────────────────────────────
  Future<void> printBill({
    required BuildContext context,
    required CartModel bill,
    required String tableName,
    String restaurantName = "GastroPOS",
    String? restaurantAddress,
    String? restaurantPhone,
  }) async {
    // ── MOCK MODE: show on-screen receipt preview ──────────────────────────
    if (mockMode) {
      Get.dialog(
        ReceiptPreviewDialog(
          bill: bill,
          tableName: tableName,
          restaurantName: restaurantName,
          restaurantAddress: restaurantAddress,
          restaurantPhone: restaurantPhone,
        ),
        barrierDismissible: true,
        barrierColor: Colors.black54,
      );
      return;
    }

    // ── REAL MODE: send ESC/POS bytes to printer ───────────────────────────
    if (!isConnected || selectedPrinter == null) {
      _snack("No printer connected", isError: true);
      return;
    }

    isPrinting = true;
    update();

    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      final now = DateTime.now();
      final date =
          "${now.day.toString().padLeft(2, '0')}/"
          "${now.month.toString().padLeft(2, '0')}/"
          "${now.year}";
      final time =
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}";

      List<int> bytes = [];

      // ── Header ────────────────────────────────────────────────
      bytes += generator.text(
        restaurantName.toUpperCase(),
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
      if (restaurantAddress?.isNotEmpty == true) {
        bytes += generator.text(
          restaurantAddress!,
          styles: const PosStyles(align: PosAlign.center),
        );
      }
      if (restaurantPhone?.isNotEmpty == true) {
        bytes += generator.text(
          "Tel: $restaurantPhone",
          styles: const PosStyles(align: PosAlign.center),
        );
      }
      bytes += generator.hr();
      bytes += generator.feed(1);

      // ── Bill meta ─────────────────────────────────────────────
      bytes += generator.row([
        PosColumn(text: "Table:", width: 5),
        PosColumn(
          text: tableName,
          width: 7,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]);
      // if (bill.session?.sessionNumber != null) {
      //   bytes += generator.row([
      //     PosColumn(text: "Bill No:", width: 5),
      //     PosColumn(
      //       text: "#${bill.session!.sessionNumber}",
      //       width: 7,
      //       styles: const PosStyles(bold: true, align: PosAlign.right),
      //     ),
      //   ]);
      // }
      // if (bill.session?.customerName?.isNotEmpty == true) {
      //   bytes += generator.row([
      //     PosColumn(text: "Customer:", width: 5),
      //     PosColumn(
      //       text: bill.session!.customerName!,
      //       width: 7,
      //       styles: const PosStyles(align: PosAlign.right),
      //     ),
      //   ]);
      // }
      // if (bill.session?.customerPhone?.isNotEmpty == true) {
      //   bytes += generator.row([
      //     PosColumn(text: "Phone:", width: 5),
      //     PosColumn(
      //       text: bill.session!.customerPhone!,
      //       width: 7,
      //       styles: const PosStyles(align: PosAlign.right),
      //     ),
      //   ]);
      // }
      bytes += generator.row([
        PosColumn(text: "Date:", width: 5),
        PosColumn(
          text: "$date  $time",
          width: 7,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.feed(1);
      bytes += generator.hr();

      // ── Items header ──────────────────────────────────────────
      bytes += generator.row([
        PosColumn(
          text: "ITEM",
          width: 7,
          styles: const PosStyles(bold: true, underline: true),
        ),
        PosColumn(
          text: "QTY",
          width: 2,
          styles: const PosStyles(
            bold: true,
            underline: true,
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "AMOUNT",
          width: 3,
          styles: const PosStyles(
            bold: true,
            underline: true,
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += generator.hr();

      // ── Items ─────────────────────────────────────────────────
      for (final item in (bill.items ?? [])) {
        final name = item.name ?? item.menuItem?.name ?? "Item";
        final displayName = name.length > 22
            ? "${name.substring(0, 21)}…"
            : name;
        bytes += generator.row([
          PosColumn(text: displayName, width: 7),
          PosColumn(
            text: "${item.quantity ?? 1}",
            width: 2,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: "\$${item.totalPrice ?? '0.00'}",
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      bytes += generator.hr();
      bytes += generator.feed(1);

      // ── Totals ────────────────────────────────────────────────
      bytes += generator.row([
        PosColumn(text: "Subtotal", width: 7),
        PosColumn(
          text: "\$${bill.subtotal ?? '0.00'}",
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(text: "Tax (${bill.gstPercent ?? 0}%)", width: 7),
        PosColumn(
          text: "\$${bill.gstAmount ?? '0.00'}",
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      if (bill.couponDiscountAmount!= null &&
          bill.couponDiscountAmount != "0" &&
          bill.couponDiscountAmount != "0.00") {
        bytes += generator.row([
          PosColumn(text: "Discount", width: 7),
          PosColumn(
            text: "-\$${bill.couponDiscountAmount}",
            width: 5,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      if (bill.coupon != null) {
        bytes += generator.row([
          PosColumn(text: "Coupon (${bill.coupon!.code ?? ''})", width: 7),
          PosColumn(
            text: "-\$${bill.coupon!.discountValue ?? '0.00'}",
            width: 5,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      // if (bill.loyalty?.totalPoints != null &&
      //     bill.loyalty!.totalPoints != "0") {
      //   bytes += generator.row([
      //     PosColumn(text: "Loyalty Pts", width: 7),
      //     PosColumn(
      //       text: "${bill.loyalty!.totalPoints} pts",
      //       width: 5,
      //       styles: const PosStyles(align: PosAlign.right),
      //     ),
      //   ]);
      // }
      bytes += generator.hr(ch: '=');
      bytes += generator.row([
        PosColumn(
          text: "TOTAL",
          width: 6,
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: "\$${bill.grandFinalTotal ?? '0.00'}",
          width: 6,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ),
        ),
      ]);
      bytes += generator.hr(ch: '=');
      bytes += generator.feed(1);

      // ── Footer ────────────────────────────────────────────────
      bytes += generator.text(
        "Thank you for dining with us!",
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.text(
        "Please come again",
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator.feed(3);
      bytes += generator.cut();

      await _plugin.printData(selectedPrinter!, bytes, longData: true);
      _snack("Bill printed successfully");
    } catch (e) {
      log("Print error: $e");
      _snack("Print failed: ${e.toString()}", isError: true);
    }

    isPrinting = false;
    update();
  }

  // ── Snackbar ──────────────────────────────────────────────────────────────
  void _snack(String msg, {bool isError = false}) {}
}
