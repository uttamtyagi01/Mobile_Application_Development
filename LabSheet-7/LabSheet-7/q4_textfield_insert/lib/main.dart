import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;


void main() => runApp(const LabApp());
class LabApp extends StatelessWidget { const LabApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, title:'LabSheet 7 Q4', theme:ThemeData(colorSchemeSeed:Colors.indigo,useMaterial3:true), home:const ExercisePage()); }
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
    final path = p.join(await getDatabasesPath(), 'labsheet7_q4.db');
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
  Future<void> _perform() async {
    if (_formKey.currentState?.validate() != true || _db == null) return;
    await _db!.insert('students', {'name':_name.text.trim(),'roll':_roll.text.trim(),'course':_courseText.text.trim()});
    _name.clear(); _roll.clear(); _courseText.clear(); await _load();
    if (mounted) setState(() => _status = 'Student inserted successfully');
  }
  @override void dispose() { _name.dispose(); _roll.dispose(); _courseText.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('LabSheet-7 Q4: Insert using TextFields')), body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[TextFormField(controller:_name, decoration:const InputDecoration(labelText:'Student name'), validator:(v)=>v==null||v.trim().isEmpty?'Enter name':null), TextFormField(controller:_roll, decoration:const InputDecoration(labelText:'Roll number'), validator:(v)=>v==null||v.trim().isEmpty?'Enter roll number':null), TextFormField(controller:_courseText, decoration:const InputDecoration(labelText:'Course'), validator:(v)=>v==null||v.trim().isEmpty?'Enter course':null), const SizedBox(height:8), FilledButton(onPressed:()=>_perform(), child:const Text('Add student')), Text(_status), const Divider(), Expanded(child:ListView.builder(itemCount:_rows.length,itemBuilder:(context,i){final row=_rows[i];return ListTile(title:Text('${row['name']}'),subtitle:Text('Roll: ${row['roll']} • ${row['course']}'),trailing:null, onTap:null);}))])));
}
