import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: SinglePostPage(), debugShowCheckedModeBanner: false));
class SinglePostPage extends StatefulWidget { const SinglePostPage({super.key}); @override State<SinglePostPage> createState() => _SinglePostPageState(); }
class _SinglePostPageState extends State<SinglePostPage> {
  Map<String, dynamic>? post; bool loading = true; String? error;
  Future<void> fetch() async { setState(() { loading = true; error = null; }); try { final r = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')); if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}'); final data = jsonDecode(r.body) as Map<String, dynamic>; if (mounted) setState(() => post = data); } catch (e) { if (mounted) setState(() => error = e.toString()); } finally { if (mounted) setState(() => loading = false); } }
  @override void initState() { super.initState(); fetch(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q4: Single post Card')), body: Center(child: loading ? const CircularProgressIndicator() : error != null ? Column(mainAxisSize: MainAxisSize.min, children: [Text('Could not load post: $error'), ElevatedButton(onPressed: fetch, child: const Text('Retry'))]) : Card(margin: const EdgeInsets.all(20), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Post #${post!['id']}', style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 8), Text('${post!['title']}', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 12), Text('${post!['body']}')])))));
}
