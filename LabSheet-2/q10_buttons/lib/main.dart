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
      home: Scaffold(
        appBar: AppBar(title: const Text('Q10 Buttons')),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
