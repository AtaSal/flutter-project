import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/feeds_screen.dart';
import 'screens/login_screen.dart';

SharedPreferences? shrePref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shrePref = await SharedPreferences.getInstance(); // Initialize SharedPreferences
  runApp(const PPUFeedApp());
}

class PPUFeedApp extends StatelessWidget {
  const PPUFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPU Feeds App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: shrePref?.getString("token") != null ? '/home' : '/login',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/feeds': (context) => const FeedsScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
