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
    home: const UpdateStudentPage(),
  );
}

class UpdateStudentPage extends StatelessWidget{const UpdateStudentPage({super.key});Future<void> edit(BuildContext context,QueryDocumentSnapshot<Map<String,dynamic>> doc)async{final c=TextEditingController(text:'${doc.data()['name']??''}');final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Update student name'),content:TextField(controller:c,decoration:const InputDecoration(labelText:'Name')),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Save'))]));if(ok==true&&c.text.trim().isNotEmpty){await doc.reference.update({'name':c.text.trim()});}}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q10 Update Firestore Student')),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('students').snapshots(),builder:(context,s){if(s.hasError)return Text('Error: ${s.error}');if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(children:s.data!.docs.map((d)=>ListTile(title:Text('${d.data()['name']??'Unnamed'}'),subtitle:Text('${d.data()['course']??''}'),trailing:IconButton(icon:const Icon(Icons.edit),onPressed:()=>edit(context,d)))).toList());}));}
}
