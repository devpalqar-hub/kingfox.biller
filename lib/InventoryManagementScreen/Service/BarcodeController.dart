import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/InventoryManagementScreen/Service/BarCodeDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' hide Printer;
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants / Keys
// ─────────────────────────────────────────────────────────────────────────────
const _kBarcodePrinterMode = 'bp_mode'; // "thermal" | "a4"
const _kBarcodeThermalDevice = 'bp_thermal_addr';
const _kBarcodeThermalName = 'bp_thermal_name';
const _kBarcodeThermalConnType = 'bp_thermal_conn'; // "BLE"|"USB"
const _kBarcodeSizeIndex = 'bp_size_index';
const _kBarcodeRemainingPrefix = 'bp_rem_'; // + sheetKey

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Value Objects
// ─────────────────────────────────────────────────────────────────────────────

/// Which output mode the user has selected.
enum BarcodePrintMode { thermal, a4 }

/// A standard label size (width × height in mm, labels per A4 sheet).
class BarcodeLabelSize {
  final String name;
  final double widthMm;
  final double heightMm;
  final int? labelsPerA4Sheet; // null for thermal (roll, no sheet concept)
  final int? labelsPerThermalRow;

  const BarcodeLabelSize({
    required this.name,
    required this.widthMm,
    required this.heightMm,
    this.labelsPerA4Sheet,
    this.labelsPerThermalRow,
  });
}

/// Pre-defined standard label sizes.
const List<BarcodeLabelSize> kLabelSizes = [
  BarcodeLabelSize(
    name: '40 × 24 mm  (48/sheet)',
    widthMm: 40,
    heightMm: 24,
    labelsPerA4Sheet: 48,
    labelsPerThermalRow: 1,
  ),
  BarcodeLabelSize(
    name: '52 × 26 mm  (30/sheet)',
    widthMm: 52,
    heightMm: 26,
    labelsPerA4Sheet: 30,
    labelsPerThermalRow: 1,
  ),
  BarcodeLabelSize(
    name: '63 × 38 mm  (21/sheet)',
    widthMm: 63,
    heightMm: 38,
    labelsPerA4Sheet: 21,
    labelsPerThermalRow: 1,
  ),
  BarcodeLabelSize(
    name: '70 × 37 mm  (24/sheet)',
    widthMm: 70,
    heightMm: 37,
    labelsPerA4Sheet: 24,
    labelsPerThermalRow: 1,
  ),
  BarcodeLabelSize(
    name: '99 × 57 mm  (10/sheet)',
    widthMm: 99,
    heightMm: 57,
    labelsPerA4Sheet: 10,
    labelsPerThermalRow: 1,
  ),
];

/// Encapsulates a single barcode print job request.
class BarcodePrintJob {
  final String barcodeValue;
  final String productName;
  final String? variantName;
  final double? price;
  final int count;

  const BarcodePrintJob({
    required this.barcodeValue,
    required this.productName,
    this.variantName,
    this.price,
    required this.count,
  });

  /// A stable key used to persist "remaining" state per barcode+variant.
  String get sheetKey => '${barcodeValue}_${variantName ?? "default"}'
      .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
}

/// Remaining-label slot state for a single A4 sheet session.
class SheetSession {
  final String key;
  int used;
  int total;

  SheetSession({required this.key, required this.used, required this.total});

  int get remaining => total - used;
  bool get hasSpace => remaining > 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// BarcodePrinterController
// ─────────────────────────────────────────────────────────────────────────────
class BarcodePrinterController extends GetxController {
  // ── Persistent state ──────────────────────────────────────────────────────
  BarcodePrintMode printMode = BarcodePrintMode.thermal;
  int selectedSizeIndex = 0;
  BarcodeLabelSize get selectedSize => kLabelSizes[selectedSizeIndex];

  // ── Thermal printer state ─────────────────────────────────────────────────
  bool isScanning = false;
  bool isConnected = false;
  Printer? selectedPrinter;
  List<Printer> availableDevices = [];
  StreamSubscription<List<Printer>>? _scanSubscription;

  String? savedThermalName;
  String? savedThermalAddress;
  ConnectionType? savedThermalConnType;
  bool get hasSavedThermal => savedThermalAddress != null;

  // ── Sheet session state (per sheetKey) ───────────────────────────────────
  /// Loaded lazily; key = sheetKey, value = SheetSession.
  final Map<String, SheetSession> _sessions = {};

  final _plugin = FlutterThermalPrinter.instance;

  // ── Init ──────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadPrefs().then((_) => _autoConnect());
  }

