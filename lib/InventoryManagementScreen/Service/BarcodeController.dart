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
import 'package:pdf/widgets.dart' show PdfGoogleFonts;
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants / Keys
// ─────────────────────────────────────────────────────────────────────────────
const _kBarcodePrinterMode = 'bp_mode';
const _kBarcodeThermalDevice = 'bp_thermal_addr';
const _kBarcodeThermalName = 'bp_thermal_name';
const _kBarcodeThermalConnType = 'bp_thermal_conn';
const _kBarcodeSizeIndex = 'bp_size_index';
const _kBarcodeRemainingPrefix = 'bp_rem_';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Value Objects
// ─────────────────────────────────────────────────────────────────────────────
enum BarcodePrintMode { thermal, a4 }

class BarcodeLabelSize {
  final String name;
  final double widthMm;
  final double heightMm;
  final int cols;
  final int rows;
  final double hMarginMm;
  final double hMarginEndMm;
  final double vMarginMm;
  final double vMarginEndMm;
  final double hGapMm;
  final double vGapMm;

  const BarcodeLabelSize({
    required this.name,
    required this.widthMm,
    required this.heightMm,
    required this.cols,
    required this.rows,
    required this.hMarginMm,
    double? hMarginEndMm,
    required this.vMarginMm,
    double? vMarginEndMm,
    required this.hGapMm,
    required this.vGapMm,
  }) : hMarginEndMm = hMarginEndMm ?? hMarginMm,
       vMarginEndMm = vMarginEndMm ?? vMarginMm;

  int get labelsPerA4Sheet => cols * rows;
}

