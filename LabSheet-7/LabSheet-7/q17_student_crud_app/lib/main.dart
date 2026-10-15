import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;


void main() => runApp(const LabApp());
class LabApp extends StatelessWidget { const LabApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, title:'LabSheet 7 Q17', theme:ThemeData(colorSchemeSeed:Colors.indigo,useMaterial3:true), home:const ExercisePage()); }
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
    final path = p.join(await getDatabasesPath(), 'labsheet7_q17.db');
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
    final name = _name.text.trim(), roll = _roll.text.trim(), course = _courseText.text.trim();
    if (name.isEmpty || roll.isEmpty || course.isEmpty) { setState(() => _status = 'Fill all fields'); return; }
    await _db!.insert('students', {'name':name,'roll':roll,'course':course}); _name.clear(); _roll.clear(); _courseText.clear(); await _load();
    if (mounted) setState(() => _status = 'Student added');
  }
  Future<void> _delete(Map<String,Object?> row) async { await _db!.delete('students', where:'id = ?', whereArgs:[row['id']]); await _load(); }
  Future<void> _edit(Map<String,Object?> row) async { final c=TextEditingController(text:'${row['name']}'); final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Edit name'),content:TextField(controller:c),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Save'))])); if(ok==true){await _db!.update('students',{'name':c.text.trim()},where:'id = ?',whereArgs:[row['id']]);await _load();} c.dispose(); }
  @override void dispose() { _name.dispose(); _roll.dispose(); _courseText.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('LabSheet-7 Q17: Student CRUD manager')), body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[TextFormField(controller:_name, decoration:const InputDecoration(labelText:'Student name'), validator:(v)=>v==null||v.trim().isEmpty?'Enter name':null), TextFormField(controller:_roll, decoration:const InputDecoration(labelText:'Roll number'), validator:(v)=>v==null||v.trim().isEmpty?'Enter roll number':null), TextFormField(controller:_courseText, decoration:const InputDecoration(labelText:'Course'), validator:(v)=>v==null||v.trim().isEmpty?'Enter course':null), const SizedBox(height:8), FilledButton(onPressed:()=>_perform(), child:const Text('Add student')), Text(_status), const Divider(), Expanded(child:ListView.builder(itemCount:_rows.length,itemBuilder:(context,i){final row=_rows[i];return ListTile(title:Text('${row['name']}'),subtitle:Text('Roll: ${row['roll']} • ${row['course']}'),trailing:Row(mainAxisSize:MainAxisSize.min,children:[IconButton(icon:const Icon(Icons.edit),onPressed:()=>_edit(row)),IconButton(icon:const Icon(Icons.delete_outline),onPressed:()=>_delete(row))]));}))])));
}