  // ── Prefs ─────────────────────────────────────────────────────────────────
  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    printMode = (p.getString(_kBarcodePrinterMode) ?? 'thermal') == 'thermal'
        ? BarcodePrintMode.thermal
        : BarcodePrintMode.a4;
    selectedSizeIndex = p.getInt(_kBarcodeSizeIndex) ?? 0;
    savedThermalName = p.getString(_kBarcodeThermalName);
    savedThermalAddress = p.getString(_kBarcodeThermalDevice);
    final ct = p.getString(_kBarcodeThermalConnType);
    savedThermalConnType = ct == 'USB'
        ? ConnectionType.USB
        : ConnectionType.BLE;
    update();
  }

  Future<void> _saveModePref() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      _kBarcodePrinterMode,
      printMode == BarcodePrintMode.thermal ? 'thermal' : 'a4',
    );
    await p.setInt(_kBarcodeSizeIndex, selectedSizeIndex);
    update();
  }

  Future<void> _saveThermalPref(Printer printer) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kBarcodeThermalDevice, printer.address ?? '');
    await p.setString(_kBarcodeThermalName, printer.name ?? '');
    await p.setString(
      _kBarcodeThermalConnType,
      printer.connectionType == ConnectionType.USB ? 'USB' : 'BLE',
    );
    savedThermalAddress = printer.address;
    savedThermalName = printer.name;
    savedThermalConnType = printer.connectionType;
    update();
  }

  Future<void> clearThermalPref() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kBarcodeThermalDevice);
    await p.remove(_kBarcodeThermalName);
    await p.remove(_kBarcodeThermalConnType);
    savedThermalAddress = null;
    savedThermalName = null;
    savedThermalConnType = null;
    update();
  }

  // ── Mode / size setters ───────────────────────────────────────────────────
  Future<void> setPrintMode(BarcodePrintMode mode) async {
    printMode = mode;
    await _saveModePref();
  }

  Future<void> setSizeIndex(int idx) async {
    selectedSizeIndex = idx;
    await _saveModePref();
  }

  // ── Scan ──────────────────────────────────────────────────────────────────
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

  // ── Connect / disconnect ──────────────────────────────────────────────────
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

  Future<void> persistThermalDevice(Printer printer) async {
    await _saveThermalPref(printer);
    _toast('${printer.name ?? "Printer"} set as default');
  }

  bool isSaved(Printer printer) =>
      printer.address != null && printer.address == savedThermalAddress;

  String connectionLabel(Printer p) =>
      p.connectionType == ConnectionType.USB ? 'USB' : 'BLE';

  // ── Auto-connect ──────────────────────────────────────────────────────────
  Future<void> _autoConnect() async {
    if (savedThermalAddress == null || printMode == BarcodePrintMode.a4) return;
    await startScan(autoConnectAddress: savedThermalAddress);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Sheet session management
  // ─────────────────────────────────────────────────────────────────────────

  Future<SheetSession> _getSession(String key) async {
    if (_sessions.containsKey(key)) return _sessions[key]!;
    final p = await SharedPreferences.getInstance();
    final used = p.getInt('$_kBarcodeRemainingPrefix${key}_used') ?? 0;
    final total = selectedSize.labelsPerA4Sheet ?? 48;
    final session = SheetSession(key: key, used: used, total: total);
    _sessions[key] = session;
    return session;
  }

  Future<void> _saveSession(SheetSession session) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(
      '$_kBarcodeRemainingPrefix${session.key}_used',
      session.used,
    );
    update();
  }

  /// Override remaining count manually (called from UI).
  Future<void> overrideRemaining(String key, int remaining) async {
    final total = selectedSize.labelsPerA4Sheet ?? 48;
    final session = await _getSession(key);
    session.used = (total - remaining).clamp(0, total);
    await _saveSession(session);
    _toast('Remaining updated to $remaining');
  }

  Future<void> resetSession(String key) async {
    final session = await _getSession(key);
    session.used = 0;
    await _saveSession(session);
    _toast('Sheet session reset');
  }

  /// Read-only snapshot for UI. Returns null until a session is created/loaded.
  SheetSession? getSessionSnapshot(String key) => _sessions[key];

  // ─────────────────────────────────────────────────────────────────────────
  // ENTRY POINT — called from outside
  // ─────────────────────────────────────────────────────────────────────────
  void openBarcodePrinter(BarcodePrintJob job) {
    Get.dialog(BarcodePrinterDialog(job: job), barrierDismissible: true);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRINT — A4 mode
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> printA4(BarcodePrintJob job) async {
    try {
      final size = selectedSize;
      final total = size.labelsPerA4Sheet ?? 48;
      final session = await _getSession(job.sheetKey);

      // Split job into pages intelligently
      int remaining = job.count;
      final pages = <_PageSpec>[];

      // Fill remainder of current sheet if it has space
      if (session.hasSpace && session.used > 0) {
        final canFit = session.remaining.clamp(0, remaining);
        pages.add(
          _PageSpec(startSlot: session.used, count: canFit, totalSlots: total),
        );
        remaining -= canFit;
        session.used += canFit;
      }

      // Fill full sheets for the rest
      while (remaining > 0) {
        final canFit = remaining.clamp(0, total);
        pages.add(_PageSpec(startSlot: 0, count: canFit, totalSlots: total));
        remaining -= canFit;
        // Last page: track used slots
        if (remaining == 0) session.used = canFit % total;
      }

      await _saveSession(session);

      // Build PDF
      final pdf = pw.Document();
      // Use built-in fonts to avoid network-dependent font loading.
      final font = pw.Font.helvetica();
      final fontBold = pw.Font.helveticaBold();

      final labelW = size.widthMm * PdfPageFormat.mm;
      final labelH = size.heightMm * PdfPageFormat.mm;
      final cols = (PdfPageFormat.a4.availableWidth / labelW).floor();
      final rows = (PdfPageFormat.a4.availableHeight / labelH).floor();

      for (final page in pages) {
        final slots = List<int?>.filled(page.totalSlots, null);
        for (int i = 0; i < page.count; i++) {
          slots[page.startSlot + i] = i;
        }

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(8 * PdfPageFormat.mm),
            build: (_) => pw.GridView(
              crossAxisCount: cols,
              childAspectRatio: labelW / labelH,
              children: slots.sublist(0, cols * rows).map((slot) {
                if (slot == null) return pw.SizedBox();
                return _buildPdfLabel(
                  job: job,
                  font: font,
                  fontBold: fontBold,
                  w: labelW,
                  h: labelH,
                );
              }).toList(),
            ),
          ),
        );
      }

      await Printing.layoutPdf(
        onLayout: (_) async => pdf.save(),
        name: 'Barcode_${job.barcodeValue}',
      );

      _toast(
        'Sent to printer — ${job.count} labels across ${pages.length} page(s)',
      );
    } catch (e) {
      _toast('Print error: $e');
      debugPrint('BarcodePrinterController A4 error: $e');
    }
  }

  pw.Widget _buildPdfLabel({
    required BarcodePrintJob job,
    required pw.Font font,
    required pw.Font fontBold,
    required double w,
    required double h,
  }) {
    return pw.Container(
      width: w,
      height: h,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            job.productName,
            style: pw.TextStyle(font: fontBold, fontSize: 5.5),
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
          ),
          if (job.variantName != null)
            pw.Text(
              job.variantName!,
              style: pw.TextStyle(font: font, fontSize: 4.5),
              maxLines: 1,
            ),
          pw.BarcodeWidget(
            barcode: pw.Barcode.code128(),
            data: job.barcodeValue,
            width: w * 0.88,
            height: h * 0.38,
            drawText: false,
          ),
          pw.Text(
            job.barcodeValue,
            style: pw.TextStyle(font: font, fontSize: 4),
          ),
          if (job.price != null)
            pw.Text(
              '${job.price!.toStringAsFixed(2)}',
              style: pw.TextStyle(font: fontBold, fontSize: 5.5),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRINT — Thermal mode
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> printThermal(BarcodePrintJob job) async {
    if (!isConnected) {
      _toast('Please connect a thermal printer first');
      return;
    }
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      for (int i = 0; i < job.count; i++) {
        List<int> bytes = [];

        bytes += generator.text(
          job.productName,
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );

        if (job.variantName != null) {
          bytes += generator.text(
            job.variantName!,
            styles: const PosStyles(align: PosAlign.center),
          );
        }

        bytes += generator.barcode(
          Barcode.code128(job.barcodeValue.characters.toList()),
          height: 48,
          textPos: BarcodeText.below,
        );

        if (job.price != null) {
          bytes += generator.text(
            '${job.price!.toStringAsFixed(2)}',
            styles: const PosStyles(align: PosAlign.center, bold: true),
          );
        }

        bytes += generator.feed(1);
        bytes += generator.cut(mode: PosCutMode.partial);

        if (Platform.isMacOS) {
          _printViaCups(bytes);
        } else
          await _plugin.printData(selectedPrinter!, bytes, longData: true);
      }

      _toast('Printed ${job.count} barcode label(s) ✓');
    } catch (e) {
      _toast('Thermal print error: $e');
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

  // ─────────────────────────────────────────────────────────────────────────
  // Master print dispatcher
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> print(BarcodePrintJob job) async {
    if (printMode == BarcodePrintMode.a4) {
      await printA4(job);
    } else {
      await printThermal(job);
    }
  }

  void _toast(String msg) {
    log(msg);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal page-layout spec
// ─────────────────────────────────────────────────────────────────────────────
class _PageSpec {
  final int startSlot;
  final int count;
  final int totalSlots;
  const _PageSpec({
    required this.startSlot,
    required this.count,
    required this.totalSlots,
  });
}
