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
        appBar: AppBar(title: const Text('Q2 Student Details')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Name: Uttam Tyagi', style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              Text('Course: B.Tech CSE', style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              Text('Semester: 3rd', style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              Text('College: Chandigarh University', style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
