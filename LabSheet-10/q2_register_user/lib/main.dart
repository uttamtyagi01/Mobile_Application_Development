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
    home: const RegisterPage(),
  );
}

class RegisterPage extends StatefulWidget { const RegisterPage({super.key}); @override State<RegisterPage> createState()=>_RegisterPageState(); }
class _RegisterPageState extends State<RegisterPage> {
 final email=TextEditingController(), password=TextEditingController(); String message='Create an account with email and password.'; bool busy=false;
 Future<void> register() async { setState(()=>busy=true); try { final c=await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email.text.trim(),password:password.text); setState(()=>message='Account created for ${c.user?.email}.'); } on FirebaseAuthException catch(e){setState(()=>message=e.message??e.code);} finally {if(mounted)setState(()=>busy=false);} }
 @override void dispose(){email.dispose();password.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q2 Register User')),body:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email')),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password (6+ characters)')),const SizedBox(height:16),FilledButton(onPressed:busy?null:register,child:Text(busy?'Registering…':'Register')),Text(message)])));
}
