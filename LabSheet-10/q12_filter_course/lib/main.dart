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
    home: const FilterCoursePage(),
  );
}

class FilterCoursePage extends StatefulWidget{const FilterCoursePage({super.key});@override State<FilterCoursePage> createState()=>_FilterCoursePageState();}
class _FilterCoursePageState extends State<FilterCoursePage>{String course='BCA';@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q12 Filter by Course')),body:Column(children:[Padding(padding:const EdgeInsets.all(12),child:DropdownButtonFormField<String>(value:course,decoration:const InputDecoration(labelText:'Select course'),items:const ['BCA','B.Tech','MCA','BSc'].map((c)=>DropdownMenuItem(value:c,child:Text(c))).toList(),onChanged:(v)=>setState(()=>course=v!))),Expanded(child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('students').where('course',isEqualTo:course).snapshots(),builder:(context,s){if(s.hasError)return Text('Query error: ${s.error}');if(!s.hasData)return const Center(child:CircularProgressIndicator());if(s.data!.docs.isEmpty)return Center(child:Text('No students in $course'));return ListView(children:s.data!.docs.map((d)=>ListTile(title:Text('${d.data()['name']??''}),subtitle:Text('${d.data()['roll']??''}'))).toList());}))]));}
}
