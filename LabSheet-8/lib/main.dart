import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lab Sheet 8',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const Home(),
  );
}

void toast(BuildContext context, String text) =>
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

Future<void> editDialog(
  BuildContext context, String title, List<String> labels,
  List<String> initial, void Function(List<String>) save,
) async {
  final key = GlobalKey<FormState>();
  final controllers = List.generate(labels.length,
    (i) => TextEditingController(text: initial[i]));
  await showDialog<void>(context: context, builder: (d) => AlertDialog(
    title: Text(title),
    content: Form(key: key, child: SingleChildScrollView(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(labels.length, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: controllers[i],
          decoration: InputDecoration(labelText: labels[i], border: const OutlineInputBorder()),
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
      )),
    ))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (key.currentState!.validate()) {
          save(controllers.map((c) => c.text.trim()).toList());
          Navigator.pop(d);
        }
      }, child: const Text('Save')),
    ],
  ));
  for (final c in controllers) { c.dispose(); }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  final pages = const [
    NotesPage(), ContactsPage(), ExpensesPage(), TasksPage(),
    AccountPage(), StudentsPage(), ProductsPage(),
  ];
  final names = const ['Notes', 'Contacts', 'Expenses', 'To-Do', 'Account', 'Students', 'Products'];
  final icons = const [
    Icons.note, Icons.contacts, Icons.receipt_long, Icons.check_box,
    Icons.person, Icons.school, Icons.inventory,
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Lab Sheet 8 • ${names[tab]}')),
    body: IndexedStack(index: tab, children: pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab,
      onDestinationSelected: (v) => setState(() => tab = v),
      destinations: List.generate(names.length,
        (i) => NavigationDestination(icon: Icon(icons[i]), label: names[i])),
    ),
  );
}

// Programs 1-4: SQLite Notes, edit on tap, swipe delete, title search.
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}
class _NotesPageState extends State<NotesPage> {
  String query = '';
  Future<List<Map<String, Object?>>> load() async {
    final db = await DB.instance.database;
    return db.query('notes', where: 'title LIKE ?', whereArgs: ['%$query%'], orderBy: 'id DESC');
  }
  Future<void> edit([Map<String, Object?>? n]) async {
    await editDialog(context, n == null ? 'Add Note' : 'Edit Note',
      ['Title', 'Content'], [n?['title']?.toString() ?? '', n?['content']?.toString() ?? ''],
      (v) async {
        if (n == null) {
          await DB.instance.insert('notes', {'title': v[0], 'content': v[1]});
        } else {
          await DB.instance.update('notes', n['id'] as int, {'title': v[0], 'content': v[1]});
        }
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(padding: const EdgeInsets.all(12), child: TextField(
      decoration: const InputDecoration(labelText: 'Search note title', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
      onChanged: (v) => setState(() => query = v))),
    Expanded(child: FutureBuilder(future: load(), builder: (context, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (s.data!.isEmpty) return const Center(child: Text('No notes found. Tap + to add.'));
      return ListView(children: s.data!.map((n) => Dismissible(
        key: ValueKey(n['id']),
        background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.all(16), child: const Icon(Icons.delete, color: Colors.white)),
        secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.all(16), child: const Icon(Icons.delete, color: Colors.white)),
        onDismissed: (_) async {
          await DB.instance.delete('notes', n['id'] as int);
          if (mounted) { setState(() {}); toast(context, 'Note deleted'); }
        },
        child: ListTile(title: Text(n['title'].toString()),
          subtitle: Text(n['content'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () => edit(n)),
      )).toList());
    })),
    Padding(padding: const EdgeInsets.all(12), child: Align(alignment: Alignment.centerRight,
      child: FloatingActionButton(onPressed: () => edit(), child: const Icon(Icons.add)))),
  ]);
}

// Programs 5-7: Contact book, delete confirmation, SQL LIKE search.
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});
  @override
  State<ContactsPage> createState() => _ContactsPageState();
}
class _ContactsPageState extends State<ContactsPage> {
  String query = '';
  Future<List<Map<String, Object?>>> load() async {
    final db = await DB.instance.database;
    return db.query('contacts', where: 'name LIKE ?', whereArgs: ['%$query%'], orderBy: 'name');
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(padding: const EdgeInsets.all(12), child: TextField(
      decoration: const InputDecoration(labelText: 'Search contact name', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
      onChanged: (v) => setState(() => query = v))),
    Expanded(child: FutureBuilder(future: load(), builder: (context, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (s.data!.isEmpty) return const Center(child: Text('No contacts found.'));
      return ListView(children: s.data!.map((c) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(c['name'].toString()), subtitle: Text(c['phone'].toString()),
        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () async {
          final ok = await showDialog<bool>(context: context, builder: (d) => AlertDialog(
            title: const Text('Delete contact?'), content: Text('Delete ${c['name']}?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(d, true), child: const Text('Delete')),
            ]));
          if (ok == true) {
            await DB.instance.delete('contacts', c['id'] as int);
            if (mounted) { setState(() {}); toast(context, 'Contact deleted'); }
          }
        }),
      )).toList());
    })),
    Padding(padding: const EdgeInsets.all(12), child: Align(alignment: Alignment.centerRight,
      child: FloatingActionButton(onPressed: () => editDialog(context, 'Add Contact',
        ['Name', 'Phone number'], ['', ''], (v) async {
          await DB.instance.insert('contacts', {'name': v[0], 'phone': v[1]});
          setState(() {});
        }), child: const Icon(Icons.add)))),
  ]);
}

