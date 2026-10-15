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
    home: const NotesPage(),
  );
}

class NotesPage extends StatefulWidget{const NotesPage({super.key});@override State<NotesPage> createState()=>_NotesPageState();}
class _NotesPageState extends State<NotesPage>{final title=TextEditingController(),body=TextEditingController();final notes=FirebaseFirestore.instance.collection('notes');Future<void> add()async{if(title.text.trim().isEmpty)return;await notes.add({'title':title.text.trim(),'body':body.text.trim(),'createdAt':FieldValue.serverTimestamp()});title.clear();body.clear();}Future<void> edit(QueryDocumentSnapshot<Map<String,dynamic>> d)async{final c=TextEditingController(text:'${d.data()['title']??''}');final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Edit note title'),content:TextField(controller:c),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Save'))]));if(ok==true&&c.text.trim().isNotEmpty)await d.reference.update({'title':c.text.trim()});}
@override void dispose(){title.dispose();body.dispose();super.dispose();}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q14 Firestore Notes')),body:Column(children:[Padding(padding:const EdgeInsets.all(12),child:Column(children:[TextField(controller:title,decoration:const InputDecoration(labelText:'Note title')),TextField(controller:body,decoration:const InputDecoration(labelText:'Note body')),FilledButton(onPressed:add,child:const Text('Add note'))])),Expanded(child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:notes.orderBy('createdAt',descending:true).snapshots(),builder:(context,s){if(s.hasError)return Text('Error: ${s.error}');if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(children:s.data!.docs.map((d)=>ListTile(title:Text('${d.data()['title']??''}'),subtitle:Text('${d.data()['body']??''}'),onTap:()=>edit(d),trailing:IconButton(icon:const Icon(Icons.delete),onPressed:()=>d.reference.delete()))).toList());}))]));}
}
