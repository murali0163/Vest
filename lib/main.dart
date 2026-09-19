import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const VestApp());
}

class VestApp extends StatelessWidget {
  const VestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vest',
      debugShowCheckedModeBanner: false,
      theme: buildVestTheme(),
      home: const WelcomeScreen(),
    );
  }
}