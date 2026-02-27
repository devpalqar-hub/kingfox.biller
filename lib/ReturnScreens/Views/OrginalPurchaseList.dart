import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OriginalPurchaseList extends StatelessWidget {
  const OriginalPurchaseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 830.w,
      
      decoration: BoxDecoration(
        color: Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          
          Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(
                horizontal: 20.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Original Purchase List",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "3 ITEMS TOTAL",
                  style: TextStyle(
                    fontSize: 12.sp,
                    letterSpacing: 1.3,
                    color: const Color(0xff94A3B8),
                  ),
                )
              ],
            ),
          ),
         _divider(),

          _itemTile(
            title: "Slim Fit Denim Shirt",
            sku: "SKU: DNM-0024-BL",
            price: "₹1,899",
            selected: true,
            maxQty: 2,
            image: "assets/images/shirt.png",
            reason: "Sizing Issue",
          ),

          _divider(),

          _itemTile(
            title: "Casual Cotton T-Shirt",
            sku: "SKU: TEE-0912-WH",
            price: "₹899",
            selected: false,
            image: "assets/images/tshirt.png",
          ),

          _divider(),

          _itemTile(
            title: "Performance Mesh Sneakers",
            sku: "SKU: SHO-1102-RD",
            price: "₹2,499",
            selected: true,
            maxQty: 1,
            image: "assets/images/shoes.png",
            reason: "Damaged Item",
          ),
        ],
      ),
    );
  }

 
  Widget _divider() {
    return Container(
      height: 1.h,
      color: const Color(0xffE5E7EB),
    );
  }

  
  Widget _itemTile({
    required String title,
    required String sku,
    required String price,
    required bool selected,
    String? image,
    String? reason,
    int maxQty = 1,
  }) {
    return Container(
      color: Colors.white,
     
    
      padding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Container(
            height: 24.w,
            width: 24.w,
            decoration: BoxDecoration(
              color:
                  selected ? const Color(0xffDC2626) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xffCBD5E1)),
            ),
            child: selected
                ? Icon(Icons.check,
                    size: 16.sp, color: Colors.white)
                : null,
          ),

          SizedBox(width: 16.w),

       
          Container(
            height: 84.w,
            width: 84.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xffF1F5F9),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: image != null
                ? Image.asset(image, fit: BoxFit.contain)
                : const SizedBox(),
          ),

          SizedBox(width: 18.w),

        
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            sku,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color:
                                  const Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 18.w),

                    
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color:
                                const Color(0xff16A34A),
                          ),
                        ),
                        Text(
                          "Unit Price",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                const Color(0xff94A3B8),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 14.h),

               
if (selected) ...[
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RETURN REASON",
              style: TextStyle(
                fontSize: 11.sp,
                letterSpacing: 1.5,
                color: const Color(0xff94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 8.h),

            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 14.w, vertical: 12.h),
                  width: 220.w,
              decoration: BoxDecoration(
                color: const Color(0xffF1F5F9),
                borderRadius: BorderRadius.circular(14.r),
                border:
                    Border.all(color: const Color(0xffE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(reason ?? ""),
                  Icon(Icons.keyboard_arrow_down,
                      size: 20.sp)
                ],
              ),
            ),
          ],
        ),
      ),

      SizedBox(width: 30.w),

   
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "ADJUST QUANTITY",
            style: TextStyle(
              fontSize: 11.sp,
              letterSpacing: 1.5,
              color: const Color(0xff94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              _qtyButton(
                  Icons.remove, Colors.red.shade400),

              SizedBox(width: 12.w),

              Text(
                "1",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(width: 12.w),

              _qtyButton(
                  Icons.add, Colors.green.shade400),

              SizedBox(width: 10.w),

              Text(
                "Max $maxQty",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff94A3B8),
                ),
              )
            ],
          ),
        ],
      ),
    ],
  ),
]
                
                
                else ...[
                  Text(
                    "Select item to adjust return details",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xff94A3B8),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Purchased: 1",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xff94A3B8),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, Color color) {
    return Container(
      height: 34.w,
      width: 34.w,
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18.sp, color: color),
    );
  }
}