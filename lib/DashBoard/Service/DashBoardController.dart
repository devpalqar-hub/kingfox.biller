import 'package:get/get.dart';

class DashboardController extends GetxController {

  int currentTab = 0;

  @override
  void onInit() {
    currentTab = 0; 
    super.onInit();
  }

  void changeTab(int index) {
    currentTab = index;
    update(); 
  }

  void resetTab() {
    currentTab = 0;
    update();
  }
}