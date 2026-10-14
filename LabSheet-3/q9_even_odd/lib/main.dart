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
      home: const EvenOddScreen(),
    );
  }
}

class EvenOddScreen extends StatefulWidget {
  const EvenOddScreen({super.key});

  @override
  State<EvenOddScreen> createState() => _EvenOddScreenState();
}

class _EvenOddScreenState extends State<EvenOddScreen> {
  final TextEditingController numberController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  void checkNumber() {
    final int? number = int.tryParse(numberController.text);

    setState(() {
      if (number == null) {
        result = 'Please enter a valid number';
      } else {
        result = number % 2 == 0 ? 'Even' : 'Odd';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q9 Even or Odd')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: checkNumber, child: const Text('Check')),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
