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
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.blueAccent,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Updated from headline6
          titleMedium: TextStyle(fontSize: 16.0), // Updated from subtitle1
          bodyMedium: TextStyle(fontSize: 14.0), // Updated from bodyText2
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Updated from primary
            foregroundColor: Colors.white, // Updated from onPrimary
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
