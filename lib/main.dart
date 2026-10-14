
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateTableScreen(),
    );
  }
}

class CreateTableScreen extends StatefulWidget {
  const CreateTableScreen({super.key});

  @override
  State<CreateTableScreen> createState() => _CreateTableScreenState();
}

class _CreateTableScreenState extends State<CreateTableScreen> {
  String output = 'Creating database and table...';

  @override
  void initState() {
    super.initState();
    createTable();
  }

  Future<void> createTable() async {
    try {
      final path = join(
        await getDatabasesPath(),
        'college.db',
      );

      final db = await openDatabase(
        path,
        version: 1,
      );

      await db.execute('''
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          roll_number TEXT NOT NULL,
          course TEXT NOT NULL
        )
      ''');

      await db.close();

      if (!mounted) return;
      setState(() {
        output = 'SUCCESS!\n\n'
            'Database: college.db\n'
            'Table: students\n\n'
            'Columns:\n'
            'id - INTEGER PRIMARY KEY\n'
            'name - TEXT\n'
            'roll_number - TEXT\n'
            'course - TEXT';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        output = 'ERROR:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program 2 - SQLite'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storage,
                size: 70,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Students Table',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                output,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
