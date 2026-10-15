import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: PostsPage(), debugShowCheckedModeBanner: false));
Future<List<dynamic>> fetchPosts() async { final r = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')); if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}'); return jsonDecode(r.body) as List<dynamic>; }
class PostsPage extends StatefulWidget { const PostsPage({super.key}); @override State<PostsPage> createState() => _PostsPageState(); }
class _PostsPageState extends State<PostsPage> { late Future<List<dynamic>> posts; @override void initState() { super.initState(); posts = fetchPosts(); } @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q7: Posts ListView.builder')), body: FutureBuilder<List<dynamic>>(future: posts, builder: (context, s) { if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator()); if (s.hasError) return Center(child: TextButton(onPressed: () => setState(() => posts = fetchPosts()), child: Text('Error: ${s.error} — Retry'))); final list = s.data!; return ListView.builder(itemCount: list.length, itemBuilder: (context, i) => ListTile(leading: CircleAvatar(child: Text('${list[i]['id']}')), title: Text('${list[i]['title']}'), subtitle: Text('${list[i]['body']}', maxLines: 2, overflow: TextOverflow.ellipsis))); }));
}
