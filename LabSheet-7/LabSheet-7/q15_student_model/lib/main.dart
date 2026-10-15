import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Student {
  final int? id; final String name, roll, course;
  const Student({this.id, required this.name, required this.roll, required this.course});
  factory Student.fromMap(Map<String, Object?> m) => Student(id: m['id'] as int?, name: '${m['name'] ?? ''}', roll: '${m['roll'] ?? ''}', course: '${m['course'] ?? ''}');
  Map<String, Object?> toMap() => {'name': name, 'roll': roll, 'course': course};
}

void main() => runApp(const LabApp());
class LabApp extends StatelessWidget { const LabApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, title:'LabSheet 7 Q15', theme:ThemeData(colorSchemeSeed:Colors.indigo,useMaterial3:true), home:const ExercisePage()); }
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
    final path = p.join(await getDatabasesPath(), 'labsheet7_q15.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, roll TEXT NOT NULL, course TEXT NOT NULL)');
    });
    await _prepare();
    await _load();
    if (mounted) setState(() => _status = 'SQLite ready');
  }

  Future<void> _prepare() async {
    final count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM students')) ?? 0;
    if (count == 0) {
      await _db!.insert('students', {'name':'Aarav Sharma','roll':'101','course':'Flutter'});
      await _db!.insert('students', {'name':'Diya Verma','roll':'102','course':'Database'});
      await _db!.insert('students', {'name':'Kabir Singh','roll':'103','course':'Flutter'});
    }
  }
  Future<void> _load() async { if (_db == null) return; final r = await _db!.query('students'); if (mounted) setState(() => _students = r.map((e) => Student.fromMap(e)).toList()); }
  Future<void> _perform() async {
    await _load();
    if (mounted) setState(() => _status = 'Data refreshed');
  }
  @override void dispose() { _name.dispose(); _roll.dispose(); _courseText.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('LabSheet-7 Q15: Student model')), body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[FilledButton.icon(onPressed:()=>_load(), icon:const Icon(Icons.refresh), label:const Text('Run query')), const SizedBox(height:8), Text(_status), const Divider(), Expanded(child:ListView.builder(itemCount:_students.length, itemBuilder:(context,i){final s=_students[i];return ListTile(leading:CircleAvatar(child:Text('${s.roll}')),title:Text(s.name),subtitle:Text('${s.course} • model object'));}))])));
}
