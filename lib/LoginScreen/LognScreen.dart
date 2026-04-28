import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinfox_biller/DashBoard/DashBoardScreen.dart';
import 'package:kinfox_biller/LoginScreen/Service/AuthController.dart';
import 'package:kinfox_biller/main.dart';

// ── Palette ───────────────────────────────────────────────────────────────────
const _bg = Color(0xff0f0f0f);
const _surface = Color(0xff1a1a1a);
const _border = Color(0xff2e2e2e);
const _gold = Color(0xffD4A26A);
const _textPri = Color(0xffE8E8E8);
const _textMuted = Color(0xff666666);
const _textHint = Color(0xff3a3a3a);

// Replace with your own Unsplash / CDN URLs or local assets
const _fashionImages = [
  'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600&q=80',
  'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&q=80',
  'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600&q=80',
  'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&q=80',
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _pinVisible = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: GetBuilder<AuthController>(
        builder: (auth) => Row(
          children: [
            // ── Left panel ─────────────────────────────────────────────
            Expanded(flex: 11, child: _LeftPanel()),

            // ── Right panel ────────────────────────────────────────────
            Expanded(
              flex: 12,
              child: Container(
                color: _bg,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 360.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BrandMark(),
                      SizedBox(height: 32.h),
                      Text(
                        "Staff sign in",
                        style: TextStyle(
                          color: _textPri,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Access the billing terminal with your credentials",
                        style: TextStyle(
                          color: _textMuted,
                          fontSize: 13.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // Staff ID
                      _FieldLabel("STAFF ID"),
                      SizedBox(height: 7.h),
                      _DarkInput(
                        controller: _idCtrl,
                        hint: "Enter your staff ID",
                        icon: Icons.person_outline_rounded,
                      ),
                      SizedBox(height: 18.h),

                      // PIN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FieldLabel("Password"),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Text(
                          //     "Forgot PIN?",
                          //     style: TextStyle(
                          //       color: _textMuted,
                          //       fontSize: 12.sp,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      _PinField(controller: _pinCtrl),
                      SizedBox(height: 24.h),

                      // Login button
                      _LoginButton(
                        auth: auth,
                        idCtrl: _idCtrl,
                        pinCtrl: _pinCtrl,
                      ),
                      SizedBox(height: 22.h),

                      // Status strip
                      _StatusStrip(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Left Panel ────────────────────────────────────────────────────────────────
class _LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff111111),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 2×2 staggered image grid
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _ImgTile(_fashionImages[0], topOffset: 0),
                      SizedBox(height: 8.h),
                      _ImgTile(_fashionImages[2], topOffset: -16),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 28.h),
                      _ImgTile(_fashionImages[1], topOffset: 0),
                      SizedBox(height: 8.h),
                      _ImgTile(_fashionImages[3], topOffset: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrim
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xff111111).withOpacity(0.6),
                  const Color(0xff111111).withOpacity(0.92),
                ],
                stops: const [0.3, 0.65, 1.0],
              ),
            ),
          ),

          // Branding
          Positioned(
            left: 28.w,
            right: 28.w,
            bottom: 28.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.13),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: const BoxDecoration(
                          color: _gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        "BILLING TERMINAL",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10.sp,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Kingfox Fashion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Point of sale system",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.38),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImgTile extends StatelessWidget {
  final String url;
  final double topOffset;
  const _ImgTile(this.url, {this.topOffset = 0});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.translate(
        offset: Offset(0, topOffset),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.18),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) => Container(color: _surface),
          ),
        ),
      ),
    );
  }
}

// ── Form sub-widgets ──────────────────────────────────────────────────────────
class _BrandMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Image.asset("assets/logo.png"),
        ),
        SizedBox(width: 10.w),
        Text(
          "Kingfox",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: _textMuted, fontSize: 11.sp, letterSpacing: 0.07),
    );
  }
}

class _DarkInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _DarkInput({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 14.sp, color: _textPri),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: _textHint),
        prefixIcon: Icon(icon, size: 17.sp, color: const Color(0xff555555)),
        filled: true,
        fillColor: _surface,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: _border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: _gold, width: 1),
        ),
      ),
    );
  }
}

class _PinField extends StatefulWidget {
  final TextEditingController controller;
  const _PinField({required this.controller});

  @override
  State<_PinField> createState() => _PinFieldState();
}

class _PinFieldState extends State<_PinField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: !_visible,
      keyboardType: TextInputType.number,
      //maxLength: 4,
      style: TextStyle(fontSize: 14.sp, color: _textPri),
      decoration: InputDecoration(
        counterText: "",
        hintText: "• • • •",
        hintStyle: TextStyle(
          fontSize: 14.sp,
          letterSpacing: 8,
          color: _textHint,
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          size: 17.sp,
          color: const Color(0xff555555),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _visible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 17.sp,
            color: const Color(0xff555555),
          ),
          onPressed: () => setState(() => _visible = !_visible),
        ),
        filled: true,
        fillColor: _surface,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: _border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: const BorderSide(color: _gold, width: 1),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final AuthController auth;
  final TextEditingController idCtrl, pinCtrl;
  const _LoginButton({
    required this.auth,
    required this.idCtrl,
    required this.pinCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: auth.isLoading
          ? null
          : () async {
              await auth.login(idCtrl.text, pinCtrl.text);
              if (accessToken != null) Get.off(() => Dashboardscreen());
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: auth.isLoading ? _gold.withOpacity(0.6) : _gold,
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Center(
          child: auth.isLoading
              ? SizedBox(
                  width: 19.w,
                  height: 19.h,
                  child: const CircularProgressIndicator(
                    color: Color(0xff111111),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "Sign in to billing",
                  style: TextStyle(
                    color: const Color(0xff111111),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8.r),
        border: const Border(
          left: BorderSide(color: Color(0xff22C55E), width: 3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 7.w,
            height: 7.h,
            decoration: const BoxDecoration(
              color: Color(0xff22C55E),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "Terminal active — Store #001",
            style: TextStyle(color: _textMuted, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
