import 'dart:convert';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StudentJsonPage(), debugShowCheckedModeBanner: false));

class Student {
  final int id;
  final String name;
  final String email;
  const Student({required this.id, required this.name, required this.email});
  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: (json['id'] as num).toInt(), name: json['name'] as String, email: json['email'] as String,
  );
}

class StudentJsonPage extends StatelessWidget {
  const StudentJsonPage({super.key});
  static const rawJson = '[{"id":1,"name":"Aarav Sharma","email":"aarav@example.com"},{"id":2,"name":"Meera Singh","email":"meera@example.com"},{"id":3,"name":"Kabir Verma","email":"kabir@example.com"}]';
  @override
  Widget build(BuildContext context) {
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    final students = decoded.map((item) => Student.fromJson(item as Map<String, dynamic>)).toList();
    return Scaffold(appBar: AppBar(title: const Text('Q1: JSON to Student objects')),
      body: ListView.builder(itemCount: students.length, itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(leading: CircleAvatar(child: Text('${student.id}')), title: Text(student.name), subtitle: Text(student.email));
      }));
  }
}
