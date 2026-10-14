import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Q1', home: const StudentMapPage());
}

class StudentMapPage extends StatelessWidget {
  const StudentMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> student = {
      'Name': 'Uttam',
      'Roll Number': '290179',
      'Course': 'B.Tech',
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Q1 - Student Details in Map')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: student.entries.map((e) => Card(child: ListTile(title: Text(e.key), subtitle: Text('${e.value}')))).toList(),
      ),
    );
  }
}
