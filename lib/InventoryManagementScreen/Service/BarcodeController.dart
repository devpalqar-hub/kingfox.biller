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

/// Label size definition.
///
/// [cols] / [rows]  — exact grid on one A4 sheet (never derive at runtime).
/// [marginMm]       — dead border around the sheet edge (printer + sheet spec).
/// [gapMm]          — gap between adjacent labels (horizontal & vertical).
///
/// These three values MUST match the physical label sheet you buy.
class BarcodeLabelSize {
  final String name;
  final double widthMm;
  final double heightMm;
  final int cols;
  final int rows;
  final double marginMm; // sheet border — typically 8–11 mm
  final double gapMm; // inter-label gap — typically 2–3 mm

  const BarcodeLabelSize({
    required this.name,
    required this.widthMm,
    required this.heightMm,
    required this.cols,
    required this.rows,
    this.marginMm = 10.0,
    this.gapMm = 2.5,
  });

  int get labelsPerA4Sheet => cols * rows;
}

/// Pre-defined standard label sizes.
/// Margins and gaps match the most common Avery-compatible sheets.
const List<BarcodeLabelSize> kLabelSizes = [
  BarcodeLabelSize(
    name: '48 × 24 mm  (48/sheet)',
    widthMm: 48,
    heightMm: 24,
    cols: 4,
    rows: 12, // 4 × 12 = 48
    marginMm: 9.0,
    gapMm: 2.5,
  ),
  BarcodeLabelSize(
    name: '52 × 26 mm  (30/sheet)',
    widthMm: 52,
    heightMm: 26,
    cols: 3,
    rows: 10, // 3 × 10 = 30
    marginMm: 10.5,
    gapMm: 3.0,
  ),
  BarcodeLabelSize(
    name: '63 × 38 mm  (21/sheet)',
    widthMm: 63,
    heightMm: 38,
    cols: 3,
    rows: 7, // 3 × 7 = 21
    marginMm: 10.0,
    gapMm: 2.0,
  ),
  BarcodeLabelSize(
    name: '70 × 37 mm  (24/sheet)',
    widthMm: 70,
    heightMm: 37,
    cols: 3,
    rows: 8, // 3 × 8 = 24
    marginMm: 10.5,
    gapMm: 2.0,
  ),
  BarcodeLabelSize(
    name: '99 × 57 mm  (10/sheet)',
    widthMm: 99,
    heightMm: 57,
    cols: 2,
    rows: 5, // 2 × 5 = 10
    marginMm: 11.0,
    gapMm: 3.0,
  ),
];

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

  /// Key includes size index so sessions from different label sizes never mix.
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
  bool _isConnecting = false;

  String? savedThermalName;
  String? savedThermalAddress;
  ConnectionType? savedThermalConnType;
  bool get hasSavedThermal => savedThermalAddress != null;

  // ── Sheet session cache ───────────────────────────────────────────────────
  final Map<String, SheetSession> _sessions = {};

  final _plugin = FlutterThermalPrinter.instance;

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  bool isDeviceConnected(Printer printer) {
    if (!isConnected || selectedPrinter == null) return false;
    final s = selectedPrinter!;
    if ((s.address ?? '').isNotEmpty && (printer.address ?? '').isNotEmpty) {
      return s.address == printer.address;
    }
    return s.name == printer.name && s.connectionType == printer.connectionType;
  }

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
    savedThermalAddress = savedThermalName = null;
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
    // Invalidate in-memory session cache when size changes — persisted keys
    // already embed the size index so old data is never reloaded.
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
    final used = p.getInt('${_kBarcodeRemainingPrefix}${key}_used') ?? 0;
    final total = selectedSize.labelsPerA4Sheet;
    // Guard: stored `used` may exceed total if size was changed.
    final safeUsed = used.clamp(0, total);
    final session = SheetSession(key: key, used: safeUsed, total: total);
    _sessions[key] = session;
    return session;
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

  // ─────────────────────────────────────────────────────────────────────────
  // Entry point
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
      final total = size.labelsPerA4Sheet;
      final key = job.sheetKey(selectedSizeIndex);
      final session = await _getSession(key);

      // ── Page planning ────────────────────────────────────────────────────
      int remaining = job.count;
      final pages = <_PageSpec>[];

      // Resume on the current partially-used sheet.
      if (session.hasSpace && session.used > 0) {
        final canFit = session.remaining.clamp(0, remaining);
        pages.add(
          _PageSpec(startSlot: session.used, count: canFit, totalSlots: total),
        );
        remaining -= canFit;
        session.used += canFit;
        if (session.used >= total) session.used = 0; // sheet exhausted → reset
      }

      // Full / partial fresh sheets for the rest.
      while (remaining > 0) {
        final canFit = remaining.clamp(0, total);
        pages.add(_PageSpec(startSlot: 0, count: canFit, totalSlots: total));
        remaining -= canFit;
        session.used = (canFit < total) ? canFit : 0;
      }

      await _saveSession(session);

      // ── PDF build ─────────────────────────────────────────────────────────
      final pdf = pw.Document();
      final font = pw.Font.helvetica();
      final fontBold = pw.Font.helveticaBold();

      final marginPt = size.marginMm * PdfPageFormat.mm;
      final gapPt = size.gapMm * PdfPageFormat.mm;
      final labelW = size.widthMm * PdfPageFormat.mm;
      final labelH = size.heightMm * PdfPageFormat.mm;
      final cols = size.cols;
      final rows = size.rows;

      for (final page in pages) {
        final slotCount = cols * rows;

        // Populate slot map — guard against out-of-bounds if session was stale.
        final slots = List<bool>.filled(slotCount, false);
        for (int i = 0; i < page.count; i++) {
          final slotIdx = page.startSlot + i;
          if (slotIdx >= slotCount) break; // ← crash guard
          slots[slotIdx] = true;
        }

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero, // We control all spacing manually.
            build: (_) => pw.Padding(
              padding: pw.EdgeInsets.all(marginPt),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: List.generate(rows, (row) {
                  return pw.Row(
                    children: List.generate(cols, (col) {
                      final idx = row * cols + col;
                      final filled = idx < slotCount && slots[idx];
                      return pw.Padding(
                        padding: pw.EdgeInsets.only(
                          right: col < cols - 1 ? gapPt : 0,
                          bottom: row < rows - 1 ? gapPt : 0,
                        ),
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
                  );
                }),
              ),
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

  // ─────────────────────────────────────────────────────────────────────────
  // PDF label cell
  // ─────────────────────────────────────────────────────────────────────────
  pw.Widget _buildPdfLabel({
    required BarcodePrintJob job,
    required pw.Font font,
    required pw.Font fontBold,
    required double w,
    required double h,
  }) {
    // 2 mm inset keeps content away from die-cut edge.
    const padMm = 2.0;
    const padPt = padMm * PdfPageFormat.mm;

    final innerW = w - padPt * 2;
    final innerH = h - padPt * 2;

    // Barcode occupies 50 % of inner height, capped at 18 mm.
    final barcodeH = (innerH * 0.50).clamp(0.0, 18.0 * PdfPageFormat.mm);

    // Barcode width: leave 15 % each side as quiet zone for scanner margin.
    final barcodeW = innerW * 0.85;

    // Font sizes scale with label height; raised minimums for laser legibility.
    final fsBig = (h * 0.13).clamp(6.0, 9.0);
    final fsSmall = (h * 0.10).clamp(5.5, 7.5);

    return pw.SizedBox(
      width: w,
      height: h,
      child: pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400, width: 0.3),
        ),
        padding: pw.EdgeInsets.all(padPt),
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // ── Product name ──────────────────────────────────────────────
            pw.SizedBox(
              width: innerW,
              child: pw.Text(
                job.productName,
                style: pw.TextStyle(font: fontBold, fontSize: fsBig),
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                textAlign: pw.TextAlign.center,
              ),
            ),

            // ── Variant ───────────────────────────────────────────────────
            if (job.variantName != null)
              pw.SizedBox(
                width: innerW,
                child: pw.Text(
                  job.variantName!,
                  style: pw.TextStyle(font: font, fontSize: fsSmall),
                  maxLines: 1,
                  overflow: pw.TextOverflow.clip,
                  textAlign: pw.TextAlign.center,
                ),
              ),

            // ── Barcode — constrained SizedBox prevents stretch / overflow ─
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

            // ── Barcode digits ────────────────────────────────────────────
            pw.Text(
              job.barcodeValue,
              style: pw.TextStyle(
                font: font,
                fontSize: fsSmall,
                letterSpacing: 0.8,
              ),
              textAlign: pw.TextAlign.center,
            ),

            // ── Price (ASCII-safe — no ₹ in PDF Helvetica subset issues) ──
            if (job.price != null)
              pw.Text(
                'Rs. ${job.price!.toStringAsFixed(2)}',
                style: pw.TextStyle(font: fontBold, fontSize: fsBig),
                textAlign: pw.TextAlign.center,
              ),
          ],
        ),
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

      // Dots-per-mm at 203 dpi ≈ 8 dots/mm.
      const dotsPerMm = 8;

      // Barcode height in dots: 40 % of label height, clamped 24–80.
      final barcodeHeightDots = ((selectedSize.heightMm * 0.40) * dotsPerMm)
          .round()
          .clamp(24, 80);

      // Barcode module width multiplier: compute max safe value so barcode
      // never overflows the printable width of the paper.
      final barcodeData = job.barcodeValue.trim();
      int barcodeWidth = 2; // default
      if (barcodeData.isNotEmpty) {
        final printableWidthDots =
            (selectedSize.widthMm - 8) * dotsPerMm; // 4 mm quiet zone each side
        final modulesNeeded = 11 * barcodeData.length;
        final maxMult = (printableWidthDots / modulesNeeded).floor().clamp(
          1,
          3,
        );
        barcodeWidth = maxMult;
      }

      for (int i = 0; i < job.count; i++) {
        List<int> bytes = [];

        // ── FIX: Reset printer state at the start of EVERY label ──────────
        // Some firmware carries over the alignment state from the previous
        // cut command, causing all subsequent labels to print left-aligned.
        // generator.reset() sends ESC @ which resets all modes to default
        // (left-align) — we then immediately set center for this label.
        bytes += generator.reset();

        // ── FIX: Explicitly set global alignment to center ────────────────
        // ESC a 1 sets center alignment for all following content including
        // the barcode widget, which ignores PosStyles.align on some firmwares.
        bytes += generator.setStyles(const PosStyles(align: PosAlign.center));

        // ── Product name ──────────────────────────────────────────────────
        // bytes += generator.text(
        //   _truncateForThermal(job.productName, paperSize),
        //   styles: const PosStyles(
        //     align: PosAlign.center,
        //     bold: true,
        //     height: PosTextSize.size1,
        //     width: PosTextSize.size1,
        //   ),
        // );

        // ── Variant ───────────────────────────────────────────────────────
        if (job.variantName != null) {
          bytes += generator.text(
            _truncateForThermal(job.variantName!, paperSize),
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
        }
        if (job.price != null) {
          bytes += generator.setStyles(const PosStyles(align: PosAlign.center));
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

        // ── FIX: Re-assert center alignment before barcode ─────────────────
        // generator.barcode() does not accept a PosStyles argument — it uses
        // whatever alignment is currently active in the printer's register.
        // Re-sending ESC a 1 here guarantees the barcode is centered even on
        // printers that reset alignment after rendering text lines.
        if (barcodeData.isNotEmpty) {
          bytes += generator.setStyles(const PosStyles(align: PosAlign.center));
          bytes += generator.barcode(
            Barcode.code128(barcodeData.codeUnits),
            height: barcodeHeightDots,
            width: barcodeWidth,
            textPos: BarcodeText.below,
          );
        }

        // ── Price — use ASCII "Rs." to avoid CP437 encoding issues ────────
        // FIX: Re-assert center BEFORE price text.
        // BarcodeText.below renders the digit line via the printer's own text
        // engine which resets the alignment register to left when it finishes.
        // Without this setStyles call the price prints left-aligned on every
        // label regardless of the PosStyles.align value passed to generator.text.

        // ── FIX: Reset styles before feed/cut ─────────────────────────────
        // Clears bold, size, and alignment flags so they don't bleed into
        // the next label's initial state after the cut command executes.
        bytes += generator.reset();

        // ── Feed + cut ────────────────────────────────────────────────────
        // feed(1) moves the last line past the cutter head.
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

  /// Truncate using grapheme-aware character count so multi-byte glyphs
  /// (e.g. Malayalam) don't overflow the paper width.
  String _truncateForThermal(String text, PaperSize paperSize) {
    final maxChars = paperSize == PaperSize.mm58 ? 32 : 48;
    final chars = text.characters; // grapheme clusters
    return chars.length > maxChars ? chars.take(maxChars).string : text;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // macOS CUPS path
  // ─────────────────────────────────────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────────────────
  // Master dispatcher
  // ─────────────────────────────────────────────────────────────────────────
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
