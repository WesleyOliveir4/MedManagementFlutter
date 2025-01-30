import 'package:flutter/material.dart';
import 'package:med_management/features/presentation/pages/home_page.dart';
import 'package:med_management/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomePage(),
    );
  }
}
