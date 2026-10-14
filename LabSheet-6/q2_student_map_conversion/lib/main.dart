import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Student {
  final String name;
  final String rollNumber;
  final String course;
  Student({required this.name, required this.rollNumber, required this.course});
  Map<String, dynamic> toMap() => {'name': name, 'rollNumber': rollNumber, 'course': course};
  factory Student.fromMap(Map<String, dynamic> map) => Student(
    name: map['name'] ?? '', rollNumber: map['rollNumber'] ?? '', course: map['course'] ?? '',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const StudentPage());
}

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});
  @override
  Widget build(BuildContext context) {
    final student = Student(name: 'Uttam', rollNumber: '290179', course: 'B.Tech');
    final map = student.toMap();
    final restored = Student.fromMap(map);
    return Scaffold(
      appBar: AppBar(title: const Text('Q2 - toMap / fromMap')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Map: $map'), const SizedBox(height: 20),
          Text('Name: ${restored.name}'), Text('Roll Number: ${restored.rollNumber}'), Text('Course: ${restored.course}'),
        ]),
      ),
    );
  }
}
