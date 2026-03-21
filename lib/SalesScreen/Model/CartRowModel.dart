import 'package:kinfox_biller/SalesScreen/Model/CartModel.dart';

class CartRowModel {
  final CartItemModel? item;
  final ReturnItemModel? returnItem;
  final bool isReturn;

  CartRowModel({
    this.item,
    this.returnItem,
    required this.isReturn,
  });
}