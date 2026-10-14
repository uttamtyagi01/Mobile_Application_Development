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
      home: const TotalMarksScreen(),
    );
  }
}

class TotalMarksScreen extends StatefulWidget {
  const TotalMarksScreen({super.key});

  @override
  State<TotalMarksScreen> createState() => _TotalMarksScreenState();
}

class _TotalMarksScreenState extends State<TotalMarksScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mark1Controller = TextEditingController();
  final TextEditingController mark2Controller = TextEditingController();
  final TextEditingController mark3Controller = TextEditingController();
  String result = '';

  @override
  void dispose() {
    nameController.dispose();
    mark1Controller.dispose();
    mark2Controller.dispose();
    mark3Controller.dispose();
    super.dispose();
  }

  void calculateTotal() {
    final int mark1 = int.tryParse(mark1Controller.text) ?? 0;
    final int mark2 = int.tryParse(mark2Controller.text) ?? 0;
    final int mark3 = int.tryParse(mark3Controller.text) ?? 0;
    final int total = mark1 + mark2 + mark3;

    setState(() {
      result = '${nameController.text} - Total Marks: $total';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q7 Total Marks')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: mark1Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject 1 Marks', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: mark2Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject 2 Marks', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: mark3Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject 3 Marks', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: calculateTotal, child: const Text('Calculate Total')),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
