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
      home: const PercentageScreen(),
    );
  }
}

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  final TextEditingController mark1Controller = TextEditingController();
  final TextEditingController mark2Controller = TextEditingController();
  final TextEditingController mark3Controller = TextEditingController();
  String result = '';

  @override
  void dispose() {
    mark1Controller.dispose();
    mark2Controller.dispose();
    mark3Controller.dispose();
    super.dispose();
  }

  void calculatePercentage() {
    final double mark1 = double.tryParse(mark1Controller.text) ?? 0;
    final double mark2 = double.tryParse(mark2Controller.text) ?? 0;
    final double mark3 = double.tryParse(mark3Controller.text) ?? 0;
    final double total = mark1 + mark2 + mark3;
    final double percentage = (total / 300) * 100;

    setState(() {
      result = 'Percentage = ${percentage.toStringAsFixed(2)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q8 Percentage')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: mark1Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject 1 Marks', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: mark2Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject 2 Marks', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: mark3Controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject 3 Marks', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: calculatePercentage, child: const Text('Calculate Percentage')),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
