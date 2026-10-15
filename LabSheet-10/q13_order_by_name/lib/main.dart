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
    home: const OrderStudentsPage(),
  );
}

class OrderStudentsPage extends StatelessWidget{const OrderStudentsPage({super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q13 Order Students by Name')),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('students').orderBy('name').snapshots(),builder:(context,s){if(s.hasError)return Center(child:Text('Query error: ${s.error}'));if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(children:s.data!.docs.map((d)=>ListTile(leading:const Icon(Icons.person),title:Text('${d.data()['name']??'Unnamed'}'),subtitle:Text('${d.data()['course']??''}'))).toList());}));}
}
