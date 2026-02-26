import 'package:get/get.dart';

class DashboardController extends GetxController {

  int currentTab = 0;

  void changeTab(int index) {
    currentTab = index;
    update(); // rebuild UI
  }
}