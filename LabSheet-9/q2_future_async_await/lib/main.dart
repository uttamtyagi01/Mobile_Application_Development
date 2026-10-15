import 'package:flutter/material.dart';
import 'dart:async';
void main() => runApp(const MaterialApp(home: FutureDemoPage(), debugShowCheckedModeBanner: false));

Future<String> loadMessage() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Data returned after a 2-second delay.';
}
class FutureDemoPage extends StatefulWidget { const FutureDemoPage({super.key}); @override State<FutureDemoPage> createState() => _FutureDemoPageState(); }
class _FutureDemoPageState extends State<FutureDemoPage> {
  String message = 'Tap the button to run the async function.'; bool loading = false;
  Future<void> runDemo() async { setState(() { loading = true; message = 'Waiting for Future...'; }); final result = await loadMessage(); if (!mounted) return; setState(() { message = result; loading = false; }); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q2: Future, async, await')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [if (loading) const CircularProgressIndicator(), Text(message, textAlign: TextAlign.center), const SizedBox(height: 16), FilledButton(onPressed: loading ? null : runDemo, child: const Text('Run async function'))]))));
}
