import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() => runApp(const MaterialApp(home: NotesPage(), debugShowCheckedModeBanner: false));

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Database? database;
  List<Map<String, Object?>> notes = [];
  final search = TextEditingController();

  Future<Database> getDb() async {
    if (database != null) return database!;
    database = await openDatabase(p.join(await getDatabasesPath(), 'notes_lab8.db'),
      version: 1,
      onCreate: (db, version) => db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, content TEXT NOT NULL)'),
    );
    return database!;
  }

  Future<void> load() async {
    final db = await getDb();
    final rows = await db.query('notes', where: search.text.trim().isEmpty ? null : 'title LIKE ?', whereArgs: search.text.trim().isEmpty ? null : ['%${search.text.trim()}%'], orderBy: 'id DESC');
    if (mounted) setState(() => notes = rows);
  }

  Future<void> editNote({Map<String, Object?>? note}) async {
    final title = TextEditingController(text: note?['title'] as String? ?? '');
    final content = TextEditingController(text: note?['content'] as String? ?? '');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text(note == null ? 'Add note' : 'Edit note'),
      content: Form(key: formKey, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null),
        TextFormField(controller: content, decoration: const InputDecoration(labelText: 'Content'), minLines: 2, maxLines: 5, validator: (v) => v == null || v.trim().isEmpty ? 'Content is required' : null),
      ]))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () { if (formKey.currentState!.validate()) Navigator.pop(context, true); }, child: const Text('Save')),
      ],
    ));
    if (result == true) {
      final db = await getDb();
      final values = {'title': title.text.trim(), 'content': content.text.trim()};
      if (note == null) {
        await db.insert('notes', values);
      } else {
        await db.update('notes', values, where: 'id = ?', whereArgs: [note['id']]);
      }
      await load();
    }
    title.dispose(); content.dispose();
  }

  Future<void> deleteNote(Map<String, Object?> note) async {
    await (await getDb()).delete('notes', where: 'id = ?', whereArgs: [note['id']]);
    await load();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note deleted')));
  }

  @override
  void initState() { super.initState(); load(); }
  @override
  void dispose() { search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Labsheet 8: Notes')),
    floatingActionButton: FloatingActionButton(onPressed: () => editNote(), child: const Icon(Icons.add)),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: TextField(controller: search, onChanged: (_) => load(), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search by title', border: OutlineInputBorder()))),
      Expanded(child: notes.isEmpty ? const Center(child: Text('No notes yet')) : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Dismissible(
            key: ValueKey(note['id']),
            background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
            onDismissed: (_) => deleteNote(note),
            child: Card(child: ListTile(title: Text(note['title'] as String), subtitle: Text(note['content'] as String, maxLines: 2, overflow: TextOverflow.ellipsis), onTap: () => editNote(note: note))),
          );
        },
      )),
    ]),
  );
}