// ─────────────────────────────────────────────────────────────────────────────
// Label size catalogue
// ─────────────────────────────────────────────────────────────────────────────
const List<BarcodeLabelSize> kLabelSizes = [
  // ── 48-label  48 × 24 mm  (4 × 12) ─────────────────────────────────────
  // W : 4×48 + 3×2 + 2.5 + 2.5 = 203 mm ✓
  // H : 12×24 + 11×0 + 5 + 3   = 296 mm ✓
  BarcodeLabelSize(
    name: '48-label  48×24 mm  (4×12)  ★',
    widthMm: 48.0,
    heightMm: 24.0,
    cols: 4,
    rows: 12,
    hMarginMm: 2.5,
    hMarginEndMm: 2.5,
    vMarginMm: 5.0,
    vMarginEndMm: 3.0,
    hGapMm: 2.0,
    vGapMm: 0.0,
  ),
  // ── 72-label  48 × 14.9 mm  (4 × 18) ────────────────────────────────────
  BarcodeLabelSize(
    name: '72-label  48×14.9 mm  (4×18)',
    widthMm: 48.0,
    heightMm: 14.9,
    cols: 4,
    rows: 18,
    hMarginMm: 5.0,
    vMarginMm: 13.0,
    vMarginEndMm: 10.0,
    hGapMm: 2.0,
    vGapMm: 0.0,
  ),
  // ── 65-label  38 × 21.2 mm  (5 × 13) ────────────────────────────────────
  BarcodeLabelSize(
    name: '65-label  38×21.2 mm  (5×13)',
    widthMm: 38.0,
    heightMm: 21.2,
    cols: 5,
    rows: 13,
    hMarginMm: 4.0,
    vMarginMm: 9.0,
    hGapMm: 2.0,
    vGapMm: 0.0,
  ),
  // ── 24-label  63 × 33 mm  (3 × 8) ───────────────────────────────────────
  BarcodeLabelSize(
    name: '24-label  63×33 mm  (3×8)',
    widthMm: 63.0,
    heightMm: 33.0,
    cols: 3,
    rows: 8,
    hMarginMm: 7.0,
    vMarginMm: 11.0,
    hGapMm: 3.0,
    vGapMm: 1.0,
  ),
  // ── 10-label  99 × 55 mm  (2 × 5) ───────────────────────────────────────
  BarcodeLabelSize(
    name: '10-label  99×55 mm  (2×5)',
    widthMm: 99.0,
    heightMm: 55.0,
    cols: 2,
    rows: 5,
    hMarginMm: 4.5,
    vMarginMm: 8.5,
    hGapMm: 3.0,
    vGapMm: 0.0,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
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

  String sheetKey(int sizeIndex) =>
      '${barcodeValue}_${variantName ?? "default"}_s$sizeIndex'.replaceAll(
        RegExp(r'[^a-zA-Z0-9_]'),
        '_',
      );
}

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
  BarcodePrintMode printMode = BarcodePrintMode.thermal;
  int selectedSizeIndex = 0;
  BarcodeLabelSize get selectedSize => kLabelSizes[selectedSizeIndex];

  bool isScanning = false;
  bool isConnected = false;
  Printer? selectedPrinter;
  List<Printer> availableDevices = [];
  StreamSubscription<List<Printer>>? _scanSubscription;
  bool _isConnecting = false;

  String? savedThermalName;
  String? savedThermalAddress;
  ConnectionType? savedThermalConnType;
  bool get hasSavedThermal => savedThermalAddress != null;

  final Map<String, SheetSession> _sessions = {};
  final _plugin = FlutterThermalPrinter.instance;

  bool isDeviceConnected(Printer printer) {
    if (!isConnected || selectedPrinter == null) return false;
    final s = selectedPrinter!;
    if ((s.address ?? '').isNotEmpty && (printer.address ?? '').isNotEmpty) {
      return s.address == printer.address;
    }
    return s.name == printer.name && s.connectionType == printer.connectionType;
  }

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
    savedThermalAddress = savedThermalName = null;
    savedThermalConnType = null;
    update();
  }

  Future<void> setPrintMode(BarcodePrintMode mode) async {
    printMode = mode;
    await _saveModePref();
  }

  Future<void> setSizeIndex(int idx) async {
    selectedSizeIndex = idx;
    _sessions.clear();
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
        if (selectedPrinter != null) {
          final s = selectedPrinter!;
          for (final d in printers) {
            if (((s.address ?? '').isNotEmpty &&
                    (d.address ?? '').isNotEmpty &&
                    s.address == d.address) ||
                (s.name == d.name && s.connectionType == d.connectionType)) {
              selectedPrinter = d;
              break;
            }
          }
        }
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
    if (_isConnecting) return;
    if (isDeviceConnected(printer)) {
      selectedPrinter = printer;
      isConnected = true;
      update();
      return;
    }
    _isConnecting = true;
    try {
      await _plugin.connect(printer);
      selectedPrinter = printer;
      isConnected = true;
      update();
      _toast('Connected to ${printer.name ?? "printer"}');
    } catch (e) {
      _toast('Connection failed: $e');
    } finally {
      _isConnecting = false;
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

  bool isSaved(Printer p) =>
      p.address != null && p.address == savedThermalAddress;
  String connectionLabel(Printer p) =>
      p.connectionType == ConnectionType.USB ? 'USB' : 'BLE';

  Future<void> _autoConnect() async {
    if (savedThermalAddress == null || printMode == BarcodePrintMode.a4) return;
    await startScan(autoConnectAddress: savedThermalAddress);
  }

  // ── Sheet sessions ────────────────────────────────────────────────────────
  Future<SheetSession> _getSession(String key) async {
    if (_sessions.containsKey(key)) return _sessions[key]!;
    final p = await SharedPreferences.getInstance();
    final used = p.getInt('${_kBarcodeRemainingPrefix}${key}_used') ?? 0;
    final total = selectedSize.labelsPerA4Sheet;
    final s = SheetSession(key: key, used: used.clamp(0, total), total: total);
    _sessions[key] = s;
    return s;
  }

  Future<void> _saveSession(SheetSession session) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(
      '${_kBarcodeRemainingPrefix}${session.key}_used',
      session.used,
    );
    update();
  }

  Future<void> overrideRemaining(String key, int remaining) async {
    final total = selectedSize.labelsPerA4Sheet;
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

  SheetSession? getSessionSnapshot(String key) => _sessions[key];

  void openBarcodePrinter(BarcodePrintJob job) =>
      Get.dialog(BarcodePrinterDialog(job: job), barrierDismissible: true);

  // ─────────────────────────────────────────────────────────────────────────
  // PRINT — A4 mode
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> printA4(BarcodePrintJob job) async {
    try {
      final size = selectedSize;
      final total = size.labelsPerA4Sheet;
      final key = job.sheetKey(selectedSizeIndex);
      final session = await _getSession(key);

      // ── Page planning ────────────────────────────────────────────────────
      int remaining = job.count;
      final pages = <_PageSpec>[];

      if (session.hasSpace && session.used > 0) {
        final canFit = session.remaining.clamp(0, remaining);
        pages.add(
          _PageSpec(startSlot: session.used, count: canFit, totalSlots: total),
        );
        remaining -= canFit;
        session.used += canFit;
        if (session.used >= total) session.used = 0;
      }
      while (remaining > 0) {
        final canFit = remaining.clamp(0, total);
        pages.add(_PageSpec(startSlot: 0, count: canFit, totalSlots: total));
        remaining -= canFit;
        session.used = (canFit < total) ? canFit : 0;
      }
      await _saveSession(session);

      // ── Fonts ────────────────────────────────────────────────────────────
      final font = await PdfGoogleFonts.notoSansRegular();
      final fontBold = await PdfGoogleFonts.notoSansBold();

      // ── Convert mm → pt ──────────────────────────────────────────────────
      // 1 mm = PdfPageFormat.mm pt  (≈ 2.8346 pt)
      final labelW = size.widthMm * PdfPageFormat.mm;
      final labelH = size.heightMm * PdfPageFormat.mm;
      final hMarginPt = size.hMarginMm * PdfPageFormat.mm;
      final hGapPt = size.hGapMm * PdfPageFormat.mm;
      final vMarginPt = size.vMarginMm * PdfPageFormat.mm;
      final vGapPt = size.vGapMm * PdfPageFormat.mm;

      // ── Build PDF ────────────────────────────────────────────────────────
      final pdf = pw.Document();

      for (final page in pages) {
        // Which slots are filled on this page?
        final slotCount = size.cols * size.rows;
        final slots = List<bool>.filled(slotCount, false);
        for (int i = 0; i < page.count; i++) {
          final idx = page.startSlot + i;
          if (idx >= slotCount) break;
          slots[idx] = true;
        }

        pdf.addPage(
          pw.Page(
            // ── Explicitly zero ALL margins via PdfPageFormat ─────────────
            // pw.Page.margin only controls the pw layout engine margin;
            // PdfPageFormat itself also carries margin values that become
            // the effective page clip region.  Set both to zero so
            // availableWidth == pageWidth and availableHeight == pageHeight.
            pageTheme: pw.PageTheme(
              margin: pw.EdgeInsets.zero,
              pageFormat: PdfPageFormat(
                210 * PdfPageFormat.mm, // width  = 210 mm
                297 * PdfPageFormat.mm, // height = 297 mm
                marginAll: 0, // ← zero format-level margin
              ),
            ),
            build: (_) {
              // ── Outer padding = sheet margins ────────────────────────────
              return pw.Padding(
                padding: pw.EdgeInsets.only(
                  left: hMarginPt,
                  right: size.hMarginEndMm * PdfPageFormat.mm,
                  top: vMarginPt,
                  bottom: size.vMarginEndMm * PdfPageFormat.mm,
                ),
                // ── FIX: use min + start instead of max + spaceBetween ────
                // mainAxisSize.max + spaceBetween caused the Column to
                // stretch to full page height, ballooning the inter-row
                // spacing and creating a large blank gap at the bottom.
                // With mainAxisSize.min the Column is exactly as tall as
                // its content; explicit SizedBox gaps replace spaceBetween.
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: List.generate(size.rows, (row) {
                    return pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Row(
                          mainAxisSize: pw.MainAxisSize.max,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: List.generate(size.cols, (col) {
                            final idx = row * size.cols + col;
                            final filled = idx < slotCount && slots[idx];
                            return pw.SizedBox(
                              width: labelW,
                              height: labelH,
                              child: filled
                                  ? _buildPdfLabel(
                                      job: job,
                                      font: font,
                                      fontBold: fontBold,
                                      w: labelW,
                                      h: labelH,
                                    )
                                  : pw.SizedBox(width: labelW, height: labelH),
                            );
                          }),
                        ),
                        // Inter-row gap — skipped after last row and when
                        // vGapMm is 0 (e.g. the 48-label sheet).
                        if (row < size.rows - 1 && vGapPt > 0)
                          pw.SizedBox(height: vGapPt),
                      ],
                    );
                  }),
                ),
              );
            },
          ),
        );
      }

      final pdfBytes = await pdf.save();

      if (Platform.isMacOS) {
        await _openPdfOnMac(pdfBytes, 'Barcode_${job.barcodeValue}');
      } else {
        await Printing.layoutPdf(
          onLayout: (_) async => pdfBytes,
          name: 'Barcode_${job.barcodeValue}',
        );
      }

      _toast(
        'Sent to printer — ${job.count} labels across ${pages.length} page(s)',
      );
    } catch (e) {
      _toast('Print error: $e');
      debugPrint('BarcodePrinterController A4 error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // _buildPdfLabel — ONE label cell, tuned for 48 × 24 mm
  //
  // Layout (top→bottom, spaceEvenly):
  //   1. Product name   bold   7.0 pt
  //   2. Variant name   reg    5.8 pt  (optional)
  //   3. Barcode image         24 pt height ≈ 8.5 mm
  //   4. Barcode digits mono   5.2 pt
  //   5. Price          bold   7.0 pt  (optional)
  // ─────────────────────────────────────────────────────────────────────────
  pw.Widget _buildPdfLabel({
    required BarcodePrintJob job,
    required pw.Font font,
    required pw.Font fontBold,
    required double w,
    required double h,
  }) {
    const padPt = 0.8 * PdfPageFormat.mm;
    final innerW = w - padPt * 2;

    final hasVariant = job.variantName != null && job.variantName!.isNotEmpty;
    final hasPrice = job.price != null;

    const fsName = 7.0;
    const fsVariant = 5.8;
    const fsDigits = 5.2;
    const fsPrice = 7.0;

    // Barcode height scales with label height so it works for all sizes too.
    // For 24 mm labels → ≈ 8.5 mm; clamped so it never overflows.
    final barcodeH = (h * 0.38).clamp(14.0, 30.0);
    final barcodeW = innerW * 0.90;

    return pw.Container(
      width: w,
      height: h,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.3),
      ),
      padding: const pw.EdgeInsets.all(padPt),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.max,
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // 1. Product name
          pw.SizedBox(
            width: innerW,
            child: pw.Text(
              job.productName,
              style: pw.TextStyle(font: fontBold, fontSize: fsName),
              maxLines: 1,
              overflow: pw.TextOverflow.clip,
              textAlign: pw.TextAlign.center,
            ),
          ),

          // 2. Variant (optional)
          if (hasVariant)
            pw.SizedBox(
              width: innerW,
              child: pw.Text(
                job.variantName!,
                style: pw.TextStyle(font: font, fontSize: fsVariant),
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                textAlign: pw.TextAlign.center,
              ),
            ),

          // 3. Barcode image
          pw.SizedBox(
            width: barcodeW,
            height: barcodeH,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.code128(),
              data: job.barcodeValue,
              width: barcodeW,
              height: barcodeH,
              drawText: false,
            ),
          ),

          // 4. Barcode HRI digits
          pw.Text(
            job.barcodeValue,
            style: pw.TextStyle(
              font: font,
              fontSize: fsDigits,
              letterSpacing: 0.5,
            ),
            textAlign: pw.TextAlign.center,
          ),

          // 5. Price
          if (hasPrice)
            pw.Text(
              'Rs.\u00A0${job.price!.toStringAsFixed(2)}',
              style: pw.TextStyle(font: fontBold, fontSize: fsPrice),
              textAlign: pw.TextAlign.center,
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
      final paperSize = selectedSize.widthMm <= 58
          ? PaperSize.mm58
          : PaperSize.mm80;
      final generator = Generator(paperSize, profile);
      const dotsPerMm = 8;

      final barcodeHeightDots = ((selectedSize.heightMm * 0.40) * dotsPerMm)
          .round()
          .clamp(24, 80);
      final barcodeData = job.barcodeValue.trim();
      int barcodeWidth = 2;
      if (barcodeData.isNotEmpty) {
        final printableWidthDots = (selectedSize.widthMm - 8) * dotsPerMm;
        final modulesNeeded = 11 * barcodeData.length;
        barcodeWidth = (printableWidthDots / modulesNeeded).floor().clamp(1, 3);
      }

      for (int i = 0; i < job.count; i++) {
        List<int> bytes = [];
        bytes += generator.reset();
        bytes += generator.setStyles(const PosStyles(align: PosAlign.center));

        // Product name
        bytes += generator.text(
          _truncateForThermal(job.productName, paperSize),
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );

        // Variant
        if (job.variantName != null && job.variantName!.isNotEmpty) {
          bytes += generator.text(
            _truncateForThermal(job.variantName!, paperSize),
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
        }

        // Price
        if (job.price != null) {
          bytes += generator.text(
            'Rs. ${job.price!.toStringAsFixed(2)}',
            styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
        }

        // Barcode
        if (barcodeData.isNotEmpty) {
          bytes += generator.setStyles(const PosStyles(align: PosAlign.center));
          bytes += generator.barcode(
            Barcode.code128(barcodeData.codeUnits),
            height: barcodeHeightDots,
            width: barcodeWidth,
            textPos: BarcodeText.below,
          );
        }

        bytes += generator.reset();
        bytes += generator.feed(1);
        bytes += generator.cut(mode: PosCutMode.partial);

        if (Platform.isMacOS) {
          await _printViaCups(bytes);
        } else {
          await _plugin.printData(selectedPrinter!, bytes, longData: true);
        }
      }
      _toast('Printed ${job.count} barcode label(s) ✓');
    } catch (e) {
      _toast('Thermal print error: $e');
      debugPrint('BarcodePrinterController thermal error: $e');
    }
  }

  String _truncateForThermal(String text, PaperSize paperSize) {
    final maxChars = paperSize == PaperSize.mm58 ? 32 : 48;
    final chars = text.characters;
    return chars.length > maxChars ? chars.take(maxChars).string : text;
  }

  // ── macOS CUPS ────────────────────────────────────────────────────────────
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
      '${printDir.path}/thermal_${DateTime.now().millisecondsSinceEpoch}.bin',
    );
    await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);
    log('[Printer] Sending ${bytes.length} bytes → CUPS queue: $queueName');
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

  // ── macOS A4 ──────────────────────────────────────────────────────────────
  Future<void> _openPdfOnMac(Uint8List pdfBytes, String name) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${docsDir.path}/barcode_pdfs');
    if (!await pdfDir.exists()) await pdfDir.create(recursive: true);
    final safeName = name.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final file = File('${pdfDir.path}/$safeName.pdf');
    await file.writeAsBytes(pdfBytes, flush: true);
    log('[Printer] PDF saved to ${file.path}');
    final result = await Process.run('/usr/bin/open', [file.path]);
    if (result.exitCode != 0) {
      final err = result.stderr.toString().trim();
      log('[Printer] open error: $err');
      throw Exception('Could not open PDF on macOS: $err');
    }
    log('[Printer] PDF opened in system viewer: ${file.path}');
  }

  // ── Dispatcher ────────────────────────────────────────────────────────────
  Future<void> print(BarcodePrintJob job) async {
    if (printMode == BarcodePrintMode.a4) {
      await printA4(job);
    } else {
      await printThermal(job);
    }
  }

  void _toast(String msg) => log(msg);
}

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