// Programs 8-9: Expense records and SQL SUM.
class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}
class _ExpensesPageState extends State<ExpensesPage> {
  Future<List<Map<String, Object?>>> load() => DB.instance.all('expenses');
  Future<double> total() async {
    final result = await (await DB.instance.database).rawQuery('SELECT SUM(amount) AS total FROM expenses');
    return (result.first['total'] as num?)?.toDouble() ?? 0;
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    FutureBuilder<double>(future: total(), builder: (context, s) => Card(
      margin: const EdgeInsets.all(12), child: ListTile(
        title: const Text('Total expense (SUM)'),
        trailing: Text('₹${(s.data ?? 0).toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge)))),
    Expanded(child: FutureBuilder(future: load(), builder: (context, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (s.data!.isEmpty) return const Center(child: Text('No expenses added.'));
      return ListView(children: s.data!.map((e) => ListTile(
        title: Text(e['title'].toString()),
        trailing: Text('₹${(e['amount'] as num).toStringAsFixed(2)}'),
        onLongPress: () async { await DB.instance.delete('expenses', e['id'] as int); setState(() {}); },
      )).toList());
    })),
    Padding(padding: const EdgeInsets.all(12), child: Align(alignment: Alignment.centerRight,
      child: FloatingActionButton(onPressed: () => editDialog(context, 'Add Expense',
        ['Title', 'Amount'], ['', ''], (v) async {
          final amount = double.tryParse(v[1]);
          if (amount == null || amount < 0) { toast(context, 'Enter a valid amount'); return; }
          await DB.instance.insert('expenses', {'title': v[0], 'amount': amount});
          setState(() {});
        }), child: const Icon(Icons.add)))),
  ]);
}

// Program 10: To-Do tasks with SQLite Checkbox status.
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  State<TasksPage> createState() => _TasksPageState();
}
class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) => Column(children: [
    Expanded(child: FutureBuilder(future: DB.instance.all('tasks'), builder: (context, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (s.data!.isEmpty) return const Center(child: Text('No tasks added.'));
      return ListView(children: s.data!.map((t) => CheckboxListTile(
        value: t['completed'] == 1,
        title: Text(t['title'].toString(),
          style: TextStyle(decoration: t['completed'] == 1 ? TextDecoration.lineThrough : null)),
        onChanged: (v) async {
          await DB.instance.update('tasks', t['id'] as int, {'completed': v == true ? 1 : 0});
          setState(() {});
        },
        secondary: IconButton(icon: const Icon(Icons.delete), onPressed: () async {
          await DB.instance.delete('tasks', t['id'] as int); setState(() {});
        }),
      )).toList());
    })),
    Padding(padding: const EdgeInsets.all(12), child: Align(alignment: Alignment.centerRight,
      child: FloatingActionButton(onPressed: () => editDialog(context, 'Add Task',
        ['Task title'], [''], (v) async {
          await DB.instance.insert('tasks', {'title': v[0], 'completed': 0});
          setState(() {});
        }), child: const Icon(Icons.add)))),
  ]);
}

// Programs 11-13: Registration, login, and Form/TextFormField validation.
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}
class _AccountPageState extends State<AccountPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool registering = true;
  bool loggedIn = false;
  String welcome = '';

  @override
  void dispose() {
    name.dispose(); email.dispose(); password.dispose(); super.dispose();
  }

  String? emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Enter valid email';
    return null;
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    final db = await DB.instance.database;
    if (registering) {
      try {
        await db.insert('users', {
          'name': name.text.trim(),
          'email': email.text.trim(),
          'password': password.text,
        });
        if (mounted) {
          toast(context, 'Registration successful. Now log in.');
          setState(() => registering = false);
        }
      } catch (_) {
        if (mounted) toast(context, 'Email already registered.');
      }
    } else {
      final users = await db.query('users',
        where: 'email = ? AND password = ?',
        whereArgs: [email.text.trim(), password.text], limit: 1);
      if (!mounted) return;
      if (users.isEmpty) {
        toast(context, 'Invalid email or password');
      } else {
        setState(() {
          loggedIn = true;
          welcome = users.first['name'].toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 60, color: Colors.green),
        Text('Welcome, $welcome!', style: Theme.of(context).textTheme.headlineSmall),
        const Text('Home screen — login successful'),
        FilledButton(onPressed: () => setState(() => loggedIn = false), child: const Text('Log out')),
      ]));
    return Center(child: SingleChildScrollView(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(padding: const EdgeInsets.all(20), child: Form(key: form,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(registering ? 'Registration' : 'Login',
            style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          if (registering) TextFormField(controller: name,
            decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null),
          if (registering) const SizedBox(height: 12),
          TextFormField(controller: email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            validator: emailValidator),
          const SizedBox(height: 12),
          TextFormField(controller: password, obscureText: true,
            decoration: const InputDecoration(labelText: 'Password (min 6 characters)', border: OutlineInputBorder()),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password required';
              if (registering && v.length < 6) return 'Minimum 6 characters';
              return null;
            }),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: submit,
            child: Text(registering ? 'Register' : 'Login'))),
          TextButton(onPressed: () => setState(() => registering = !registering),
            child: Text(registering ? 'Already registered? Login' : 'New user? Register')),
        ]),
      )),
    )));
  }
}

