import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final String? badge;
  final bool danger;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.badge,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xffF1F5F9),
                child: Icon(icon, size: 18.sp),
              ),
              if (badge != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: danger
                        ? const Color(0xffFEE2E2)
                        : const Color(0xffE0F2FE),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: danger
                          ? const Color(0xffDC2626)
                          : const Color(0xff2563EB),
                    ),
                  ),
                )
            ],
          ),

          SizedBox(height: 16.h),

          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xff64748B),
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff94A3B8),
              ),
            ),
        ],
      ),
    );
  }
}