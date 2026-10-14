import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;
  @override
  void initState() { super.initState(); loadTheme(); }
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => darkMode = prefs.getBool('darkMode') ?? false);
  }
  Future<void> changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => darkMode = value);
    await prefs.setBool('darkMode', value);
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(useMaterial3: true),
    darkTheme: ThemeData.dark(useMaterial3: true),
    themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
    home: Scaffold(
      appBar: AppBar(title: const Text('Q6 - Dark Mode')),
      body: Center(child: SwitchListTile(title: const Text('Dark Mode'), subtitle: Text(darkMode ? 'ON' : 'OFF'), value: darkMode, onChanged: changeTheme)),
    ),
  );
}
