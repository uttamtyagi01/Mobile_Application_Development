import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;


void main() => runApp(const LabApp());
class LabApp extends StatelessWidget { const LabApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, title:'LabSheet 7 Q8', theme:ThemeData(colorSchemeSeed:Colors.indigo,useMaterial3:true), home:const ExercisePage()); }
class ExercisePage extends StatefulWidget { const ExercisePage({super.key}); @override State<ExercisePage> createState()=>_ExercisePageState(); }
class _ExercisePageState extends State<ExercisePage> {
  Database? _db;
  String _status = 'Preparing SQLite…';
  List<Map<String,Object?>> _rows = [];
  int _count = 0;
  List<Student> _students = [];
  String _filter = '';
  String _selectedCourse = 'All';
  final _name = TextEditingController(); final _roll = TextEditingController(); final _courseText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override void initState() { super.initState(); _openDatabase(); }
  Future<void> _openDatabase() async {
    final path = p.join(await getDatabasesPath(), 'labsheet7_q8.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, roll TEXT NOT NULL, course TEXT NOT NULL)');
    });
    await _prepare();
    await _load();
    if (mounted) setState(() => _status = 'SQLite ready');
  }

  Future<void> _prepare() async {
    final count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM students')) ?? 0;
    if (count == 0) await _db!.insert('students', {'name':'Aarav Sharma','roll':'101','course':'Flutter'});
  }
  Future<void> _load() async { if (_db == null) return; final r = await _db!.query('students', orderBy:'id DESC'); if (mounted) setState(() => _rows = r); }
  Future<void> _perform(Map<String,Object?> row) async {
    final name = TextEditingController(text: '${row['name']}');
    final course = TextEditingController(text: '${row['course']}');
    final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Update student'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller:name, decoration:const InputDecoration(labelText:'Name')), TextField(controller:course, decoration:const InputDecoration(labelText:'Course'))]), actions: [TextButton(onPressed:()=>Navigator.pop(c,false), child:const Text('Cancel')), FilledButton(onPressed:()=>Navigator.pop(c,true), child:const Text('Save'))]));
    if (ok == true) { await _db!.update('students', {'name':name.text.trim(),'course':course.text.trim()}, where:'id = ?', whereArgs:[row['id']]); await _load(); }
    name.dispose(); course.dispose();
  }
  @override void dispose() { _name.dispose(); _roll.dispose(); _courseText.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('LabSheet-7 Q8: Update a student')), body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[const Text('Tap a student row to update name and course.'), const SizedBox(height:8), Text(_status), const Divider(), Expanded(child:ListView.builder(itemCount:_rows.length,itemBuilder:(context,i){final row=_rows[i];return ListTile(title:Text('${row['name']}'),subtitle:Text('Roll: ${row['roll']} • ${row['course']}'),trailing:IconButton(icon:const Icon(Icons.edit), onPressed:()=>_perform(row)), onTap:()=>_perform(row));}))])));
}
