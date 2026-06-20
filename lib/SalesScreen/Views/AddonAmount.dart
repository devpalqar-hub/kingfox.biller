import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/SalesScreen/Service/AddProductController.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ADDON MODEL  (inline — no separate file needed)
// ─────────────────────────────────────────────────────────────────────────────
class _Addon {
  final String name;
  final double price;
  final bool isCustom;

  const _Addon({
    required this.name,
    required this.price,
    this.isCustom = false,
  });

  _Addon copyWith({double? price}) =>
      _Addon(name: name, price: price ?? this.price, isCustom: isCustom);

  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}

// ─────────────────────────────────────────────────────────────────────────────
// PREDEFINED CATALOGUE
// ─────────────────────────────────────────────────────────────────────────────
const _kPredefined = [
  _Addon(name: 'Gift Wrap', price: 50),
  _Addon(name: 'Alteration', price: 100),
];

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO OPEN
// ─────────────────────────────────────────────────────────────────────────────
//
// Pass the already-selected addons (from previous open) so the dialog
// restores state.  When Done is tapped the result is pushed back via
// AddProductController.setAddons().
//
//   showDialog(
//     context: context,
//     builder: (_) => AddonsDialog(
//       initial: ctrl.addons,   // List<Map<String,dynamic>>
//     ),
//   );
//
// In AddProductController add:
//
//   List<Map<String, dynamic>> addons = [];
//
//   void setAddons(List<Map<String, dynamic>> value) {
//     addons = value;
//     getCart();   // refresh totals
//     update();
//   }
//
// Then in getCart() query params:
//   if (addons.isNotEmpty) queryParams['addons'] = jsonEncode(addons);
//
// And in checkoutCart() body:
//   if (addons.isNotEmpty) body['addons'] = addons;
//
// Clear in clearAllTextControllers() and changeSession():
//   addons = [];

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG
// ─────────────────────────────────────────────────────────────────────────────
class AddonsDialog extends StatefulWidget {
  /// Pass previously selected addons so state survives re-opens.
  final List<Map<String, dynamic>> initial;

  const AddonsDialog({super.key, this.initial = const []});

  @override
  State<AddonsDialog> createState() => _AddonsDialogState();
}

class _AddonsDialogState extends State<AddonsDialog> {
  // ── local state ────────────────────────────────────────────────────────────
  late List<_Addon> _selected;

  // editable price controllers for predefined chips
  late final Map<String, TextEditingController> _chipPrice;

  // manual-entry controllers
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _nameErr;
  String? _priceErr;

  // ── init ───────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // Restore from initial (the controller's saved list)
    _selected = widget.initial
        .map(
          (m) => _Addon(
            name: m['name'] as String,
            price: (m['price'] as num).toDouble(),
            isCustom: !(_kPredefined.any((p) => p.name == m['name'])),
          ),
        )
        .toList();

    // Seed chip price controllers with restored or default prices
    _chipPrice = {
      for (final p in _kPredefined)
        p.name: TextEditingController(
          text: (_selectedPrice(p.name) ?? p.price).toStringAsFixed(0),
        ),
    };
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    for (final c in _chipPrice.values) c.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────────────────────
  double? _selectedPrice(String name) {
    try {
      return _selected.firstWhere((a) => a.name == name).price;
    } catch (_) {
      return null;
    }
  }

  bool _isSelected(String name) => _selected.any((a) => a.name == name);

  void _togglePredefined(String name) {
    setState(() {
      if (_isSelected(name)) {
        _selected.removeWhere((a) => a.name == name);
      } else {
        final price =
            double.tryParse(_chipPrice[name]!.text.trim()) ??
            _kPredefined.firstWhere((p) => p.name == name).price;
        _selected.add(_Addon(name: name, price: price));
      }
    });
  }

  void _updateChipPrice(String name, String raw) {
    final price = double.tryParse(raw.trim());
    if (price == null || price <= 0) return;
    final idx = _selected.indexWhere((a) => a.name == name);
    if (idx >= 0) {
      setState(() => _selected[idx] = _selected[idx].copyWith(price: price));
    }
  }

  void _addCustom() {
    setState(() {
      _nameErr = null;
      _priceErr = null;
    });
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());

    if (name.isEmpty) {
      setState(() => _nameErr = 'Enter a name');
      return;
    }
    if (price == null || price <= 0) {
      setState(() => _priceErr = 'Enter valid price');
      return;
    }
    if (_selected.any((a) => a.name.toLowerCase() == name.toLowerCase())) {
      setState(() => _nameErr = 'Already added');
      return;
    }

