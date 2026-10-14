import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Student Record Management App',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const StudentPage(),
  );
}

class Student {
  final int? id;
  final String name, rollNumber, course;
  const Student({this.id, required this.name, required this.rollNumber, required this.course});
  Map<String, Object?> toMap() => {'id': id, 'name': name, 'roll_number': rollNumber, 'course': course};
  factory Student.fromMap(Map<String, Object?> m) => Student(
    id: m['id'] as int?, name: m['name'] as String,
    rollNumber: m['roll_number'] as String, course: m['course'] as String);
}

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = p.join(await getDatabasesPath(), 'students.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, roll_number TEXT NOT NULL UNIQUE, course TEXT NOT NULL)");
    });
    return _database!;
  }
  Future<int> insert(Student s) async => (await database).insert('students', s.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  Future<int> rawInsert(Student s) async => (await database).rawInsert(
    'INSERT OR REPLACE INTO students(name, roll_number, course) VALUES(?, ?, ?)',
    [s.name, s.rollNumber, s.course]);
  Future<List<Student>> read({String? course, String? orderBy, bool raw = false}) async {
    final db = await database;
    final rows = raw ? await db.rawQuery('SELECT * FROM students ORDER BY id') :
      await db.query('students', where: course == null ? null : 'course = ?',
        whereArgs: course == null ? null : [course], orderBy: orderBy);
    return rows.map(Student.fromMap).toList();
  }
  Future<int> update(Student s) async => (await database).update('students',
    {'name': s.name, 'roll_number': s.rollNumber, 'course': s.course},
    where: 'id = ?', whereArgs: [s.id]);
  Future<int> delete(int id) async => (await database).delete('students', where: 'id = ?', whereArgs: [id]);
  Future<int> clear() async => (await database).delete('students');
  Future<int> count() async {
    final rows = await (await database).rawQuery('SELECT COUNT(*) AS total FROM students');
    return Sqflite.firstIntValue(rows) ?? 0;
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});
  @override
  State<StudentPage> createState() => _StudentPageState();
}
class _StudentPageState extends State<StudentPage> {
  final db = DatabaseHelper.instance;
  final name = TextEditingController();
  final roll = TextEditingController();
  final courseText = TextEditingController(text: 'BCA');
  final search = TextEditingController();
  List<Student> students = [];
  String? selectedCourse;
  String message = 'Ready';
  int total = 0;

