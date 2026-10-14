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
        appBar: AppBar(title: const Text('Q8 Row')),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Home', style: TextStyle(fontSize: 20)),
              Text('Profile', style: TextStyle(fontSize: 20)),
              Text('Settings', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
