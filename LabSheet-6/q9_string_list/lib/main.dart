import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const SubjectPage());
}

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});
  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final controller = TextEditingController();
  List<String> subjects = [];
  @override
  void initState() { super.initState(); loadSubjects(); }
  Future<void> loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => subjects = prefs.getStringList('subjects') ?? []);
  }
  Future<void> addSubject() async {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    setState(() => subjects.add(value));
    controller.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('subjects', subjects);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Q9 - Favourite Subjects')),
    body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Row(children: [Expanded(child: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()))), const SizedBox(width: 8), ElevatedButton(onPressed: addSubject, child: const Text('Add'))]),
      const SizedBox(height: 16),
      Expanded(child: subjects.isEmpty ? const Center(child: Text('No subjects saved')) : ListView.builder(itemCount: subjects.length, itemBuilder: (context, i) => Card(child: ListTile(leading: const Icon(Icons.book), title: Text(subjects[i]))))),
    ])),
  );
  @override
  void dispose() { controller.dispose(); super.dispose(); }
}
