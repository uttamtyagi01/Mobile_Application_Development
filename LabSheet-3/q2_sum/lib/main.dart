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
      home: const SumScreen(),
    );
  }
}

class SumScreen extends StatefulWidget {
  const SumScreen({super.key});

  @override
  State<SumScreen> createState() => _SumScreenState();
}

class _SumScreenState extends State<SumScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  void calculateSum() {
    final double first = double.tryParse(firstController.text) ?? 0;
    final double second = double.tryParse(secondController.text) ?? 0;

    setState(() {
      result = 'Sum = ${first + second}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q2 Sum')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'First Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: secondController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Second Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateSum,
              child: const Text('Calculate Sum'),
            ),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
