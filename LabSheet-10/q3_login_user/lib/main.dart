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
    home: const LoginPage(),
  );
}

class LoginPage extends StatefulWidget { const LoginPage({super.key}); @override State<LoginPage> createState()=>_LoginPageState(); }
class _LoginPageState extends State<LoginPage> {
 final email=TextEditingController(),password=TextEditingController(); String message='Sign in with your Firebase account.';
 Future<void> login() async {try{final c=await FirebaseAuth.instance.signInWithEmailAndPassword(email:email.text.trim(),password:password.text);setState(()=>message='Signed in as ${c.user?.email}');}on FirebaseAuthException catch(e){setState(()=>message=e.message??e.code);}}
 @override void dispose(){email.dispose();password.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q3 Login User')),body:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[TextField(controller:email,decoration:const InputDecoration(labelText:'Email')),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password')),FilledButton(onPressed:login,child:const Text('Login')),Text(message)])));
}
