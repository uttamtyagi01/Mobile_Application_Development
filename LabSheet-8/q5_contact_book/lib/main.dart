import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String appTitle = 'Contact Book';
const String appMode = 'contacts';
const String firstLabel = 'Name';
const String secondLabel = 'Phone Number';

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appTitle,
    debugShowCheckedModeBanner: false,
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
  List<Map<String, Object?>> rows = [];
  final search = TextEditingController();
  double total = 0;
  bool loggedIn = false;

  bool get isExpense => appMode.startsWith('expenses');
  bool get isTodo => appMode == 'todo';
  bool get isLogin => appMode == 'login';
  bool get isRegistration => appMode == 'registration';
  bool get isValidation => appMode == 'validation';
  bool get isProduct => appMode == 'products';
  bool get isContact => appMode.startsWith('contacts');
  bool get isStudent => appMode == 'students';
  bool get isNote => appMode.startsWith('notes');

  @override
  void initState() { super.initState(); initDb(); }

  Future<void> initDb() async {
    final path = join(await getDatabasesPath(), 'lab8_${appMode}.db');
    db = await openDatabase(path, version: 1, onCreate: (d, v) async {
      await d.execute('''CREATE TABLE records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        detail TEXT NOT NULL,
        amount REAL NOT NULL DEFAULT 0,
        completed INTEGER NOT NULL DEFAULT 0,
        username TEXT NOT NULL DEFAULT '',
        password TEXT NOT NULL DEFAULT ''
      )''');
    });
    await refresh();
  }

  Future<void> refresh([String query = '']) async {
    if (db == null) return;
    List<Map<String, Object?>> result;
    if (appMode == 'contacts_search' || appMode == 'notes_search') {
      result = await db!.query('records', where: 'title LIKE ?', whereArgs: ['%$query%'], orderBy: 'id DESC');
    } else {
      result = await db!.query('records', orderBy: 'id DESC');
    }
    final sum = result.fold<double>(0, (s, r) => s + ((r['amount'] as num?)?.toDouble() ?? 0));
    if (!mounted) return;
    setState(() { rows = result; total = sum; });
  }

  Future<void> showEditor({Map<String, Object?>? row}) async {
    final a = TextEditingController(text: row?['title']?.toString() ?? '');
    final b = TextEditingController(text: row?['detail']?.toString() ?? '');
    final c = TextEditingController(text: row?['amount']?.toString() ?? '');
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text(row == null ? 'Add Record' : 'Edit Record'),
      content: Form(key: formKey, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: a, decoration: InputDecoration(labelText: firstLabel), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required field' : null),
        const SizedBox(height: 10),
        TextFormField(controller: b, obscureText: isLogin || isRegistration, decoration: InputDecoration(labelText: secondLabel),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required field';
            if ((isRegistration || isValidation) && firstLabel == 'Email' && !v.contains('@')) return 'Enter a valid email';
            if (isValidation && v.length < 6) return 'Minimum 6 characters';
            return null;
          }),
        if (isExpense || isProduct) ...[
          const SizedBox(height: 10),
          TextFormField(controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: isExpense ? 'Amount' : 'Price'),
            validator: (v) { final n = double.tryParse(v ?? ''); return n == null || n < 0 ? 'Enter a valid non-negative number' : null; }),
        ],
      ]))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
        FilledButton(onPressed: () async {
          if (!(formKey.currentState?.validate() ?? false)) return;
          final title = a.text.trim(), detail = b.text.trim();
          final amount = double.tryParse(c.text.trim()) ?? 0;
          final values = <String, Object?>{'title': title, 'detail': detail, 'amount': amount};
          if (isLogin || isRegistration) { values['username'] = title; values['password'] = detail; }
          if (row == null) { await db!.insert('records', values); }
          else { await db!.update('records', values, where: 'id = ?', whereArgs: [row['id']]); }
          if (dialogContext.mounted) Navigator.pop(dialogContext);
          await refresh(search.text);
        }, child: const Text('Save')),
      ],
    ));
    a.dispose(); b.dispose(); c.dispose();
  }

  Future<void> remove(Map<String, Object?> row) async {
    final confirmed = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
      title: const Text('Confirm delete'), content: Text('Delete "${row['title']}"?'),
      actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete'))],
    ));
    if (confirmed == true) {
      await db!.delete('records', where: 'id = ?', whereArgs: [row['id']]);
      await refresh(search.text);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record deleted')));
    }
  }

  Future<void> toggle(Map<String, Object?> row, bool value) async {
    await db!.update('records', {'completed': value ? 1 : 0}, where: 'id = ?', whereArgs: [row['id']]);
    await refresh(search.text);
  }

  Future<void> login() async {
    final u = TextEditingController(), p = TextEditingController();
    await showDialog<void>(context: context, builder: (c) => AlertDialog(
      title: const Text('Login'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: u, decoration: const InputDecoration(labelText: 'Username')),
        TextField(controller: p, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
        FilledButton(onPressed: () async {
          final found = await db!.query('records', where: 'username = ? AND password = ?', whereArgs: [u.text.trim(), p.text]);
          if (!c.mounted) return;
          if (found.isNotEmpty) {
            setState(() => loggedIn = true); Navigator.pop(c);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials. Register first.')));
          }
        }, child: const Text('Login'))],
    ));
    u.dispose(); p.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSearch = appMode == 'notes_search' || appMode == 'contacts_search';
    return Scaffold(
      appBar: AppBar(title: Text(appTitle), actions: [if (isLogin) IconButton(onPressed: login, icon: const Icon(Icons.login), tooltip: 'Login')]),
      body: Column(children: [
        if (showSearch) Padding(padding: const EdgeInsets.all(12), child: TextField(controller: search, onChanged: refresh,
          decoration: const InputDecoration(labelText: 'Search by name/title', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()))),
        if (isExpense && appMode == 'expenses_total') Padding(padding: const EdgeInsets.all(12), child: Text('Total Expense: ₹${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge)),
        if (isLogin && loggedIn) const Padding(padding: EdgeInsets.all(12), child: Text('Home Screen — Login successful')),
        Expanded(child: rows.isEmpty ? Center(child: Text(isLogin ? 'Register an account, then tap login.' : 'No records yet. Tap + to add one.'))
          : ListView.builder(itemCount: rows.length, itemBuilder: (context, i) {
            final r = rows[i];
            final subtitle = isExpense ? 'Amount: ₹${r['amount']}' : '${r['detail']}';
            final tile = ListTile(
              leading: isTodo ? Checkbox(value: (r['completed'] as int? ?? 0) == 1, onChanged: (v) => toggle(r, v ?? false))
                : CircleAvatar(child: Icon(isContact ? Icons.person : isExpense ? Icons.currency_rupee : isProduct ? Icons.inventory : isStudent ? Icons.school : Icons.description)),
              title: Text(r['title']?.toString() ?? ''), subtitle: Text(subtitle), onTap: () => showEditor(row: r),
              trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => remove(r)),
            );
            if (appMode == 'notes_delete') return Dismissible(key: ValueKey(r['id']), onDismissed: (_) async {
              await db!.delete('records', where: 'id = ?', whereArgs: [r['id']]); await refresh();
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note deleted')));
            }, background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)), child: Card(child: tile));
            return Card(child: tile);
          })),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: showEditor, child: const Icon(Icons.add)),
    );
  }
}