// Program 14: Student list and Add/Edit screen using Navigator.
class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});
  @override
  State<StudentsPage> createState() => _StudentsPageState();
}
class _StudentsPageState extends State<StudentsPage> {
  Future<void> openStudent([Map<String, Object?>? student]) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (_) => StudentForm(student: student)));
    if (mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder(future: DB.instance.all('students'), builder: (context, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (s.data!.isEmpty) return const Center(child: Text('No students. Tap + to add.'));
      return ListView(children: s.data!.map((st) => ListTile(
        leading: const Icon(Icons.school),
        title: Text(st['name'].toString()),
        subtitle: Text(st['course'].toString()),
        onTap: () => openStudent(st),
        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () async {
          await DB.instance.delete('students', st['id'] as int); setState(() {});
        }),
      )).toList());
    }),
    floatingActionButton: FloatingActionButton(onPressed: () => openStudent(), child: const Icon(Icons.add)),
  );
}

class StudentForm extends StatefulWidget {
  final Map<String, Object?>? student;
  const StudentForm({super.key, this.student});
  @override
  State<StudentForm> createState() => _StudentFormState();
}
class _StudentFormState extends State<StudentForm> {
  final keyForm = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController course;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.student?['name']?.toString() ?? '');
    course = TextEditingController(text: widget.student?['course']?.toString() ?? '');
  }
  @override
  void dispose() { name.dispose(); course.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.student == null ? 'Add Student' : 'Edit Student')),
    body: Padding(padding: const EdgeInsets.all(16), child: Form(key: keyForm,
      child: Column(children: [
        TextFormField(controller: name,
          decoration: const InputDecoration(labelText: 'Student name', border: OutlineInputBorder()),
          validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null),
        const SizedBox(height: 12),
        TextFormField(controller: course,
          decoration: const InputDecoration(labelText: 'Course', border: OutlineInputBorder()),
          validator: (v) => v == null || v.trim().isEmpty ? 'Course required' : null),
        const SizedBox(height: 16),
        FilledButton(onPressed: () async {
          if (!keyForm.currentState!.validate()) return;
          final data = {'name': name.text.trim(), 'course': course.text.trim()};
          if (widget.student == null) {
            await DB.instance.insert('students', data);
          } else {
            await DB.instance.update('students', widget.student!['id'] as int, data);
          }
          if (context.mounted) Navigator.pop(context);
        }, child: const Text('Save student')),
      ]),
    )),
  );
}

// Program 15: Product Inventory — add, update, delete.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}
class _ProductsPageState extends State<ProductsPage> {
  Future<void> edit([Map<String, Object?>? p]) async {
    await editDialog(context, p == null ? 'Add Product' : 'Update Product',
      ['Product name', 'Quantity', 'Price'],
      [p?['name']?.toString() ?? '', p?['quantity']?.toString() ?? '', p?['price']?.toString() ?? ''],
      (v) async {
        final quantity = int.tryParse(v[1]);
        final price = double.tryParse(v[2]);
        if (quantity == null || quantity < 0 || price == null || price < 0) {
          toast(context, 'Enter valid non-negative quantity and price');
          return;
        }
        final data = {'name': v[0], 'quantity': quantity, 'price': price};
        if (p == null) {
          await DB.instance.insert('products', data);
        } else {
          await DB.instance.update('products', p['id'] as int, data);
        }
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder(future: DB.instance.all('products'), builder: (context, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (s.data!.isEmpty) return const Center(child: Text('No products. Tap + to add.'));
      return ListView(children: s.data!.map((p) => ListTile(
        leading: const Icon(Icons.inventory),
        title: Text(p['name'].toString()),
        subtitle: Text('Qty: ${p['quantity']} • Price: ₹${(p['price'] as num).toStringAsFixed(2)}'),
        onTap: () => edit(p),
        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () async {
          await DB.instance.delete('products', p['id'] as int);
          setState(() {});
          if (context.mounted) toast(context, 'Product deleted');
        }),
      )).toList());
    }),
    floatingActionButton: FloatingActionButton(onPressed: () => edit(), child: const Icon(Icons.add)),
  );
}
