import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: ModelUsersPage(), debugShowCheckedModeBanner: false));
class ApiUser { final int id; final String name, email, phone, website; const ApiUser({required this.id, required this.name, required this.email, required this.phone, required this.website}); factory ApiUser.fromJson(Map<String, dynamic> j) => ApiUser(id: j['id'] as int, name: j['name'] as String, email: j['email'] as String, phone: j['phone'] as String, website: j['website'] as String); }
class ModelUsersPage extends StatelessWidget { const ModelUsersPage({super.key}); Future<List<ApiUser>> fetch() async { final r = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users')); if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}'); return (jsonDecode(r.body) as List).map((e) => ApiUser.fromJson(e as Map<String, dynamic>)).toList(); }
 @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q9: API model fromJson')), body: FutureBuilder<List<ApiUser>>(future: fetch(), builder: (context, s) { if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator()); if (s.hasError) return Center(child: Text('Error: ${s.error}')); final users = s.data!; return ListView.builder(itemCount: users.length, itemBuilder: (context, i) { final u = users[i]; return Card(child: ListTile(title: Text(u.name), subtitle: Text('${u.email}\n${u.phone}\n${u.website}'), isThreeLine: true)); }); }));
}
