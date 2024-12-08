import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PPUFeedApp());
}

class PPUFeedApp extends StatelessWidget {
  const PPUFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPU Feed App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
