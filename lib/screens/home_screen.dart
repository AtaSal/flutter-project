import 'package:flutter/material.dart';
import 'feeds_screen.dart';

class HomeScreen extends StatelessWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.feed),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedsScreen(token: token)),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Your subscribed courses will appear here.'),
      ),
    );
  }
}
