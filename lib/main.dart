import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:care_sync/src/theme/darkTheme.dart';
import 'package:care_sync/src/theme/lightTheme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareSync',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
