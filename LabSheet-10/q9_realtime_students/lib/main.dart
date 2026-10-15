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
    home: const RealtimeStudentsPage(),
  );
}

class RealtimeStudentsPage extends StatelessWidget{const RealtimeStudentsPage({super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q9 Realtime Students')),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('students').snapshots(),builder:(context,s){if(s.hasError)return Center(child:Text('Firestore error: ${s.error}'));if(!s.hasData)return const Center(child:CircularProgressIndicator());if(s.data!.docs.isEmpty)return const Center(child:Text('No students yet. Add one in Q8.'));return ListView(children:s.data!.docs.map((d){final x=d.data();return ListTile(title:Text('${x['name']??'Unnamed'}'),subtitle:Text('Roll: ${x['roll']??'-'} • Course: ${x['course']??'-'}'));}).toList());}));}
}
