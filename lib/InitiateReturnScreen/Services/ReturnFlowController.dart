import 'package:get/get.dart';

class ReturnFlowController extends GetxController {
  bool showReturnScreen = false;

  void startReturn() {
    showReturnScreen = true;
    update();
  }

  void backToInitiate() {
    showReturnScreen = false;
    update();
  }
}