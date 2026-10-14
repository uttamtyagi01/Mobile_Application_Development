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
        appBar: AppBar(title: const Text('Q6 Text Image Icon')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Fresh Food',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.network(
                'https://picsum.photos/250/160',
                width: 250,
                height: 160,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Icon(Icons.restaurant, size: 55),
            ],
          ),
        ),
      ),
    );
  }
}
