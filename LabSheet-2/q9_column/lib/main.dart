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
        appBar: AppBar(title: const Text('Q9 Column')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('First Text', style: TextStyle(fontSize: 22)),
              SizedBox(height: 15),
              Text('Second Text', style: TextStyle(fontSize: 22)),
              SizedBox(height: 15),
              Text('Third Text', style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
