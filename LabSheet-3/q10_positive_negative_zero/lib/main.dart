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
      home: const NumberScreen(),
    );
  }
}

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final TextEditingController numberController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  void checkNumber() {
    final double? number = double.tryParse(numberController.text);

    setState(() {
      if (number == null) {
        result = 'Please enter a valid number';
      } else if (number > 0) {
        result = 'Positive';
      } else if (number < 0) {
        result = 'Negative';
      } else {
        result = 'Zero';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q10 Positive Negative Zero')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: numberController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(
                labelText: 'Enter Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: checkNumber, child: const Text('Check Number')),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
