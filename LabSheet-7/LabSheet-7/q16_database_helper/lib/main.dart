import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'labsheet7_q16.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, roll TEXT NOT NULL, course TEXT NOT NULL)');
    });
    return _db!;
  }
  Future<int> insert(Map<String, Object?> row) async => (await database).insert('students', row);
  Future<List<Map<String, Object?>>> all() async => (await database).query('students', orderBy: 'name COLLATE NOCASE');
  Future<int> update(int id, Map<String, Object?> row) async => (await database).update('students', row, where: 'id = ?', whereArgs: [id]);
  Future<int> delete(int id) async => (await database).delete('students', where: 'id = ?', whereArgs: [id]);
}

void main() => runApp(const LabApp());
class LabApp extends StatelessWidget { const LabApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, title:'LabSheet 7 Q16', theme:ThemeData(colorSchemeSeed:Colors.indigo,useMaterial3:true), home:const ExercisePage()); }
class ExercisePage extends StatefulWidget { const ExercisePage({super.key}); @override State<ExercisePage> createState()=>_ExercisePageState(); }
class _ExercisePageState extends State<ExercisePage> {
  final DatabaseHelper _helper = DatabaseHelper();
  String _status = 'Preparing SQLite…';
  List<Map<String,Object?>> _rows = [];
  int _count = 0;
  List<Student> _students = [];
  String _filter = '';
  String _selectedCourse = 'All';
  final _name = TextEditingController(); final _roll = TextEditingController(); final _courseText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override void initState() { super.initState(); _openDatabase(); }
  Future<void> _openDatabase() async { await _helper.database; await _load(); if(mounted)setState(()=>_status='DatabaseHelper is ready'); }
  Future<void> _prepare() async {}
  Future<void> _load() async { final r=await _helper.all(); if(mounted)setState(()=>_rows=r); }
  Future<void> _perform() async { await _helper.insert({'name':'Nisha Gupta','roll':'105','course':'Flutter'}); await _load(); }
  Future<void> _delete(Map<String,Object?> row) async { await _helper.delete(row['id'] as int); await _load(); }
  @override void dispose() { _name.dispose(); _roll.dispose(); _courseText.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('LabSheet-7 Q16: DatabaseHelper class')), body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[FilledButton.icon(onPressed:()=>_load(), icon:const Icon(Icons.refresh), label:const Text('Run query')), const SizedBox(height:8), Text(_status), const Divider(), Expanded(child:ListView.builder(itemCount:_rows.length,itemBuilder:(context,i){final r=_rows[i];return ListTile(title:Text('${r['name']}'),subtitle:Text('${r['roll']} • ${r['course']}'),trailing:IconButton(icon:const Icon(Icons.delete_outline),onPressed:()=>_delete(r));}))])));
}
