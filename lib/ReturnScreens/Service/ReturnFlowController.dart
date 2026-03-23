import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kinfox_biller/OverViewScreen/Model/InvoiceModel.dart';
import 'package:kinfox_biller/main.dart';

class ReturnFlowController extends GetxController {

  bool showReturnScreen = false;
  bool isLoading = false;

  InvoiceModel? invoice;
  List<InvoiceModel> recentInvoices = [];

  @override
  void onInit() {
    super.onInit();
   
  }

  void startReturn() {
    showReturnScreen = true;
    update();
  }

  void backToInitiate() {
    showReturnScreen = false;
    update();
  }

  
}