import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const UserPage());
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  String display = 'No saved data';
  @override
  void initState() { super.initState(); loadData(); }
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text.trim());
    await prefs.setString('email', emailController.text.trim());
    await prefs.setInt('age', int.tryParse(ageController.text) ?? 0);
    await loadData();
  }
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final n = prefs.getString('name');
    final e = prefs.getString('email');
    final a = prefs.getInt('age');
    setState(() => display = (n == null && e == null && a == null) ? 'No saved data' : 'Name: ${n ?? ''}\nEmail: ${e ?? ''}\nAge: ${a ?? 0}');
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Q8 - Multiple Values')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
      TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
      TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
      const SizedBox(height: 16), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: saveData, child: const Text('Save Details'))),
      const SizedBox(height: 24), Text(display, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
    ])),
  );
  @override
  void dispose() { nameController.dispose(); emailController.dispose(); ageController.dispose(); super.dispose(); }
}
