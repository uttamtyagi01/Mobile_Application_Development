import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: FutureBuilderPage(), debugShowCheckedModeBanner: false));
Future<Map<String, dynamic>> fetchPost() async { final r = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/3')); if (r.statusCode != 200) throw Exception('Request failed: ${r.statusCode}'); return jsonDecode(r.body) as Map<String, dynamic>; }
class FutureBuilderPage extends StatefulWidget { const FutureBuilderPage({super.key}); @override State<FutureBuilderPage> createState() => _FutureBuilderPageState(); }
class _FutureBuilderPageState extends State<FutureBuilderPage> { late Future<Map<String, dynamic>> future; @override void initState() { super.initState(); future = fetchPost(); } void retry() => setState(() => future = fetchPost());
 @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q6: FutureBuilder')), body: FutureBuilder<Map<String, dynamic>>(future: future, builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator()); if (snapshot.hasError) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Error: ${snapshot.error}'), ElevatedButton(onPressed: retry, child: const Text('Retry'))])); final post = snapshot.data!; return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${post['title']}', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 12), Text('${post['body']}'), const SizedBox(height: 20), OutlinedButton(onPressed: retry, child: const Text('Reload'))])); }));
}
