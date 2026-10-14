import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const CounterPage());
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;
  @override
  void initState() { super.initState(); loadCounter(); }
  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => counter = prefs.getInt('counter') ?? 0);
  }
  Future<void> increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => counter++);
    await prefs.setInt('counter', counter);
  }
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => counter = 0);
    await prefs.setInt('counter', 0);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Q5 - Saved Counter')),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Counter', style: TextStyle(fontSize: 22)),
      Text('$counter', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16), ElevatedButton(onPressed: increment, child: const Text('Increment')),
      OutlinedButton(onPressed: reset, child: const Text('Reset')),
    ])),
  );
}
