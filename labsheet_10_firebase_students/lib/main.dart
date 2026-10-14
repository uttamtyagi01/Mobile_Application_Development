import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: AuthGate(), debugShowCheckedModeBanner: false));
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      return snapshot.data == null ? const LoginPage() : const StudentsPage();
    },
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool register = false;
  bool busy = false;

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter email and password (minimum 6 characters)')));
      return;
    }
    setState(() => busy = true);
    try {
      if (register) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: password.text);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(register ? 'Register' : 'Login')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: busy ? null : submit, child: Text(busy ? 'Please wait...' : (register ? 'Register' : 'Login'))),
      TextButton(onPressed: () => setState(() => register = !register), child: Text(register ? 'Already registered? Login' : 'New user? Register')),
      TextButton(onPressed: () async {
        if (email.text.trim().isNotEmpty) {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email requested')));
        }
      }, child: const Text('Forgot password?')),
    ])),
  );
}

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});
  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final name = TextEditingController();
  final roll = TextEditingController();
  final course = TextEditingController();
  final students = FirebaseFirestore.instance.collection('students');

  Future<void> save({String? id, Map<String, dynamic>? existing}) async {
    name.text = existing?['name'] as String? ?? '';
    roll.text = existing?['roll'] as String? ?? '';
    course.text = existing?['course'] as String? ?? '';
    final key = GlobalKey<FormState>();
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text(id == null ? 'Add student' : 'Update student'),
      content: Form(key: key, child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        TextFormField(controller: roll, decoration: const InputDecoration(labelText: 'Roll number'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        TextFormField(controller: course, decoration: const InputDecoration(labelText: 'Course'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () { if (key.currentState!.validate()) Navigator.pop(context, true); }, child: const Text('Save')),
      ],
    ));
    if (ok == true) {
      final data = {'name': name.text.trim(), 'roll': roll.text.trim(), 'course': course.text.trim(), 'updatedAt': FieldValue.serverTimestamp()};
      if (id == null) {
        await students.add(data);
      } else {
        await students.doc(id).update(data);
      }
    }
  }

  @override
  void dispose() { name.dispose(); roll.dispose(); course.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Students • ${FirebaseAuth.instance.currentUser?.email ?? ''}'), actions: [
      IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout), tooltip: 'Logout'),
    ]),
    floatingActionButton: FloatingActionButton(onPressed: () => save(), child: const Icon(Icons.add)),
    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: students.orderBy('name').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Firestore error: ${snapshot.error}'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('No students yet. Tap + to add one.'));
        return ListView.builder(itemCount: docs.length, itemBuilder: (context, i) {
          final doc = docs[i];
          final data = doc.data();
          return Card(child: ListTile(
            title: Text(data['name'] ?? ''),
            subtitle: Text('Roll: ${data['roll'] ?? ''} • ${data['course'] ?? ''}'),
            onTap: () => save(id: doc.id, existing: data),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async {
              final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
                title: const Text('Delete student?'),
                actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))],
              ));
              if (ok == true) await students.doc(doc.id).delete();
            }),
          ));
        });
      },
    ),
  );
}