    setState(() {
      _selected.add(_Addon(name: name, price: price, isCustom: true));
      _nameCtrl.clear();
      _priceCtrl.clear();
    });
  }

  void _updateSelectedPrice(int idx, String raw) {
    final price = double.tryParse(raw.trim());
    if (price == null || price <= 0) return;
    setState(() => _selected[idx] = _selected[idx].copyWith(price: price));
  }

  void _remove(int idx) => setState(() => _selected.removeAt(idx));

  double get _total => _selected.fold(0, (s, a) => s + a.price);

  void _done() {
    final ctrl = Get.find<AddProductController>();
    ctrl.setAddons(_selected.map((a) => a.toJson()).toList());
    Get.back();
  }

  // ── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            _buildSectionLabel('Quick add'),
            SizedBox(height: 8.h),
            _buildPredefinedChips(),
            SizedBox(height: 16.h),
            _buildSectionLabel('Custom add-on'),
            SizedBox(height: 8.h),
            _buildCustomRow(),
            if (_selected.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Divider(height: 1, color: const Color(0xFFF1F5F9)),
              SizedBox(height: 12.h),
              _buildSectionLabel('Selected'),
              SizedBox(height: 8.h),
              _buildSelectedList(),
            ],
            SizedBox(height: 16.h),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() => Row(
    children: [
      Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.add_shopping_cart_rounded,
          size: 16.sp,
          color: const Color(0xFF6366F1),
        ),
      ),
      SizedBox(width: 10.w),
      Text(
        'Add-ons',
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
        ),
      ),
      const Spacer(),
      GestureDetector(
        onTap: Get.back,
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 15.sp,
            color: const Color(0xFF64748B),
          ),
        ),
      ),
    ],
  );

  // ── section label ──────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF94A3B8),
      letterSpacing: 0.4,
    ),
  );

  // ── predefined chips ───────────────────────────────────────────────────────
  Widget _buildPredefinedChips() => Wrap(
    spacing: 8.w,
    runSpacing: 8.h,
    children: _kPredefined.map((p) {
      final sel = _isSelected(p.name);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: sel ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: sel ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
            width: sel ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // toggle side
            GestureDetector(
              onTap: () => _togglePredefined(p.name),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  top: 8.h,
                  bottom: 8.h,
                  right: 6.w,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        sel
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        key: ValueKey(sel),
                        size: 14.sp,
                        color: sel
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      p.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: sel
                            ? const Color(0xFF4338CA)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // divider
            Container(
              width: 1,
              height: 20.h,
              color: sel ? const Color(0xFFC7D2FE) : const Color(0xFFE2E8F0),
            ),
            // editable price
            SizedBox(
              width: 56.w,
              child: TextField(
                controller: _chipPrice[p.name],
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (v) => _updateChipPrice(p.name, v),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: sel
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF64748B),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 8.h,
                  ),
                  prefixText: '₹',
                  prefixStyle: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: sel
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );

  // ── custom entry row ───────────────────────────────────────────────────────
  Widget _buildCustomRow() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 5, child: _field(_nameCtrl, 'Name', _nameErr)),
      SizedBox(width: 8.w),
      Expanded(
        flex: 3,
        child: _field(_priceCtrl, '₹ Price', _priceErr, numeric: true),
      ),
      SizedBox(width: 8.w),
      GestureDetector(
        onTap: _addCustom,
        child: Container(
          height: 40.h,
          width: 40.h,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 18.sp),
        ),
      ),
    ],
  );

  // ── selected list ──────────────────────────────────────────────────────────
  Widget _buildSelectedList() => ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 160.h),
    child: ListView.separated(
      shrinkWrap: true,
      itemCount: _selected.length,
      separatorBuilder: (_, __) => SizedBox(height: 6.h),
      itemBuilder: (_, i) {
        final item = _selected[i];
        return _SelectedRow(
          addon: item,
          onPriceChanged: (v) => _updateSelectedPrice(i, v),
          onRemove: () => _remove(i),
        );
      },
    ),
  );

  // ── footer ─────────────────────────────────────────────────────────────────
  Widget _buildFooter() => Row(
    children: [
      if (_selected.isNotEmpty) ...[
        Text(
          'Total: ',
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF64748B)),
        ),
        Text(
          '₹${_total.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6366F1),
          ),
        ),
      ],
      const Spacer(),
      GestureDetector(
        onTap: _done,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'Done',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );

  // ── shared input field ─────────────────────────────────────────────────────
  Widget _field(
    TextEditingController ctrl,
    String hint,
    String? error, {
    bool numeric = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: error != null
                ? const Color(0xFFEF4444)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: TextField(
          controller: ctrl,
          keyboardType: numeric ? TextInputType.number : TextInputType.text,
          inputFormatters: numeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
              : null,
          onChanged: (_) => setState(() {
            if (numeric)
              _priceErr = null;
            else
              _nameErr = null;
          }),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFFCBD5E1),
            ),
          ),
        ),
      ),
      if (error != null)
        Padding(
          padding: EdgeInsets.only(top: 3.h, left: 2.w),
          child: Text(
            error,
            style: TextStyle(fontSize: 10.sp, color: const Color(0xFFEF4444)),
          ),
        ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SELECTED ROW  (stateful only for its own price TextEditingController)
// ─────────────────────────────────────────────────────────────────────────────
class _SelectedRow extends StatefulWidget {
  final _Addon addon;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onRemove;

  const _SelectedRow({
    required this.addon,
    required this.onPriceChanged,
    required this.onRemove,
  });

  @override
  State<_SelectedRow> createState() => _SelectedRowState();
}

class _SelectedRowState extends State<_SelectedRow> {
  late final TextEditingController _pc;

  @override
  void initState() {
    super.initState();
    _pc = TextEditingController(text: widget.addon.price.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(_SelectedRow old) {
    super.didUpdateWidget(old);
    if (old.addon.price != widget.addon.price) {
      _pc.text = widget.addon.price.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          if (widget.addon.isCustom)
            Container(
              margin: EdgeInsets.only(right: 6.w),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Text(
                'Custom',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEA580C),
                ),
              ),
            ),
          Expanded(
            child: Text(
              widget.addon.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 70.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _pc,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: widget.onPriceChanged,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 6.h,
                ),
                prefixText: '₹',
                prefixStyle: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: widget.onRemove,
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 13.sp,
                color: const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
