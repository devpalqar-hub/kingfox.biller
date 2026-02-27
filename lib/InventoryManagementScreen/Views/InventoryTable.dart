import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryTable extends StatelessWidget {
  const InventoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _header(),
          SizedBox(height: 15.h),
          _data("Slim Fit Denim Shirt", "Tops", "SKU-DNM-001",
              "M / Blue", "42 Units", "₹1,299", Colors.green),
          _data("Straight Fit Chinos", "Bottoms", "SKU-CHN-042",
              "32 / Beige", "5 Units", "₹2,499", Colors.orange),
          _data("Oversized Hoodie", "Outerwear", "SKU-HOD-009",
              "L / Black", "0 Units", "₹3,999", Colors.red),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("PRODUCT"),
        Text("CATEGORY"),
        Text("SKU"),
        Text("SIZE / COLOR"),
        Text("STOCK LEVEL"),
        Text("PRICE"),
      ],
    );
  }

  Widget _data(String product, String category, String sku,
      String size, String stock, String price, Color stockColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(product),
          Text(category),
          Text(sku),
          Text(size),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: stockColor.withOpacity(.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(stock,
                style: TextStyle(color: stockColor, fontSize: 12.sp)),
          ),
          Text(price,
              style: TextStyle(
                  color: const Color(0xff22C55E),
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}