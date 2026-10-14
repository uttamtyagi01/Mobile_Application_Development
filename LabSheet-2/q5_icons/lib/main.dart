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
      home: Scaffold(
        appBar: AppBar(title: const Text('Q5 Icon Widget')),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 60),
              SizedBox(width: 25),
              Icon(Icons.favorite, size: 60),
              SizedBox(width: 25),
              Icon(Icons.settings, size: 60),
            ],
          ),
        ),
      ),
    );
  }
}
