import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: PostsPage(), debugShowCheckedModeBanner: false));

class Post {
  final int id;
  final String title;
  final String body;
  const Post({required this.id, required this.title, required this.body});
  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});
  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> futurePosts;
  final search = TextEditingController();

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode != 200) throw Exception('Server returned ${response.statusCode}');
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.map((item) => Post.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  void initState() { super.initState(); futurePosts = fetchPosts(); }
  @override
  void dispose() { search.dispose(); super.dispose(); }

  void retry() => setState(() => futurePosts = fetchPosts());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Labsheet 9: REST API'), actions: [IconButton(onPressed: retry, icon: const Icon(Icons.refresh))]),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: TextField(controller: search, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search post title', border: OutlineInputBorder()))),
      Expanded(child: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Could not load posts.\n${snapshot.error}', textAlign: TextAlign.center),
            const SizedBox(height: 12), ElevatedButton(onPressed: retry, child: const Text('Retry')),
          ])));
          final query = search.text.trim().toLowerCase();
          final posts = snapshot.data!.where((p) => p.title.toLowerCase().contains(query)).toList();
          return RefreshIndicator(onRefresh: () async { retry(); await futurePosts; }, child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(child: ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(post.title),
                subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => showDialog<void>(context: context, builder: (context) => AlertDialog(title: Text(post.title), content: Text(post.body), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))])),
              ));
            },
          ));
        },
      )),
    ]),
  );
}
