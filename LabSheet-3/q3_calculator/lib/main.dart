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
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  void calculate(String operation) {
    final double first = double.tryParse(firstController.text) ?? 0;
    final double second = double.tryParse(secondController.text) ?? 0;

    double answer;
    switch (operation) {
      case 'Add':
        answer = first + second;
        break;
      case 'Subtract':
        answer = first - second;
        break;
      case 'Multiply':
        answer = first * second;
        break;
      case 'Divide':
        if (second == 0) {
          setState(() {
            result = 'Cannot divide by zero';
          });
          return;
        }
        answer = first / second;
        break;
      default:
        answer = 0;
    }

    setState(() {
      result = '$operation = $answer';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q3 Calculator')),
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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(onPressed: () => calculate('Add'), child: const Text('Add')),
                ElevatedButton(onPressed: () => calculate('Subtract'), child: const Text('Subtract')),
                ElevatedButton(onPressed: () => calculate('Multiply'), child: const Text('Multiply')),
                ElevatedButton(onPressed: () => calculate('Divide'), child: const Text('Divide')),
              ],
            ),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
