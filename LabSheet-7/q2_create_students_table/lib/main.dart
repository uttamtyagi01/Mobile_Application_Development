import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'LabSheet-7 Q2',
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
  Database? _db;
  final _first = TextEditingController();
  final _second = TextEditingController();
  final _third = TextEditingController();
  List<Map<String, Object?>> _rows = [];
  String _filter = '';
  String _course = 'All';
  String _message = 'Ready';
  static const _table = 'records';

  @override
  void initState() { super.initState(); _openDb(); }
  Future<void> _openDb() async {
    final path = p.join(await getDatabasesPath(), 'labsheet_7_2.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE records(id INTEGER PRIMARY KEY AUTOINCREMENT, first TEXT NOT NULL, second TEXT NOT NULL, third TEXT NOT NULL)');
    });
    await _seedIfNeeded();
    await _load();
    if (mounted) setState(() => _message = 'SQLite database and table are ready');
  }
  Future<void> _seedIfNeeded() async {
    final count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM records')) ?? 0;
    if (count == 0 && true) {
      await _db!.insert(_table, {'first':'Demo Record','second':'1001','third':'Computer Science'});
    }
  }
  Future<void> _load() async {
    if (_db == null) return;
    List<Map<String,Object?>> result;
    if ('normal' == 'rawQuery') {
      result = await _db!.rawQuery('SELECT * FROM records ORDER BY first ASC');
    } else if ('normal' == 'count') {
      final count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM records')) ?? 0;
      result = [{'id':0,'first':'Total records','second':'$count','third':'records'}];
    } else if ('normal' == 'sum') {
      final total = Sqflite.firstIntValue(await _db!.rawQuery("SELECT CAST(COALESCE(SUM(CAST(second AS REAL)),0) AS INTEGER) FROM records")) ?? 0;
      result = [{'id':0,'first':'Total amount','second':'$total','third':'sum'}];
    } else if ('normal' == 'search') {
      result = await _db!.query(_table, where: 'first LIKE ?', whereArgs: ['%$_filter%'], orderBy: 'first ASC');
    } else if ('normal' == 'roll') {
      result = await _db!.query(_table, where: 'second = ?', whereArgs: [_filter], orderBy: 'first ASC');
    } else if ('normal' == 'course') {
      result = _course == 'All' ? await _db!.query(_table) : await _db!.query(_table, where: 'third = ?', whereArgs: [_course]);
    } else {
      result = await _db!.query(_table, orderBy: 'normal' == 'orderBy' ? 'first ASC' : 'id DESC');
    }
    if (mounted) setState(() => _rows = result);
  }
  Future<void> _save() async {
    final a = _first.text.trim(), b = _second.text.trim(), c = _third.text.trim();
    if (a.isEmpty || b.isEmpty) { _toast('Please fill the first two fields'); return; }
    if (_db == null) return;
    if ('normal' == 'rawInsert') {
      await _db!.rawInsert('INSERT INTO records(first, second, third) VALUES(?, ?, ?)', [a,b,c]);
    } else {
      await _db!.insert(_table, {'first':a,'second':b,'third':c});
    }
    _first.clear(); _second.clear(); _third.clear();
    await _load(); _toast('Record saved successfully');
  }
  Future<void> _edit(Map<String,Object?> row) async {
    final a = TextEditingController(text: '${row['first'] ?? ''}');
    final b = TextEditingController(text: '${row['second'] ?? ''}');
    final c = TextEditingController(text: '${row['third'] ?? ''}');
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Update record'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller:a, decoration: const InputDecoration(labelText:'Name / title')), TextField(controller:b, decoration: const InputDecoration(labelText:'Roll / detail')), TextField(controller:c, decoration: const InputDecoration(labelText:'Course / extra'))]),
      actions: [TextButton(onPressed:()=>Navigator.pop(ctx,false), child:const Text('Cancel')), FilledButton(onPressed:()=>Navigator.pop(ctx,true), child:const Text('Save'))],));
    if (ok == true && _db != null) { await _db!.update(_table, {'first':a.text,'second':b.text,'third':c.text}, where:'id = ?', whereArgs:[row['id']]); await _load(); _toast('Updated'); }
  }
  Future<void> _delete(Map<String,Object?> row) async {
    if (_db == null) return;
    await _db!.delete(_table, where:'id = ?', whereArgs:[row['id']]); await _load(); _toast('Record deleted');
  }
  Future<void> _clear() async { await _db?.delete(_table); await _load(); _toast('All records cleared'); }
  void _toast(String s) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(s))); }
  @override
  void dispose() { _first.dispose(); _second.dispose(); _third.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('LabSheet-7 Q2'), actions: [if (false) IconButton(tooltip:'Clear all', onPressed:_clear, icon:const Icon(Icons.delete_sweep))]),
    body: _db == null ? const Center(child:CircularProgressIndicator()) : Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment:CrossAxisAlignment.stretch, children: [
      Text('Create a Flutter application to create a students table (id, name, roll number, and course) in an SQLite database.', style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height:8),
      if (false) ...[
        TextField(controller:_first, decoration:InputDecoration(labelText:'Name', border:const OutlineInputBorder())), const SizedBox(height:8),
        TextField(controller:_second, decoration:InputDecoration(labelText:'Roll number', border:const OutlineInputBorder())), const SizedBox(height:8),
        TextField(controller:_third, decoration:InputDecoration(labelText:'Course (optional)', border:const OutlineInputBorder())), const SizedBox(height:8),
        FilledButton.icon(onPressed:_save, icon:const Icon(Icons.add), label:const Text('Insert record')),
      ],
      if ('normal' == 'search' || 'normal' == 'roll') ...[
        TextField(onChanged:(v){_filter=v; _load();}, decoration:InputDecoration(labelText: 'normal' == 'roll' ? 'Search by roll / detail' : 'Search by name / title', prefixIcon:const Icon(Icons.search), border:const OutlineInputBorder())), const SizedBox(height:8),
      ],
      if ('normal' == 'course') ...[
        DropdownButton<String>(value:_course, isExpanded:true, items:const ['All','Computer Science','IT','BCA'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged:(v){if(v!=null){setState(()=>_course=v);_load();}}),
      ],
      Text(_message, style:Theme.of(context).textTheme.labelMedium), const SizedBox(height:8),
      Expanded(child: _rows.isEmpty ? const Center(child:Text('No records found')) : ListView.builder(itemCount:_rows.length, itemBuilder:(context,i){final row=_rows[i]; return Dismissible(key:ValueKey(row['id']), direction: false ? DismissDirection.endToStart : DismissDirection.none, onDismissed:(_)=>_delete(row), background:Container(color:Colors.red, alignment:Alignment.centerRight, padding:const EdgeInsets.all(16), child:const Icon(Icons.delete,color:Colors.white)), child:Card(child:ListTile(title:Text('${row['first'] ?? ''}'), subtitle:Text('${row['second'] ?? ''}  ${row['third'] ?? ''}'), leading:CircleAvatar(child:Text('${row['id'] ?? ''}')), onTap:()=>_edit(row), trailing:IconButton(icon:const Icon(Icons.delete_outline), onPressed:()=>_delete(row))))); })),
    ])),
  );
}
