import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const ClearDataPage());
}

class ClearDataPage extends StatefulWidget {
  const ClearDataPage({super.key});
  @override
  State<ClearDataPage> createState() => _ClearDataPageState();
}

class _ClearDataPageState extends State<ClearDataPage> {
  final controller = TextEditingController();
  String savedName = 'No data saved';
  @override
  void initState() { super.initState(); loadName(); }
  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => savedName = prefs.getString('name') ?? 'No data saved');
  }
  Future<void> saveName() async {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', value);
    controller.clear();
    await loadName();
  }
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() => savedName = 'No data saved');
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Q10 - Clear SharedPreferences')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: controller, decoration: const InputDecoration(labelText: 'Enter name', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      Row(children: [Expanded(child: ElevatedButton(onPressed: saveName, child: const Text('Save'))), const SizedBox(width: 10), Expanded(child: OutlinedButton(onPressed: clearData, child: const Text('Clear')))]),
      const SizedBox(height: 30), Text('Stored value: $savedName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ])),
  );
  @override
  void dispose() { controller.dispose(); super.dispose(); }
}
