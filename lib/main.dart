import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(KingfoxBiller());
}

class KingfoxBiller extends StatelessWidget {
  KingfoxBiller({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(theme: ThemeData(fontFamily: "Inter"));
  }
}
