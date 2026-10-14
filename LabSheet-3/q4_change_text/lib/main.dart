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
      home: const ChangeTextScreen(),
    );
  }
}

class ChangeTextScreen extends StatefulWidget {
  const ChangeTextScreen({super.key});

  @override
  State<ChangeTextScreen> createState() => _ChangeTextScreenState();
}

class _ChangeTextScreenState extends State<ChangeTextScreen> {
  String message = 'Hello Flutter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Q4 Change Text')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = 'Button Pressed!';
                });
              },
              child: const Text('Change Text'),
            ),
          ],
        ),
      ),
    );
  }
}
