import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MaterialApp(home: RawResponsePage(), debugShowCheckedModeBanner: false));
class RawResponsePage extends StatefulWidget { const RawResponsePage({super.key}); @override State<RawResponsePage> createState() => _RawResponsePageState(); }
class _RawResponsePageState extends State<RawResponsePage> {
  String responseText = ''; bool loading = false; String? error;
  Future<void> fetch() async { setState(() { loading = true; error = null; }); try { final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')).timeout(const Duration(seconds: 15)); if (res.statusCode != 200) throw Exception('HTTP status ${res.statusCode}'); if (!mounted) return; setState(() => responseText = res.body); } catch (e) { if (mounted) setState(() => error = e.toString()); } finally { if (mounted) setState(() => loading = false); } }
  @override void initState() { super.initState(); fetch(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Q3: http.get response')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [FilledButton.icon(onPressed: loading ? null : fetch, icon: const Icon(Icons.download), label: const Text('Fetch response')), const SizedBox(height: 12), if (loading) const LinearProgressIndicator(), if (error != null) Text('Error: $error'), Expanded(child: SingleChildScrollView(child: SelectableText(responseText.isEmpty ? 'Response body will appear here.' : responseText)))])));
}
