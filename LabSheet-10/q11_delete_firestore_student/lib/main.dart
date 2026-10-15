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
    home: const DeleteStudentPage(),
  );
}

class DeleteStudentPage extends StatelessWidget{const DeleteStudentPage({super.key});Future<void> remove(BuildContext context,QueryDocumentSnapshot<Map<String,dynamic>> doc)async{final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Delete student?'),content:Text('Delete ${doc.data()['name']??'this record'} permanently?'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Delete'))]));if(ok==true)await doc.reference.delete();}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q11 Delete Student')),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('students').snapshots(),builder:(context,s){if(s.hasError)return Text('Error: ${s.error}');if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(children:s.data!.docs.map((d)=>ListTile(title:Text('${d.data()['name']??'Unnamed'}'),trailing:IconButton(icon:const Icon(Icons.delete,color:Colors.red),onPressed:()=>remove(context,d)))).toList());}));}
}
