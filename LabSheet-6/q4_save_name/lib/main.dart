import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const NamePage());
}

class NamePage extends StatefulWidget {
  const NamePage({super.key});
  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final controller = TextEditingController();
  String savedName = 'No name saved';
  @override
  void initState() { super.initState(); loadName(); }
  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => savedName = prefs.getString('userName') ?? 'No name saved');
  }
  Future<void> saveName() async {
    final name = controller.text.trim();
    if (name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    controller.clear();
    await loadName();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Q4 - Save User Name')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: controller, decoration: const InputDecoration(labelText: 'Enter name', border: OutlineInputBorder())),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: saveName, child: const Text('Save Name'))),
      const SizedBox(height: 24), Text('Saved Name: $savedName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ])),
  );
  @override
  void dispose() { controller.dispose(); super.dispose(); }
}
