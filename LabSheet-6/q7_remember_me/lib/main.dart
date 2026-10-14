import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  @override
  void initState() { super.initState(); loadLoginData(); }
  Future<void> loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('rememberMe') ?? false;
    if (!mounted) return;
    setState(() {
      rememberMe = saved;
      if (saved) {
        usernameController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('username', usernameController.text.trim());
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(rememberMe ? 'Login details saved' : 'Remember Me disabled')));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Q7 - Remember Me')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
      const SizedBox(height: 12),
      TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
      CheckboxListTile(contentPadding: EdgeInsets.zero, title: const Text('Remember Me'), value: rememberMe, onChanged: (v) => setState(() => rememberMe = v ?? false)),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: login, child: const Text('Login'))),
    ])),
  );
  @override
  void dispose() { usernameController.dispose(); passwordController.dispose(); super.dispose(); }
}
