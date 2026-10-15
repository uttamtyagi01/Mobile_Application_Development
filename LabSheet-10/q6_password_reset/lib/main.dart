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
    home: const ResetPage(),
  );
}

class ResetPage extends StatefulWidget {const ResetPage({super.key});@override State<ResetPage> createState()=>_ResetPageState();}
class _ResetPageState extends State<ResetPage>{final email=TextEditingController();String status='Enter your registered email.';Future<void> reset()async{try{await FirebaseAuth.instance.sendPasswordResetEmail(email:email.text.trim());setState(()=>status='Password reset email sent. Check your inbox.');}on FirebaseAuthException catch(e){setState(()=>status=e.message??e.code);}}
@override void dispose(){email.dispose();super.dispose();}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q6 Password Reset')),body:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Registered email')),FilledButton(onPressed:reset,child:const Text('Send reset email')),Text(status)])));
}
