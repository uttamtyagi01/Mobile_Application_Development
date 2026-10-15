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
    home: const StudentManagementPage(),
  );
}

class StudentManagementPage extends StatefulWidget{const StudentManagementPage({super.key});@override State<StudentManagementPage> createState()=>_StudentManagementPageState();}
class _StudentManagementPageState extends State<StudentManagementPage>{final name=TextEditingController(),roll=TextEditingController(),course=TextEditingController();final db=FirebaseFirestore.instance.collection('students');String? editingId;String status='Add or edit student records.';
Future<void> save()async{if(name.text.trim().isEmpty){setState(()=>status='Name is required.');return;}final data={'name':name.text.trim(),'roll':roll.text.trim(),'course':course.text.trim(),'updatedAt':FieldValue.serverTimestamp()};try{if(editingId==null){await db.add({...data,'createdAt':FieldValue.serverTimestamp()});setState(()=>status='Student added.');}else{await db.doc(editingId).update(data);setState(()=>status='Student updated.');}name.clear();roll.clear();course.clear();setState(()=>editingId=null);}catch(e){setState(()=>status='Error: $e');}}
void select(QueryDocumentSnapshot<Map<String,dynamic>> d){final x=d.data();name.text='${x['name']??''}';roll.text='${x['roll']??''}';course.text='${x['course']??''}';setState(()=>editingId=d.id);}
@override void dispose(){name.dispose();roll.dispose();course.dispose();super.dispose();}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q15 Firebase Student Management')),body:Column(children:[Padding(padding:const EdgeInsets.all(12),child:Column(children:[TextField(controller:name,decoration:const InputDecoration(labelText:'Name')),TextField(controller:roll,decoration:const InputDecoration(labelText:'Roll number')),TextField(controller:course,decoration:const InputDecoration(labelText:'Course')),Row(children:[Expanded(child:FilledButton(onPressed:save,child:Text(editingId==null?'Add student':'Update student'))),if(editingId!=null)TextButton(onPressed:(){name.clear();roll.clear();course.clear();setState(()=>editingId=null);},child:const Text('Cancel'))]),Text(status)])),Expanded(child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:db.orderBy('name').snapshots(),builder:(context,s){if(s.hasError)return Text('Firestore error: ${s.error}');if(!s.hasData)return const Center(child:CircularProgressIndicator());return ListView(children:s.data!.docs.map((d)=>ListTile(title:Text('${d.data()['name']??''}'),subtitle:Text('${d.data()['roll']??''} • ${d.data()['course']??''}'),onTap:()=>select(d),trailing:IconButton(icon:const Icon(Icons.delete),onPressed:()=>d.reference.delete()))).toList());}))]));}
}
