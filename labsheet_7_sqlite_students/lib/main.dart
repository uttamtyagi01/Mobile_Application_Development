import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() => runApp(const MaterialApp(home: StudentPage(), debugShowCheckedModeBanner: false));

class Student {
  final int? id;
  final String name;
  final String roll;
  final String course;

  const Student({this.id, required this.name, required this.roll, required this.course});
  Map<String, Object?> toMap() => {'id': id, 'name': name, 'roll': roll, 'course': course};
  factory Student.fromMap(Map<String, Object?> map) => Student(
    id: map['id'] as int?,
    name: map['name'] as String,
    roll: map['roll'] as String,
    course: map['course'] as String,
  );
}

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'students_lab7.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          roll TEXT NOT NULL UNIQUE,
          course TEXT NOT NULL
        )
      ''');
    });
    return _db!;
  }

  Future<int> insert(Student s) async => (await db).insert('students', s.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  Future<List<Student>> readAll({String search = '', String? course}) async {
    final database = await db;
    final whereParts = <String>[];
    final args = <Object?>[];
    if (search.trim().isNotEmpty) {
      whereParts.add('(name LIKE ? OR roll LIKE ?)');
      args.addAll(['%${search.trim()}%', '%${search.trim()}%']);
    }
    if (course != null && course != 'All') {
      whereParts.add('course = ?');
      args.add(course);
    }
    final rows = await database.query(
      'students',
      where: whereParts.isEmpty ? null : whereParts.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'name ASC',
    );
    return rows.map(Student.fromMap).toList();
  }
  Future<int> update(Student s) async => (await db).update('students', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  Future<int> delete(int id) async => (await db).delete('students', where: 'id = ?', whereArgs: [id]);
  Future<int> clear() async => (await db).delete('students');
  Future<int> count() async {
    final rows = await (await db).rawQuery('SELECT COUNT(*) AS total FROM students');
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
  final search = TextEditingController();
  String course = 'BCA';
  String filterCourse = 'All';
  int? editingId;
  List<Student> students = [];
  int total = 0;

  @override
  void initState() { super.initState(); _refresh(); }
  @override
  void dispose() { name.dispose(); roll.dispose(); search.dispose(); super.dispose(); }

  Future<void> _refresh() async {
    final data = await db.readAll(search: search.text, course: filterCourse);
    final count = await db.count();
    if (!mounted) return;
    setState(() { students = data; total = count; });
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty || roll.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter name and roll number')));
      return;
    }
    final s = Student(id: editingId, name: name.text.trim(), roll: roll.text.trim(), course: course);
    try {
      if (editingId == null) {
        await db.insert(s);
      } else {
        await db.update(s);
      }
      name.clear(); roll.clear();
      setState(() => editingId = null);
      await _refresh();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  void _edit(Student s) {
    name.text = s.name; roll.text = s.roll;
    setState(() { editingId = s.id; course = s.course; });
  }

  Future<void> _delete(Student s) async {
    await db.delete(s.id!);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Labsheet 7: Student CRUD'), actions: [
        IconButton(tooltip: 'Clear all', icon: const Icon(Icons.delete_sweep), onPressed: () async {
          final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
            title: const Text('Clear all students?'),
            content: const Text('This cannot be undone.'),
            actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Clear'))],
          ));
          if (ok == true) { await db.clear(); await _refresh(); }
        })
      ]),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Student name', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: roll, decoration: const InputDecoration(labelText: 'Roll number', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: course, decoration: const InputDecoration(labelText: 'Course', border: OutlineInputBorder()),
            items: const ['BCA', 'BSc IT', 'MCA', 'B.Tech'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => course = v ?? 'BCA'),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: _save, child: Text(editingId == null ? 'Add Student' : 'Update Student'))),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () { name.clear(); roll.clear(); setState(() => editingId = null); }, child: const Text('Reset')),
          ]),
          const SizedBox(height: 8),
          TextField(controller: search, onChanged: (_) => _refresh(), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search name or roll', border: OutlineInputBorder())),
          Row(children: [
            const Text('Course filter: '),
            DropdownButton<String>(value: filterCourse, items: const ['All', 'BCA', 'BSc IT', 'MCA', 'B.Tech'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) { setState(() => filterCourse = v ?? 'All'); _refresh(); }),
            const Spacer(),
            Text('Total: $total'),
          ]),
          Expanded(child: students.isEmpty ? const Center(child: Text('No student records')) : ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, i) {
              final s = students[i];
              return Card(child: ListTile(
                title: Text(s.name),
                subtitle: Text('Roll: ${s.roll} • ${s.course}'),
                onTap: () => _edit(s),
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(s)),
              ));
            },
          )),
        ]),
      ),
    );
  }
}
