import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LabApp());
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const AddStudentPage(),
  );
}

class AddStudentPage extends StatefulWidget{const AddStudentPage({super.key});@override State<AddStudentPage> createState()=>_AddStudentPageState();}
class _AddStudentPageState extends State<AddStudentPage>{final name=TextEditingController(),roll=TextEditingController(),course=TextEditingController();String status='Add one student record to Firestore.';
Future<void> save()async{if(name.text.trim().isEmpty){setState(()=>status='Name is required.');return;}try{await FirebaseFirestore.instance.collection('students').add({'name':name.text.trim(),'roll':roll.text.trim(),'course':course.text.trim(),'createdAt':FieldValue.serverTimestamp()});name.clear();roll.clear();course.clear();setState(()=>status='Student added successfully.');}catch(e){setState(()=>status='Save failed: $e');}}
@override void dispose(){name.dispose();roll.dispose();course.dispose();super.dispose();}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q8 Add Student to Firestore')),body:Padding(padding:const EdgeInsets.all(20),child:ListView(children:[TextField(controller:name,decoration:const InputDecoration(labelText:'Student name')),TextField(controller:roll,decoration:const InputDecoration(labelText:'Roll number')),TextField(controller:course,decoration:const InputDecoration(labelText:'Course')),const SizedBox(height:12),FilledButton(onPressed:save,child:const Text('Save student')),Text(status)])));
}