  @override
  void initState() { super.initState(); _setup(); }
  Future<void> _setup() async {
    await db.database;
    if ('management' == 'insert') await db.insert(const Student(name: 'Aarav Sharma', rollNumber: '101', course: 'BCA'));
    if ('management' == 'rawinsert') await db.rawInsert(const Student(name: 'Aarav Sharma', rollNumber: '101', course: 'BCA'));
    await _refresh();
    if ('management' == 'create') message = 'SQLite database created successfully!';
    if ('management' == 'table') message = 'Students table created successfully!';
    if ('management' == 'insert' || 'management' == 'rawinsert') message = 'Sample record inserted (if not already present).';
    if (mounted) setState(() {});
  }
  Future<void> _refresh() async {
    final rows = await db.read(
      course: 'management' == 'course' ? selectedCourse : null,
      orderBy: 'management' == 'sort' ? 'name ASC' : null,
      raw: 'management' == 'rawquery');
    final n = await db.count();
    if (mounted) setState(() { students = rows; total = n; });
  }
  Future<void> _add() async {
    if (name.text.trim().isEmpty || roll.text.trim().isEmpty || courseText.text.trim().isEmpty) {
      setState(() => message = 'Please enter name, roll number and course.'); return;
    }
    try {
      final s = Student(name: name.text.trim(), rollNumber: roll.text.trim(), course: courseText.text.trim());
      if ('management' == 'rawinsert') { await db.rawInsert(s); } else { await db.insert(s); }
      name.clear(); roll.clear();
      setState(() => message = 'Student saved successfully.');
      await _refresh();
    } catch (_) { setState(() => message = 'Save failed: roll number may already exist.'); }
  }
  Future<void> _edit(Student s) async {
    final c = TextEditingController(text: s.name);
    final value = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Update student name'),
      content: TextField(controller: c, decoration: const InputDecoration(labelText: 'Name')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Save')),
      ]));
    if (value == null || value.isEmpty) return;
    await db.update(Student(id: s.id, name: value, rollNumber: s.rollNumber, course: s.course));
    setState(() => message = 'Student updated.'); await _refresh();
  }
  Future<void> _remove(Student s) async {
    if (s.id != null) await db.delete(s.id!);
    setState(() => message = 'Student deleted.'); await _refresh();
  }
  @override
  void dispose() { name.dispose(); roll.dispose(); courseText.dispose(); search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Student Record Management App'), actions: [IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))]),
    body: ('management' == 'create' || 'management' == 'table')
      ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall)))
      : ('management' == 'count')
        ? Center(child: Text('Total student records: $total', style: Theme.of(context).textTheme.headlineSmall))
        : Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          if (['textfield','management','helper','model','rawinsert'].contains('management'))
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Student name')),
              TextField(controller: roll, decoration: const InputDecoration(labelText: 'Roll number')),
              TextField(controller: courseText, decoration: const InputDecoration(labelText: 'Course')),
              const SizedBox(height: 8),
              FilledButton.icon(onPressed: _add, icon: const Icon(Icons.save), label: const Text('Save student')),
            ]))),
          if ('management' == 'search')
            Row(children: [
              Expanded(child: TextField(controller: search, decoration: const InputDecoration(labelText: 'Roll number'))),
              IconButton(onPressed: () async {
                final rows = await (await db.database).query('students', where: 'roll_number = ?', whereArgs: [search.text.trim()]);
                setState(() { students = rows.map(Student.fromMap).toList(); message = '${rows.length} matching record(s)'; });
              }, icon: const Icon(Icons.search)),
            ]),
          if ('management' == 'course')
            DropdownButton<String>(value: selectedCourse, hint: const Text('Select course'), items: const [
              DropdownMenuItem(value: 'BCA', child: Text('BCA')),
              DropdownMenuItem(value: 'B.Tech', child: Text('B.Tech')),
              DropdownMenuItem(value: 'MCA', child: Text('MCA')),
            ], onChanged: (v) async { setState(() => selectedCourse = v); await _refresh(); }),
          if ('management' == 'clear')
            Row(children: [Expanded(child: Text('Total records: $total')), FilledButton(onPressed: () async { await db.clear(); setState(() => message = 'All records cleared.'); await _refresh(); }, child: const Text('Clear All'))]),
          if ('management' == 'delete') const Text('Tap delete beside a student.'),
          if ('management' == 'update') const Text('Tap edit beside a student.'),
          if ('management' == 'query' || 'management' == 'rawquery') Text('Records loaded with ${'management' == 'query' ? 'query()' : 'rawQuery()'}'),
          if ('management' == 'model') const Text('Student model provides toMap() and fromMap().'),
          if ('management' == 'helper') const Text('DatabaseHelper contains database CRUD methods.'),
          if ('management' == 'management') Text(message),
          Expanded(child: students.isEmpty ? const Center(child: Text('No students found. Add a record where supported.')) :
            ListView.builder(itemCount: students.length, itemBuilder: (context, i) {
              final s = students[i];
              return Card(child: ListTile(
                title: Text(s.name), subtitle: Text('Roll: ${s.rollNumber} • Course: ${s.course}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (['update','management','helper'].contains('management')) IconButton(onPressed: () => _edit(s), icon: const Icon(Icons.edit)),
                  if (['delete','management','helper'].contains('management')) IconButton(onPressed: () => _remove(s), icon: const Icon(Icons.delete)),
                ])));
            })),
          if (['management','helper','model'].contains('management')) Text('Total records: $total'),
        ])),
  );
}
