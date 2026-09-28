import 'dart:convert';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const JsonPage());
}

class JsonPage extends StatelessWidget {
  const JsonPage({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> student = {'name': 'Uttam', 'rollNumber': '290179', 'course': 'B.Tech'};
    final String jsonString = jsonEncode(student);
    final Map<String, dynamic> restoredMap = jsonDecode(jsonString);
    return Scaffold(
      appBar: AppBar(title: const Text('Q3 - Map and JSON')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Original Map:', style: TextStyle(fontWeight: FontWeight.bold)), Text('$student'),
          const SizedBox(height: 16),
          const Text('JSON String:', style: TextStyle(fontWeight: FontWeight.bold)), Text(jsonString),
          const SizedBox(height: 16),
          const Text('Map from JSON:', style: TextStyle(fontWeight: FontWeight.bold)), Text('$restoredMap'),
        ]),
      ),
    );
  }
}
