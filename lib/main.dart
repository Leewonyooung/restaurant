import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/view/restaurant_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
    static const seedColor = Color.fromARGB(255, 193, 242, 142);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: seedColor,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,  // 디버그 표시 제거
      home: const RestaurantTab(),
    );
  }
}
