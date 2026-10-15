import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;


void main() => runApp(const LabApp());
class LabApp extends StatelessWidget { const LabApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, title:'LabSheet 7 Q1', theme:ThemeData(colorSchemeSeed:Colors.indigo,useMaterial3:true), home:const ExercisePage()); }
class ExercisePage extends StatefulWidget { const ExercisePage({super.key}); @override State<ExercisePage> createState()=>_ExercisePageState(); }
class _ExercisePageState extends State<ExercisePage> {
  Database? _db;
  String _status = 'Preparing SQLite…';
  @override void initState() { super.initState(); _openDatabase(); }
  Future<void> _openDatabase() async {
    final path = p.join(await getDatabasesPath(), 'labsheet7_q1.db');
    _db = await openDatabase(path);
    if (mounted) setState(() => _status = 'Database opened successfully\n$path');
  }

  Future<void> _prepare() async {}
  Future<void> _load() async {}


  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('LabSheet-7 Q1: Create SQLite database')), body:Center(child:Padding(padding:const EdgeInsets.all(24),child:Text(_status,textAlign:TextAlign.center))));
}
