import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: LoadingDemoPage(), debugShowCheckedModeBanner: false));
class LoadingDemoPage extends StatefulWidget { const LoadingDemoPage({super.key}); @override State<LoadingDemoPage> createState() => _LoadingDemoPageState(); }
class _LoadingDemoPageState extends State<LoadingDemoPage> { bool loading = false; String title = 'Press Fetch to load an API post.'; String? error;
 Future<void> fetch() async { setState(() { loading = true; error = null; }); try { final r = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/2')); if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}'); final data = jsonDecode(r.body) as Map<String, dynamic>; if (mounted) setState(() => title = '${data['title']}\n\n${data['body']}'); } catch (e) { if (mounted) setState(() => error = '$e'); } finally { if (mounted) setState(() => loading = false); } }
 @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q5: Loading indicator')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [if (loading) const CircularProgressIndicator(), if (loading) const SizedBox(height: 20), if (error != null) Text('Error: $error'), Text(title, textAlign: TextAlign.center), const SizedBox(height: 20), FilledButton(onPressed: loading ? null : fetch, child: const Text('Fetch API data'))])))); }
