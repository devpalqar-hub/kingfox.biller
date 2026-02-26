import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerVoucherCard extends StatelessWidget {
  const CustomerVoucherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
       width: 448.w,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFDCE4DC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            const Row(
              children: [
                Icon(Icons.confirmation_number_outlined,
                    size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Customer Name",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "..................",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// Phone Number
            const Row(
              children: [
                Icon(Icons.phone_outlined,
                    size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Phone no",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "0000000000",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C7A89),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      "Enter",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// Select Voucher
            const Row(
              children: [
                Icon(Icons.confirmation_number_outlined,
                    size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Select Voucher",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "UTNEW",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      
    );
  }
}