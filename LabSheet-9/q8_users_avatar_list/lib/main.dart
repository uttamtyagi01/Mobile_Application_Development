import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: UsersAvatarPage(), debugShowCheckedModeBanner: false));
Future<List<dynamic>> fetchUsers() async { final r = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users')); if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}'); return jsonDecode(r.body) as List<dynamic>; }
class UsersAvatarPage extends StatelessWidget { const UsersAvatarPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q8: Users and CircleAvatar')), body: FutureBuilder<List<dynamic>>(future: fetchUsers(), builder: (context, s) { if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator()); if (s.hasError) return Center(child: Text('Error loading users: ${s.error}')); final users = s.data!; return ListView.builder(itemCount: users.length, itemBuilder: (context, i) { final u = users[i] as Map<String, dynamic>; return ListTile(leading: CircleAvatar(child: Text('${u['name']}'.substring(0, 1))), title: Text('${u['name']}'), subtitle: Text('${u['email']}'), trailing: const Icon(Icons.chevron_right)); }); }));
}
