import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'LabSheet-8 Q9: Total Expense',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const RecordsPage(),
  );
}

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});
  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  Database? db;
  final first = TextEditingController();
  final second = TextEditingController();
  final third = TextEditingController();
  final search = TextEditingController();
  List<Map<String, Object?>> rows = [];
  bool loading = true;
  String query = '';
  static const table = 'expenses';
  static const question = 9;

  @override
  void initState() { super.initState(); _initDb(); }
  Future<void> _initDb() async {
    final path = p.join(await getDatabasesPath(), 'labsheet8_q9.db');
    db = await openDatabase(path, version: 1, onCreate: (database, version) async {
      await database.execute('CREATE TABLE $table (id INTEGER PRIMARY KEY AUTOINCREMENT, first TEXT NOT NULL, second TEXT NOT NULL, third TEXT NOT NULL, done INTEGER NOT NULL DEFAULT 0)');
    });
    await _load();
    if (mounted) setState(() => loading = false);
  }
  Future<void> _load() async {
    if (db == null) return;
    final result = await db!.query(table, orderBy: 'id DESC');
    if (mounted) setState(() => rows = result.where((r) => ('${r['first']} ${r['second']} ${r['third']}').toLowerCase().contains(query.toLowerCase())).toList());
  }
  Future<void> _add() async {
    if (first.text.trim().isEmpty || second.text.trim().isEmpty) { _message('Please complete the required fields.'); return; }
    if (question == 13 && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(second.text.trim())) { _message('Enter a valid email address.'); return; }
    if ((question == 8 || question == 9 || question == 15 || question == 16) && double.tryParse(second.text.trim()) == null) { _message('Enter a valid numeric value in Amount.'); return; }
    await db!.insert(table, {'first': first.text.trim(), 'second': second.text.trim(), 'third': third.text.trim()});
    first.clear(); second.clear(); third.clear(); await _load();
    if (mounted) Navigator.of(context).maybePop();
    _message('Saved successfully.');
  }
  Future<void> _showEditor([Map<String, Object?>? row]) async {
    first.text = '${row?['first'] ?? ''}'; second.text = '${row?['second'] ?? ''}'; third.text = '${row?['third'] ?? ''}';
    final isEdit = row != null;
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(
      title: Text(isEdit ? 'Edit $plural item' : '$addbtn'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: first, decoration: const InputDecoration(labelText: '$f1')),
        TextField(controller: second, decoration: const InputDecoration(labelText: '$f2'), keyboardType: (question == 8 || question == 9 || question == 15 || question == 16) ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text, obscureText: question == 11 && false),
        TextField(controller: third, decoration: const InputDecoration(labelText: '$f3')),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), FilledButton(onPressed: () async {
        if (first.text.trim().isEmpty || second.text.trim().isEmpty) { _message('Please complete the required fields.'); return; }
        if (question == 13 && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(second.text.trim())) { _message('Enter a valid email address.'); return; }
        if (isEdit) { await db!.update(table, {'first': first.text.trim(), 'second': second.text.trim(), 'third': third.text.trim()}, where: 'id = ?', whereArgs: [row['id']]); }
        else { await db!.insert(table, {'first': first.text.trim(), 'second': second.text.trim(), 'third': third.text.trim()}); }
        if (ctx.mounted) Navigator.pop(ctx); first.clear(); second.clear(); third.clear(); await _load();
      }, child: const Text('Save'))],
    ));
  }
  Future<void> _delete(Map<String, Object?> row) async {
    Future<void> perform() async { await db!.delete(table, where: 'id = ?', whereArgs: [row['id']]); await _load(); }
    if (question == 6) {
      final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Delete contact?'), content: Text('Delete ${row['first']} permanently?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete'))]));
      if (ok == true) await perform();
    } else { await perform(); }
  }
  Future<void> _toggle(Map<String, Object?> row) async { await db!.update(table, {'done': (row['done'] as int? ?? 0) == 1 ? 0 : 1}, where: 'id = ?', whereArgs: [row['id']]); await _load(); }
  void _message(String value) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value))); }

  @override
  void dispose() { first.dispose(); second.dispose(); third.dispose(); search.dispose(); db?.close(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final total = rows.fold<double>(0, (sum, r) => sum + (double.tryParse('${r['second']}') ?? 0));
    return Scaffold(
      appBar: AppBar(title: const Text('Q9. Total Expense'), actions: [IconButton(tooltip: 'Refresh', onPressed: _load, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('The total is calculated from saved expenses.'),
          if (question == 4 || question == 7 || question == 17) ...[
            const SizedBox(height: 8), TextField(controller: search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search', border: OutlineInputBorder()), onChanged: (v) { query = v; _load(); }),
          ],
          if (question == 9 || question == 16) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Total value: ${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium)),
        ])),
        Expanded(child: loading ? const Center(child: CircularProgressIndicator()) : rows.isEmpty ? const Center(child: Text('No records yet. Tap + to add one.')) : ListView.builder(itemCount: rows.length, itemBuilder: (context, index) {
          final row = rows[index];
          final tile = ListTile(
            leading: question == 10 ? Checkbox(value: (row['done'] as int? ?? 0) == 1, onChanged: (_) => _toggle(row)) : CircleAvatar(child: Text('${index + 1}')),
            title: Text('${row['first']}', style: question == 10 && (row['done'] as int? ?? 0) == 1 ? const TextStyle(decoration: TextDecoration.lineThrough) : null),
            subtitle: Text('${row['second']}${('${row['third']}').isNotEmpty ? ' • ${row['third']}' : ''}'),
            onTap: () {
              if (question == 14) { showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: Text('${row['first']}'), content: Text('Roll number: ${row['second']}\nCourse: ${row['third']}'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')), TextButton(onPressed: () { Navigator.pop(ctx); _showEditor(row); }, child: const Text('Edit'))])); }
              else if (question == 2 || question == 17) { _showEditor(row); }
              else if (question == 11 || question == 12) { _message('Local demo record: ${row['first']}'); }
              else { _showEditor(row); }
            },
            trailing: IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Delete', onPressed: () => _delete(row)),
          );
          if (question == 3) return Dismissible(key: ValueKey(row['id']), direction: DismissDirection.horizontal, background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.all(16), child: const Icon(Icons.delete, color: Colors.white)), secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.all(16), child: const Icon(Icons.delete, color: Colors.white)), onDismissed: (_) => _delete(row), child: Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: tile));
          return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: tile);
        })),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showEditor(), icon: const Icon(Icons.add), label: const Text('Add')),
    );
  }
}
